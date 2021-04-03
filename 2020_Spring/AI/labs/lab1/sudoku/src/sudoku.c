#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int num[9][9];
typedef struct node
{
	int col;
	int row;
	int value[10];
}Node;

int FindValue(int num[9][9], Node * node)
{
	int m, n;
    int i = node->col;
    int j = node->row;
	for (m = 1; m < 10; m ++)
	{
		if (node->value[num[i][m-1]] == 0)
			node->value[num[i][m-1]] = num[i][m-1];   // 行检查
		if (node->value[num[m-1][j]] == 0)
			node->value[num[m-1][j]] = num[m-1][j];   // 列检查
	}
	for (m = 0; m < 3; m ++)                       // 粗线宫
		for (n = 0; n < 3; n ++)
			if (node->value[num[i/3*3+m][j/3*3+n]] == 0)
				node->value[num[i/3*3+m][j/3*3+n]] = num[i/3*3+m][j/3*3+n];
    for (m = 0; m < 9; m ++)        // 对角线
    {
        if (i == j)
        {
            if ((i - m) >= 0)
            {
                if (node->value[num[i-m][j-m]] == 0)
                    node->value[num[i-m][j-m]] = num[i-m][j-m];
            }
            if ((i + m) < 9)
            {
                if (node->value[num[i+m][j+m]] == 0)
                    node->value[num[i+m][j+m]] = num[i+m][j+m];
            }
        }
        if ((i + j) == 8)
        {
            if ((i - m) >= 0 && (j + m) < 9)
            {
                if (node->value[num[i-m][j+m]] == 0)
                    node->value[num[i-m][j+m]] = num[i-m][j+m];
            }
            if ((i + m) < 9 && (j - m) >= 0)
            {
                if(node->value[num[i+m][j-m]] == 0)
                    node->value[num[i+m][j-m]] = num[i+m][j-m];
            }
        }
    }

	for (m = 1; m < 10; m ++)
		if (node->value[m] == 0)
			node->value[0] ++;
	for(m = 1; m < 10; m ++)
		if(node->value[m] == 0)
			break;

	if(node->value[0] == 0)    // 没有适合的值
		return -1;
	else
		return m;
	
}


void ReplaceString(char *result, char *source)   // 替换字符串，用来自动修改保存结果路径
{
    char *oldstr = (char*) "input";
    char *newstr = (char*) "output";
    char *p = NULL;
    char *q = NULL;
    p = source;
    while((q = strstr(p, oldstr)) != NULL)
    {
        strncpy(result, p, q-p);
        result[p-q] = '\0';
        strcat(result, newstr);
        strcat(result, q + strlen(oldstr));
        strcpy(p, result);
    }
    strcpy(result, p);
}

int main(void)
{
    int begin, end;
	FILE *fp1, *fp2;                   // 读、写文件指针
    int i, j;
    char fileName[50];
    char writeObject[50];
    memset(num, 0, sizeof(int));
    memset(writeObject, 0, sizeof(writeObject));
    printf("Please enter the sudoku test path and name, such as ..\\input\\sudoku01.txt:\n");
    scanf("%s", fileName);
    begin = clock();
    fp1 = fopen(fileName, "r");
    if (fp1 == NULL)
    {
        printf("ERROR! No such file: %s\n", fileName);
        return -1;
    }
    for (i = 0; i < 9; i ++)
    {
        for (j = 0; j < 9; j ++)
        {
            fscanf(fp1, "%d", &num[i][j]);
        }
    }
    fclose(fp1);
    ReplaceString(writeObject, fileName);

	int k = 0, num_of_empty = 0;
	int index, temp = 0;
	for (i = 0; i < 9; i ++)                //计算所给数独中待填入的空白数
		for (j = 0; j < 9; j ++)
			if (num[i][j] == 0)
				num_of_empty ++;

	Node * node_stack = (Node *)malloc(sizeof(struct node) * num_of_empty);   //为回溯栈分配空间
	while (num_of_empty)           //回溯法求解数独
	{
		for (i = 0; i < 9; i ++)
			for (j = 0; j < 9; j ++)
				if (num[i][j] == 0)
			    {
					for (index = 0; index < 10; index ++)          //初始化栈中存储候选值的数组
						(node_stack + k)->value[index] = 0;
					(node_stack + k)->col = i;
					(node_stack + k)->row = j;
					num[i][j] = FindValue(num, node_stack + k);
					if (num[i][j] == -1)
					{
						num[i][j] = 0;
						k--;
						while ((node_stack + k)->value[0] == 1)
						{
							num[(node_stack + k)->col][(node_stack + k)->row] = 0;
							num_of_empty ++;
							k --;
						}
						(node_stack + k)->value[0] --;
						i = (node_stack + k)->col;
						j = (node_stack + k)->row;
						for (index = 1; index < 10; index ++)
							if((node_stack + k)->value[index] == 0)
							{
								(node_stack + k)->value[index] = -1;
								break;
							}
						for(index = 1; index < 10; index ++)
							if((node_stack + k)->value[index] == 0)
							{
								num[i][j] = index;
								break;
							}
					}
					k++;
				}
		if(k==0)              //当栈空，说明数独错误，无解
		{
			printf("The sudoku has no solution\n");
			free(node_stack);
			return 0;
		}
		num_of_empty--;
	}
	free(node_stack);
	
    fp2 = fopen(writeObject, "w");
    if (fp2 == NULL)
    {
        printf("ERROR! Can not write to object: %s\n", writeObject);
        return -1;
    }
    for (i = 0; i < 9; i ++)
    {
        for (j = 0; j < 9; j ++)
        {
            fprintf(fp2, "%d ", num[i][j]);
        }
        fprintf(fp2, "\n");
    }
    fclose(fp2);
    printf("Successfully solve Sudoku problem, please check in %s\n", writeObject);
    end = clock();
    printf("Excuting time:%d ms\n", end - begin);
    system("pause");
    return 0;
}