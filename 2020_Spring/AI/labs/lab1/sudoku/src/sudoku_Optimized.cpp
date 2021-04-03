// 优化后的
#include <iostream>
#include <vector>
#include <cstring>
#include <algorithm>
#include <time.h>
using namespace std;  

int num[10][10];
int domain[9][9][10];  // domain[i][j][0]表示[i][j]格子可选值数量, domain[i][j][k]表示格子[i][j]可填入k

void SetCell(int line, int row, int number, int (*num)[10])    // 给num[line][row]设置为number,并前向检验
{
    num[line][row] = number;
    int bi = (line / 3) * 3;  // 取值0, 3, 6
    int bj = (row / 3) * 3;   // 取值0, 3, 6
    int k;
    for (k = 0; k < 9; k ++)
    {
        domain[line][k][0] -= domain[line][k][number];
        domain[line][k][number] = 0;     // 与填入number的格子同行的格子不能再填入number
        domain[k][row][0] -= domain[k][row][number];
        domain[k][row][number] = 0;     // 同列的格子不能重复
        domain[bi + (k / 3)][bj + (k % 3)][0] -= domain[bi + (k / 3)][bj + (k % 3)][number];  // 粗线宫不重复
        domain[bi + (k / 3)][bj + (k % 3)][number] = 0;
        if (line == row)         // 九宫格对角线上不重复
        {
            if (((line - k) >= 0) && ((row - k) >= 0))
            {
                domain[line-k][row-k][0] -= domain[line-k][row-k][number];
                domain[line-k][row-k][number] = 0;
            }
            else if (((line + k) < 9) && ((row + k) < 9))
            {
                domain[line+k][row+k][0] -= domain[line+k][row+k][number];
                domain[line+k][row+k][number] = 0;
            }
        }
        else if ((line + row) == 8)
        {
            if (((line - k) >= 0) && ((row + k) < 9))
            {
                domain[line-k][row+k][0] -= domain[line-k][row+k][number];
                domain[line-k][row+k][number] = 0;
            }
            else if (((line + k) < 9) && ((row - k) >= 0))
            {
                domain[line+k][row-k][0] -= domain[line+k][row-k][number];
                domain[line+k][row-k][number] = 0;
            }
        }
    }
}

void InitDomin(int (*num)[10])  // 根据num初始化domain
{
    int i, j, k;
    for (i = 0; i < 9; i ++)                // 起初每个格子都可以取0~9中任意一个值
    {
        for (j = 0; j < 9; j ++)
        {
            domain[i][j][0] = 9;
            for (k = 1; k <= 9; k ++)
            {
                domain[i][j][k] = 1;
            }
        }
    }
    for (i = 0; i < 9; i ++)
    {
        for (j = 0; j < 9; j ++)
        {
            if (num[i][j] != 0)
            {
                SetCell(i, j, num[i][j], num);   // 给数独格子上(i+1,j+1)处填入初始值num[i][j]
            }
        }
    }
}

pair<int, int> MRVSelectCell(int (*num)[10])     // MRV，可用二叉树优化成lgn 返回MRV启发式选择的插入数据位置
{
    int line = -1;
    int row = -1;
    int choices = 10;       // 该格子可供选择数据个数
    int i, j;
    for (i = 0; i < 9; i ++)
    {
        for (j = 0; j < 9; j ++)
        {
            if ((num[i][j] == 0) && domain[i][j][0] < choices)
            {
                line = i;
                row = j;
                choices = domain[i][j][0];
            }
        }
    }
    return{line, row};
}

int FillCell(int  (*num)[10])       // 开始填格子，不成功则回溯
{
    pair<int, int> cell;
    cell = MRVSelectCell(num);
    if ((cell.first == -1) && (cell.second == -1))    // 没有可以供填充的格子，数独解题已经完成
        return 1;
    else if (domain[cell.first][cell.second][0] == 0)       // 待填充的格子没有可以填充的数字，此题无解
        return 0;
    int tempDomain[9][9][10];
    memcpy(tempDomain, domain, sizeof(domain));
    for (int data = 1; data <= 9; data ++)      // 遍历可以填入空格的数字
    {
        if (domain[cell.first][cell.second][data] == 1)
        {
            SetCell(cell.first, cell.second, data, num);
            if (FillCell(num) == 1)                  // 递归
            {
                return 1;
            }
            memcpy(domain, tempDomain, sizeof(domain));    // 回溯
        }
    }
    num[cell.first][cell.second] = 0;        // 无解
    return 0;
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
    int begin, end;
    FILE *fp1, *fp2;                   // 读、写文件指针
    int i, j, k;
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

    int result = 0;
    InitDomin(num);
    result = FillCell(num);
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
    if (result == 1)
        printf("Successfully solve Sudoku problem, please check %s\n",writeObject);
    else
    {
        printf("The sudoku problem has no solution\n");
    }
    end = clock();
    printf("Excuting time:%d ms\n", end - begin);
    system("pause");
    return 0;
}