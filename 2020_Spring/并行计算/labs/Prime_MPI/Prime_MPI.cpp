#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#define MAX 1000

typedef struct {
    int vertices_number;
    int* adjacency_matrix;
} Graph;

int Get_Min(const int* dis, const int* flag, int n);

int min(int a, int b)
{
    if (a >= b)
    {
        return b;
    }
    return a;
}

/**
 * Using dijkstra algorithm to calculate the shortest distance between vertices
 *
 * @param graph Graph struct
 * @param start start number of the vertex that calculates the shortest distance
 * @param end end number of the vertex that calculates the shortest distance
 * @return
 */
int* Dijkstra(Graph* graph, int start, int end) {
    int n = graph->vertices_number;
    int* local_result = (int*)malloc(sizeof(int) * (end - start + 1) * n);
    memcpy(local_result, graph->adjacency_matrix + start * n, (end - start + 1) * n * sizeof(int));
    int* mark = (int*)malloc(sizeof(int) * n);
    int vertex_no = start;
    for (; vertex_no <= end; vertex_no++) {
        memset(mark, 0, sizeof(int) * n);
        int i = 0;
        while (i++ < n) {
            int offset = (vertex_no - start) * n;
            int vertex = Get_Min(local_result + offset, mark, n);
            mark[vertex] = 1;
            int j = 0;
            for (; j < n; j++) {
                if (mark[j] == 1) {
                    continue;
                }
                // updating distance
                if (local_result[offset + vertex] + graph->adjacency_matrix[vertex * n + j] <
                    local_result[offset + j]) {
                    local_result[offset + j] = local_result[offset + vertex] + graph->adjacency_matrix[vertex * n + j];
                }
            }
        }
    }
    return local_result;
}

/**
 * @param dis int pointer
 * @param flag Used to mark whether the element needs to be skipped
 * @param n number of elements to check
 * @return
 */
int Get_Min(const int* dis, const int* flag, int n) {
    int min_dis_vertex = 0;
    int min_dis = dis[0];
    int i = 1;
    for (; i < n; i++) {
        if (flag[i] == 1) {
            continue;
        }
        if (dis[i] < min_dis) {
            min_dis = dis[i];
            min_dis_vertex = i;
        }
    }
    return min_dis_vertex;
}

/**
 *
 * Reading Weight Matrix from Binary File.
 * In order to process data conveniently on mpi, one-dimensional array is used to preserve the weight of matrix.
 *
 * @param input_file_name input file name
 * @return one-dimensional inteter array
 */
void* Read_Adjacency_Matrix(const char* input_file_name, Graph* graph) {
    FILE* input_f = fopen(input_file_name, "rb");
    if (input_f == NULL) {
        fprintf(stderr, "failure to open file %s!\n", input_file_name);
        exit(1);
    }
    fscanf(input_f, "%d", &graph->vertices_number);
    int n = graph->vertices_number;

    int i;
    graph->adjacency_matrix = (int*)malloc(sizeof(int) * n * n);
    for (i = 0; i < n * n; i++)
    {
        fscanf(input_f, "%d", &graph->adjacency_matrix[i]);
    }
    fclose(input_f);
}

/**
 * Save results to file
 * @param shortest_distance
 * @param vertices_number
 * @param fname
 */
void Write_Graph(const int* shortest_distance, int vertices_number, const char* fname) {
    FILE* out_f = fopen(fname, "wb");
    if (out_f == NULL) {
        fprintf(stderr, "Failure to open file %s!\n", fname);
        exit(1);
    }
    fprintf(out_f, "Vertex Number: %d\n", vertices_number);
    int n = vertices_number;
    int i, j, k = 0;
    int print_result[MAX][MAX];
    for (i = 0; i < n; i++)
    {
        for (j = 0; j < n; j++)
        {
            print_result[i][j] = shortest_distance[k++];
        }
    }
    for (i = 0; i < n; i++)
    {
        for (j = 0; j < n; j++)
        {
            print_result[i][j] = min(print_result[i][j], print_result[j][i]);
            fprintf(out_f, "%d ", print_result[i][j]);
        }
        fprintf(out_f, "\n");
    }
    fclose(out_f);
}

/**
 * collect the results of each process to the root process
 *
 * @param vertices_number
 * @param shortest_dis_apart results of a single process
 * @param result
 * @param size result size
 * @param parallelize_size
 */
void Collect_Data(int vertices_number, int* shortest_dis_apart, int* result, int size, int parallelize_size) {
    int intvl = vertices_number / parallelize_size;
    int* start_pos_each_process = (int*)malloc(sizeof(int) * parallelize_size);
    int* length_each_process = (int*)malloc(sizeof(int) * parallelize_size);
    // calculate the starting position of each process result data store
    int i = 0;
    for (; i < parallelize_size; i++) {
        start_pos_each_process[i] = intvl * vertices_number * i;
    }
    // calculate the size of the result data for each process
    i = 0;
    for (; i < parallelize_size - 1; i++) {
        length_each_process[i] = intvl * vertices_number;
    }
    length_each_process[parallelize_size - 1] = (vertices_number - intvl * (parallelize_size - 1)) * vertices_number;
    // collect the results of each process to the root process
    MPI_Gatherv(shortest_dis_apart, size, MPI_INT, result, length_each_process, start_pos_each_process, MPI_INT, 0,
        MPI_COMM_WORLD);
}

int main(int argc, char* argv[]) {
    clock_t start_time, finish_time;
    MPI_Init(&argc, &argv);
    const char* input_file_name = "input.txt";
    const char* output_file_name = "output.txt";

    // read parallelize size
    int parallelize_size;
    MPI_Comm_size(MPI_COMM_WORLD, &parallelize_size);

    // read the number of the current process
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    // save the results of all process rollups
    int* result = 0;

    Graph graph;
    int n;
    if (rank == 0) {
        // read graph data in the root process
        Read_Adjacency_Matrix(input_file_name, &graph);
        n = graph.vertices_number;
        result = (int*)malloc(sizeof(int) * n * n);
        // record time in the root process
        start_time = clock();
    }
    // broadcast number of vertex to all other processes
    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
    if (rank != 0) {
        graph.vertices_number = n;
        graph.adjacency_matrix = (int*)malloc(sizeof(int) * n * n);
    }
    // broadcast weight matrix to all other processes.
    // Then calculate the shortest distance between each vertex in a distributed way
    MPI_Bcast(graph.adjacency_matrix, n * n, MPI_INT, 0, MPI_COMM_WORLD);
    // number of vertices to process per process
    int interval_size = n / parallelize_size;
    // vertex interval
    int range_start = interval_size * rank;
    int range_end = interval_size * rank + interval_size - 1;
    // number of vertices to be processed by the last process may not be equal to the interval.
    if (rank == parallelize_size - 1) {
        range_end = n - 1;
    }
    int* result_a_process = Dijkstra(&graph, range_start, range_end);
    Collect_Data(n, result_a_process, result, (range_end - range_start + 1) * n, parallelize_size);
    if (rank == 0) {
        // record time in the root process
        finish_time = clock();
        double duration = (finish_time - start_time * 1.0) / CLOCKS_PER_SEC;
        printf("n: %d, elapsed time: %.2f seconds\n", parallelize_size, duration);
        Write_Graph(result, n, output_file_name);
    }
    MPI_Finalize();
    return 0;
}