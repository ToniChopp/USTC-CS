// 普通A*搜索
#include <iostream>
#include <vector>
#include <cstring>
#include <algorithm>
#include <time.h>
#include <cstdio>
#include <cstdlib>
#include <queue>
#include <list>
#include <unordered_set>
using namespace std;

#define CHECK(X, Y, N) (isValid((X), (Y)) && N->state[(X)][(Y)] == 0)
#define CHECK_EQUAL_MAX_DEPTH 50
#define STEP_COST 10

FILE *fp2;       // 写回文件
long int startTime;
long int endTime;

struct Position{         // 位置
    int x;
    int y;
};

typedef struct Node{
    char state[5][5];
    struct Position sevenPos = {-1, -1};       // 7的位置
    int fValue = 0;
    int gValue = 0;
    int hValue = 0;
    Node *parent = nullptr;
    char movement = 'u';          // 移动方式
    int num = 0;                // 移动的数字
    std::string stateKey;
}Node;

int gWeight[25];      // 权值，可以在main里做调参处理


const struct Position MoveType[] = {   // 移动方式数字化表示
    {1, 0},
    {0, -1},
    {-1, 0},
    {0, 1}
};

const char MoveTypeChar[] = {'u', 'r', 'd', 'l'};

struct Position FinalState[25];        // 最终状态

struct NodeCompare{                   // A*搜索代价大小比较
    bool operator() (Node *a, Node *b)
    {
        return (a->fValue > b->fValue);
    }
};

inline int Max (int a, int b)
{
    if (a >= b)
        return a;
    return b;
}

int CalculateNodeCost(Node *node, int gValue)       // 计算g, h, f
{
    int temp = 0;
    int digit;
    struct Position sevenPosition = {-1, -1};
    int i, j;

    node->gValue = gValue;   //g

    for (i = 0; i < 5; i ++)   // 计算曼哈顿距离
    {
        for (j = 0; j < 5; j ++)
        {
            if ((digit = node->state[i][j]) != 0)       // 此处不为空
            {
                if (sevenPosition.x == -1 && digit == 7)     // 首次发现7的位置,7的左上角
                {
                    sevenPosition.x = i;
                    sevenPosition.y = j;
                    temp += gWeight[digit] * (abs(FinalState[digit].x - i) + abs(FinalState[digit].y - j));
                }
                else if (digit != 7)
                {
                    temp += gWeight[digit] * (abs(FinalState[digit].x - i) + abs(FinalState[digit].y - j));
                }
            }
        }
    }
    node->hValue = temp;       // h

    node->fValue = node->gValue + node->hValue;   // f
    node->sevenPos = sevenPosition;
    return node->fValue;
}

// Generate State key.
void GenerateStateKey(Node *node)            // 为了做 unordered_set 的 Hash
{
    char tmp_str[26];

    for (int i = 0; i < 5; i++)
        for (int j = 0; j < 5; j++)
            tmp_str[i * 5 + j] = (char)(node->state[i][j] + 'A');
    
    tmp_str[25] = '\0';

    node->stateKey = tmp_str;
}

int step = 0;
void PrintToFile(FILE *fp, Node *node) // 将结果打印到文件中
{
    int k = step;
    if (node->parent)
    {
        step ++;
        PrintToFile(fp, node->parent);
    }
    else
    {
        fprintf(fp, "Total steps: %d\n", step);
        printf("\n Total steps: %d\n", step);
        return;
    }
    if ((step - k) % 4 != 0)
    {
        fprintf(fp, "(%d, %c)\t\t", node->num, node->movement);
        printf("(%d, %c)\t\t", node->num, node->movement);
    }
    else
    {    
        fprintf(fp, "(%d, %c)\n", node->num, node->movement);
        printf("(%d, %c)\n", node->num, node->movement);
    }
}

std::priority_queue<Node *, std::vector<Node *>, NodeCompare> nodePQueue;           // 优先级队列容器
std::unordered_set<std::string> closedSet;
int minH = 2147483647;                           // 31'b1

inline bool isValid(int x, int y)                // 判断是否在区域内
{
    return ((x >= 0) && (x < 5) && (y >= 0) && (y < 5));
}

inline bool isEqual(Node *a, Node *b)
{
    return (a->stateKey == b->stateKey);
}

inline bool haveVisited(Node *node)           // 防止某种状态循环出现
{
    return (closedSet.find(node->stateKey) != std::end(closedSet));
}

int MakeNode(Node *des, Node *src, int x, int y, int moveType)
{
    int state[5][5];
    des->parent = src;
    int i, j;
    for (i = 0; i < 5; i ++)
    {
        for (j = 0; j < 5; j ++)
        {
            state[i][j] = src->state[i][j];
        }
    }
    bool isSeven = (state[x][y] == 7);
    if (isSeven)                                   // 7的移动方式
    {
        if (moveType == 0)
        {
            state[x - 1][y] = 7, state[x - 1][y + 1] = 7;
            state[x][y] = 0, state[x + 1][y + 1] = 0;
        }
        else if (moveType == 1)
        {
            state[x][y] = 0, state[x + 1][y + 1] = 0;
            state[x][y + 2] = 7, state[x + 1][y + 2] = 7;
        }
        else if (moveType == 2)
        {
            state[x][y] = 0, state[x][y + 1] = 0;
            state[x + 1][y] = 7, state[x + 2][y + 1] = 7;
        }
        else if (moveType == 3)
        {
            state[x][y + 1] = 0, state[x + 1][y + 1] = 0;
            state[x][y - 1] = 7, state[x + 1][y] = 7;
        }
        des->num = 7;
        des->movement = MoveTypeChar[moveType];
    }
    else
    {
        des->num = state[x][y];
        des->movement = MoveTypeChar[moveType];
        state[x - MoveType[moveType].x][y - MoveType[moveType].y] = state[x][y];
        state[x][y] = 0;
    }

    for (i = 0; i < 5; i ++)
    {
        for (j = 0; j < 5; j ++)
        {
            des->state[i][j] = state[i][j];
        }
    }
    GenerateStateKey(des);
    if (haveVisited(des))
    {
        return -1;
    }
    closedSet.insert(des->stateKey);
    CalculateNodeCost(des, src->gValue + STEP_COST);     // 增加了step cost
    if (des->hValue == 0)        // 找到了最终结果
    {
        printf("Find solution!:\n");
        PrintToFile(fp2, des);
        printf("\n");
        fclose(fp2);
        endTime = clock();
        printf("Excuting time: %ld ms\n", endTime - startTime);
        exit(0);
    }
    return 0;
}

void Search()
{
    Node *now;
    Node *nextNode;
    int status;

    while (!nodePQueue.empty())
    {
        now = nodePQueue.top();
        nodePQueue.pop();
        if (now->hValue <= minH)
        {
            minH = now->hValue;
        }
        bool canMoveSeven = true;
        int sevenX = now->sevenPos.x;
        int sevenY = now->sevenPos.y;
        nextNode = new Node;
        if (CHECK(sevenX - 1, sevenY, now) && CHECK(sevenX - 1, sevenY + 1, now))       // 检查7能否移动
            // (7, 0)
            status = MakeNode(nextNode, now, sevenX, sevenY, 0);
        else if (CHECK(sevenX, sevenY + 2, now) && CHECK(sevenX + 1, sevenY + 2, now))
            // (7, 1)
            status = MakeNode(nextNode, now, sevenX, sevenY, 1);
        else if (CHECK(sevenX + 1, sevenY, now) && CHECK(sevenX + 2, sevenY + 1, now))
            // (7, 2)
            status = MakeNode(nextNode, now, sevenX, sevenY, 2);
        else if (CHECK(sevenX, sevenY - 1, now) && CHECK(sevenX + 1, sevenY, now))
            // (7, 3)
            status = MakeNode(nextNode, now, sevenX, sevenY, 3);
        else
            canMoveSeven = false;

        if (canMoveSeven && status != -1)
            nodePQueue.emplace(nextNode);
        else
            delete nextNode;      // 失败，回溯

        for (int i = 0; i < 5; i++)            // 普通数字的移动
        {
            for (int j = 0; j < 5; j++)
            {
                if (now->state[i][j] == 0)
                {
                    for (int k = 0; k < 4; k++)
                    {
                        int testX, testY;
                        testX = i + MoveType[k].x, testY = j + MoveType[k].y;
                        if (isValid(testX, testY) && 
                            now->state[testX][testY] != 0 &&
                            now->state[testX][testY] != 7)
                        {
                            // (state[testX][testY], k)
                            nextNode = new Node;
                            if (MakeNode(nextNode, now, testX, testY, k) != -1)
                                nodePQueue.emplace(nextNode);
                            else
                                delete nextNode;
                        }
                    }
                }
            }
        }
    }
    long int stopTime = clock();
    printf("Can not find a solution\n");
    printf("Searchint takes %ld ms\n", stopTime - startTime);
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

int main()
{
    FILE *fp1;                   // 读、写文件指针
    FILE *resultp;
    int result[5][5];
    int i, j, k;
    char fileNameInput[50];
    char fileNameResult[50];
    char writeObject[50];
    memset(writeObject, 0, sizeof(writeObject));
    Node *initNode;
    initNode = new Node;

    int tmp[5];
    printf("Please enter the digit test path and name, such as ..\\input\\1.txt:\n");  // 测试输入
    scanf("%s", fileNameInput);
    fp1 = fopen(fileNameInput, "r+");
    if (fp1 == NULL)
    {
        printf("ERROR! No such file: %s\n", fileNameInput);
        return -1;
    }
    for (i = 0; i < 5; i ++)
    {
        fscanf(fp1, "%d,%d,%d,%d,%d", &tmp[0], &tmp[1], &tmp[2], &tmp[3], &tmp[4]);
        for (j = 0; j < 5; j ++)
        {
            initNode->state[i][j] = (char)(tmp[j]);
        }
    }
    printf("Scanning the input file: %s\n", fileNameInput);
    fclose(fp1);
    ReplaceString(writeObject, fileNameInput);

    int flag[25];                    // 最终结果输入，并存储状态
    for (i = 0; i < 25; i ++)
    {
        FinalState[i].x = 0;
        FinalState[i].y = 0;
        flag[i] = 0;
        gWeight[i] = 10;    
    }
    gWeight[0] = 0;
    
    printf("Please enter the result state path and name, e.g. ..\\input\\result.txt:\n");
    scanf("%s", fileNameResult);
    startTime = clock();
    resultp = fopen(fileNameResult, "r");
    if (resultp == NULL)
    {
        printf("ERROR! No such file: %s\n", fileNameResult);
        return -1;
    }
    for (i = 0; i < 5; i ++)
    {
        for (j = 0; j < 5; j ++)
        {
            fscanf(resultp, "%d,", &result[i][j]);
            if (flag[result[i][j]] == 0)
            {
                FinalState[result[i][j]] = {i, j};
                flag[result[i][j]] = 1;
            }           
        }
    }
    printf("Scanning the input result file: %s\n", fileNameResult);
    FinalState[0] = {0, 0};
    fp2 = fopen(writeObject, "w");
    if (fp2 == NULL)
    {
        printf("ERROR! Can not write to object: %s\n", writeObject);
        return -1;
    }
    
    CalculateNodeCost(initNode, 0);       // 计算初始 f, g, h
    printf("initf: %d  initg: %d  inith: %d\n", initNode->fValue, initNode->gValue, initNode->hValue);
    GenerateStateKey(initNode);
    printf("init stateKey: %s\n", initNode->stateKey);
    closedSet.insert(initNode->stateKey);
    nodePQueue.emplace(initNode);
    Search();
    fclose(fp2);

    return 0;
}
