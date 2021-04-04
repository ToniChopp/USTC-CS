#include <assert.h>
#include <errno.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define FUSE_USE_VERSION 26
#include <fuse.h>

#include "fat16.h"

char *FAT_FILE_NAME = "fat16.img";

/* 将扇区号为secnum的扇区读到buffer中 */
void sector_read(FILE *fd, unsigned int secnum, void *buffer) {
  fseek(fd, BYTES_PER_SECTOR * secnum, SEEK_SET);
  fread(buffer, BYTES_PER_SECTOR, 1, fd);
}

/** TODO:
 * 返回簇号为ClusterN对应的FAT表项
**/
WORD fat_entry_by_cluster(FAT16 *fat16_ins, WORD ClusterN) 
{
  BYTE sector_buffer[BYTES_PER_SECTOR];
  FILE *fd;
  fd = fopen(FAT_FILE_NAME, "rb");
  if (fd == NULL) 
  {
    fprintf(stderr, "Missing FAT16 image file!\n");
    exit(EXIT_FAILURE);
  }
  WORD start_sec = fat16_ins->Bpb.BPB_RsvdSecCnt;           
  WORD items_per_fat = BYTES_PER_SECTOR / 2;
  WORD secnum = start_sec + ClusterN / items_per_fat;             //the number of sector
  WORD offset = ClusterN % items_per_fat;               //在扇区中的偏移量

  sector_read(fd, secnum, sector_buffer);

  BYTE high = sector_buffer[2 * offset + 1];
  BYTE low = sector_buffer[2 * offset];
  WORD content = (high << 8) + low;

  return content;
}

/**
 * 根据簇号ClusterN，获取其对应的第一个扇区的扇区号和数据，以及对应的FAT表项
**/
void first_sector_by_cluster(FAT16 *fat16_ins, WORD ClusterN,WORD *FatClusEntryVal, WORD *FirstSectorofCluster,
                             BYTE *buffer) 
{
  *FatClusEntryVal = fat_entry_by_cluster(fat16_ins, ClusterN);
  *FirstSectorofCluster = ((ClusterN - 2) * fat16_ins->Bpb.BPB_SecPerClus) +
                          fat16_ins->FirstDataSector;                     //(ClusterN - 2) * 4 + 156

  sector_read(fat16_ins->fd, *FirstSectorofCluster, buffer);
}

/** TODO:
 * 将输入路径按“/”分割成多个字符串，并按照FAT文件名格式转换字符串
 *
 * Hint1:假设pathInput为“/dir1/dir2/file.txt”，则将其分割成“dir1”，“dir2”，“file.txt”，
 *      每个字符串转换成长度为11的FAT格式的文件名，如“file.txt”转换成“FILE
 *TXT”，
 *      返回转换后的字符串数组，并将*pathDepth_ret设置为3
 * Hint2:可能会出现过长的字符串输入，如“/.Trash-1000”，需要自行截断字符串
**/
char **path_split(char *pathInput, int *pathDepth_ret) 
{
  int pathDepth = 1;
  char **paths = (char **)malloc(pathDepth * sizeof(char *));

  if (strcmp(pathInput, "/") == 0) 
  {
                                  // pathInput is empty path
    *pathDepth_ret = 0;
    pathDepth = 0;
    free(paths);
    paths = NULL;
  } 
  else 
  {
    char *c = &(pathInput[1]);
    char *start = c;
    while (1) 
    {
      if (*c == '/' || *c == 0) 
      {
                                            // copy the pathname and filename
        char temp[100];
        if (*c == '/') 
        {
          *c = 0;
          strncpy(temp, start, 12);
          *c = '/';
        } 
        else
          strcpy(temp, start);
                                                  // dispose the name
        char *k;
        for (k = temp; *k != 0; k++) 
        {
                                                     // change to capital
          if (*k >= 'a' && *k <= 'z')
            *k += 'A' - 'a';
        }
        if (strchr(temp, '.') == 0)               // '.' first appears at temp[0]
        {
                                             // directory, not filename
          int i;
          for (i = 0; i < 8; i++) 
          {
            if (temp[i] == 0) 
            {
              memset(temp + i, '\x20', 8 - strlen(temp));
              break;
            }
          }
          memset(temp + 8, '\x20', 3);
          temp[11] = 0;
        } 
        else if (strcmp(temp, ".") == 0)         //temp=='.'   当前目录
        {
          memset(temp + 1, ' ', 10);
          temp[11] = 0;
        } 
        else if (strcmp(temp, "..") == 0)        //上级目录
        {
          memset(temp + 2, ' ', 9);
          temp[11] = 0;
        } 
        else 
        {
          // file
          char *point = strchr(temp, '.');
          *point = 0;                  // the file name will be a seperate string
          char suffix[4];
          strncpy(suffix, point + 1, 3);
          suffix[3] = 0;
          memset(suffix + strlen(suffix), '\x20', 3 - strlen(suffix));       //2*16=32
          if (strlen(temp) > 8)         //the pathInput is too long
            temp[8] = 0;
          else 
          {
            memset(temp + strlen(temp), '\x20', 8 - strlen(temp));
            temp[8] = 0;
          }
          strcat(temp, suffix);          // combine filename and attribute
        }
        paths[pathDepth - 1] = (char *)malloc(12 * sizeof(char));
        strcpy(paths[pathDepth - 1], temp);
        if (*c == '/') 
        {
          pathDepth++;
          paths = (char **)realloc(paths, pathDepth * sizeof(char *));
        } 
        else 
        {
          paths = (char **)realloc(paths, (pathDepth + 1) * sizeof(char *));
          paths[pathDepth] = NULL;
        }
      }
      if (*c == 0) 
      {
        break;
      }
      c++;
      if (*(c - 1) == '/')
        start = c;
    }
  }
  *pathDepth_ret = pathDepth;
  return paths;
}

/** TODO:
 * 将FAT文件名格式解码成原始的文件名
 *
 * Hint:假设path是“FILE    TXT”，则返回"file.txt"
**/
BYTE *path_decode(BYTE *path) 
{
  char *pathDecoded = malloc(13 * sizeof(char));
  if (strcmp(path, ".          ") == 0)           // case '.'
  {
    pathDecoded[0] = '.';
    pathDecoded[1] = 0;
  } 
  else if (strcmp(path, "..         ") == 0)      //case '..'
  {
    pathDecoded[0] = '.';
    pathDecoded[1] = '.';
    pathDecoded[2] = 0;
  } 
  else if (path[8] == ' ') 
  {
                            // directory
    char name[9];
    strncpy(name, path, 8);
    name[8] = 0;
    int i;
    for (i = 0; i < 8; i++) 
    {
      if (name[i] == ' ') 
      {
        name[i] = 0;
        break;
      }
    }
    strcpy(pathDecoded, name);
  } 
  else 
  {
    char name[9], suffix[4];
    strncpy(name, path, 8);
    name[8] = 0;
    int i;
    for (i = 0; i < 8; i++) 
    {
      if (name[i] == ' ') 
      {
        name[i] = 0;
        break;
      }
    }
    int NameLength = strlen(name);
    strcpy(pathDecoded, name);
    pathDecoded[NameLength] = '.';
    strcpy(suffix, path + 8);
    for (i = 0; i < 3; i++) 
    {
      if (suffix[i] == ' ') 
      {
        suffix[i] = 0;
        break;
      }
    }
    suffix[3] = 0;
    strcpy(pathDecoded + NameLength + 1, suffix);
  }
  int length = strlen(pathDecoded);
  int k;
  for (k = 0; k < length; k++) 
  {
    if (pathDecoded[k] >= 'A' && pathDecoded[k] <= 'Z')
      pathDecoded[k] += 'a' - 'A';                    
  }
  return pathDecoded;
}

FAT16 *pre_init_fat16(void) 
{
  /* Opening the FAT16 image file */
  FILE *fd;
  FAT16 *fat16_ins;

  fd = fopen(FAT_FILE_NAME, "rb");

  if (fd == NULL) 
  {
    fprintf(stderr, "Missing FAT16 image file!\n");
    exit(EXIT_FAILURE);
  }

  fat16_ins = (FAT16 *)malloc(sizeof(FAT16));
  fat16_ins->fd = fd;

  /** TODO:
   * 初始化fat16_ins的其余成员变量
   * Hint: root directory的大小与Bpb.BPB_RootEntCnt有关，并且是扇区对齐的
  **/

  fread(&(fat16_ins->Bpb), sizeof(BPB_BS), 1, fd);                 //把对应扇区数据读入bpb
  fat16_ins->FirstRootDirSecNum =                                   //compute the first root dir
      fat16_ins->Bpb.BPB_FATSz16 * fat16_ins->Bpb.BPB_NumFATS +
      fat16_ins->Bpb.BPB_RsvdSecCnt;
  fat16_ins->FirstDataSector = fat16_ins->FirstRootDirSecNum +             //compute the first data sector
                               fat16_ins->Bpb.BPB_RootEntCnt *
                                   sizeof(DIR_ENTRY) /
                                   fat16_ins->Bpb.BPB_BytsPerSec;

  return fat16_ins;
}

/**
 * 从root directory开始，查找path对应的文件或目录，找到返回0，没找到返回1，并将Dir填充为查找到的对应目录项
 *
 * Hint: 假设path是“/dir1/dir2/file”，则先在root directory中查找名为dir1的目录，
 *       然后在dir1中查找名为dir2的目录，最后在dir2中查找名为file的文件，找到则返回0，并且将file的目录项数据写入到参数Dir对应的DIR_ENTRY中
**/
int find_root(FAT16 *fat16_ins, DIR_ENTRY *Dir, const char *path) 
{
  int pathDepth;
  int tag = 0;
  char **paths = path_split((char *)path, &pathDepth);

  /* 先读取root directory */
  int i, j;
  int RootDirCnt = 0; /* 用于统计已读取的扇区数 */
  BYTE buffer[BYTES_PER_SECTOR];
  BYTE entry_per_sector = BYTES_PER_SECTOR / 32;

  /** TODO:
   * 查找名字为paths[0]的目录项，
   * 如果找到目录，则根据pathDepth判断是否需要调用find_subdir继续查找，
   *
   * !!注意root directory可能包含多个扇区
  **/

  for (i = 0; i < fat16_ins->Bpb.BPB_RootEntCnt; i++) 
  {
    if (i % entry_per_sector == 0)                                 //跨扇区
    {
      sector_read(fat16_ins->fd, fat16_ins->FirstRootDirSecNum + i / 16,
                  buffer);
      RootDirCnt++;
    }

    memcpy(Dir, buffer + (i - (RootDirCnt - 1) * entry_per_sector) * 32, 32);         // 一次copy 32个字节
    int k;
    for (k = 0; k < 11; k++) 
    {
      if ((Dir->DIR_Name)[k] != paths[0][k]) //比较
      {
        tag = 1;             //未匹配
        break;
      }
    }

    if (tag == 0) 
    {
      if (pathDepth == 1)                   //已匹配，目录属性为目录，且是以及一级目录
        return 0;
      else
        return find_subdir(fat16_ins, Dir, paths, pathDepth, 2);             //多级目录,pathsize +1 
    } 
    else
      tag = 0;                        
  }

  return 1;
}

/** TODO:
 * 从子目录开始查找path对应的文件或目录，找到返回0，没找到返回1，并将Dir填充为查找到的对应目录项
 *
 * Hint1:
 *在find_subdir入口处，Dir应该是要查找的这一级目录的表项，需要根据其中的簇号，读取这级目录对应的扇区数据
 * Hint2:
 *目录的大小是未知的，可能跨越多个扇区或跨越多个簇；当查找到某表项以0x00开头就可以停止查找
 * Hint3:
 *需要查找名字为paths[curDepth]的文件或目录，同样需要根据pathDepth判断是否继续调用find_subdir函数
**/
int find_subdir(FAT16 *fat16_ins, DIR_ENTRY *Dir, char **paths, int pathDepth,
                int curDepth) {
  int over = 0;
  int DirSecCnt = 1; /* 用于统计已读取的扇区数 */
  int tag = 0, new = 1;
  BYTE buffer[BYTES_PER_SECTOR];

  WORD ClusterN, FatClusEntryVal, FirstSectorofCluster;

  ClusterN = Dir->DIR_FstClusLO;

  do 
  {
    while (DirSecCnt <= fat16_ins->Bpb.BPB_SecPerClus) 
    {
      if (new = 1) 
      {
        first_sector_by_cluster(fat16_ins, ClusterN, &FatClusEntryVal,
                                &FirstSectorofCluster, buffer);
        new = 0;
      } 
      else 
      {
        sector_read(fat16_ins->fd, FirstSectorofCluster + DirSecCnt - 1,
                    buffer);
        DirSecCnt++;
      }
      int k;
      for (k = 0; k < 16; k++) 
      {
        memcpy(Dir, buffer + k * 32, 32);
        if (Dir->DIR_Name[0] == 0xE5)        //曾被使用，已被删除
          continue;
        if (Dir->DIR_Name[0] == 0)          //目录项为空
          return 1;              
        int i;
        for (i = 0; i < 11; i++) 
        {
          if (Dir->DIR_Name[i] != paths[curDepth - 1][i]) 
          {
            tag = 1;          //fail
            break;
          }
        }

        if (tag == 0) 
        {
          if (curDepth == pathDepth)     //   find file or dir
            return 0;
          else
            return find_subdir(fat16_ins, Dir, paths, pathDepth, curDepth + 1);   // not found
        } 
        else
          tag = 0;
      }
    }
    new = 1;
    DirSecCnt = 1;
  } 
  while (fat_entry_by_cluster(fat16_ins, ClusterN++) != 0xFFFF);          //下一块簇存在

  return 1;
}

/**
 * ------------------------------------------------------------------------------
 * FUSE相关的函数实现
**/

void *fat16_init(struct fuse_conn_info *conn) {
  struct fuse_context *context;
  context = fuse_get_context();

  return context->private_data;
}

void fat16_destroy(void *data) { free(data); }

int fat16_getattr(const char *path, struct stat *stbuf) {
  FAT16 *fat16_ins;

  struct fuse_context *context;
  context = fuse_get_context();
  fat16_ins = (FAT16 *)context->private_data;

  memset(stbuf, 0, sizeof(struct stat));
  stbuf->st_dev = fat16_ins->Bpb.BS_VollID;
  stbuf->st_blksize = BYTES_PER_SECTOR * fat16_ins->Bpb.BPB_SecPerClus;
  stbuf->st_uid = getuid();
  stbuf->st_gid = getgid();

  if (strcmp(path, "/") == 0) {
    stbuf->st_mode = S_IFDIR | S_IRWXU;
    stbuf->st_size = 0;
    stbuf->st_blocks = 0;
    stbuf->st_ctime = stbuf->st_atime = stbuf->st_mtime = 0;
  } else {
    DIR_ENTRY Dir;

    int res = find_root(fat16_ins, &Dir, path);

    if (res == 0) {
      if (Dir.DIR_Attr == ATTR_DIRECTORY) {
        stbuf->st_mode = S_IFDIR | 0755;
      } else {
        stbuf->st_mode = S_IFREG | 0755;
      }
      stbuf->st_size = Dir.DIR_FileSize;

      if (stbuf->st_size % stbuf->st_blksize != 0) {
        stbuf->st_blocks = (int)(stbuf->st_size / stbuf->st_blksize) + 1;
      } else {
        stbuf->st_blocks = (int)(stbuf->st_size / stbuf->st_blksize);
      }

      struct tm t;
      memset((char *)&t, 0, sizeof(struct tm));
      t.tm_sec = Dir.DIR_WrtTime & ((1 << 5) - 1);
      t.tm_min = (Dir.DIR_WrtTime >> 5) & ((1 << 6) - 1);
      t.tm_hour = Dir.DIR_WrtTime >> 11;
      t.tm_mday = (Dir.DIR_WrtDate & ((1 << 5) - 1));
      t.tm_mon = (Dir.DIR_WrtDate >> 5) & ((1 << 4) - 1);
      t.tm_year = 80 + (Dir.DIR_WrtDate >> 9);
      stbuf->st_ctime = stbuf->st_atime = stbuf->st_mtime = mktime(&t);
    }
  }
  return 0;
}

int fat16_readdir(const char *path, void *buffer, fuse_fill_dir_t filler,
                  off_t offset, struct fuse_file_info *fi) {
  FAT16 *fat16_ins;
  BYTE sector_buffer[BYTES_PER_SECTOR];
  int i;
  int RootDirCnt = 1, DirSecCnt = 1; /* 用于统计已读取的扇区数 */
  BYTE entry_per_sector = BYTES_PER_SECTOR / 32;

  struct fuse_context *context;
  context = fuse_get_context();
  fat16_ins = (FAT16 *)context->private_data;

  sector_read(fat16_ins->fd, fat16_ins->FirstRootDirSecNum, sector_buffer);

  if (strcmp(path, "/") == 0) {
    DIR_ENTRY Root;

    /** TODO:
     * 将root directory下的文件或目录通过filler填充到buffer中
     * 注意不需要遍历子目录
    **/
     /* 一级目录下的目录或文件 */
    for (i = 0; i < fat16_ins->Bpb.BPB_RootEntCnt; i++) 
    {
      if (i % entry_per_sector == 0 && i != 0) 
      {
        sector_read(fat16_ins->fd, fat16_ins->FirstRootDirSecNum + i / entry_per_sector,
                    sector_buffer);
        RootDirCnt++;
      }

      memcpy(&Root,
             sector_buffer + (i - (RootDirCnt - 1) * entry_per_sector) * 32,
             32);

      if (Root.DIR_Name[0] == 0)     //空
      {
        break;
      } 
      else if (Root.DIR_Name[0] == 0xE5)        //已被删除
      {
        continue;
      } 
      else if (Root.DIR_Attr == 0x10 || Root.DIR_Attr == 0x20) 
      {
        const char *filename = (const char *)path_decode(Root.DIR_Name);
        filler(buffer, filename, NULL, 0);
      }
    }

  } 
  else 
  {
    int new = 1, over = 0;
    DIR_ENTRY Dir;

    /** TODO:
     * 通过find_root获取path对应的目录的目录项，
     * 然后访问该目录，将其下的文件或目录通过filler填充到buffer中，
     * 同样注意不需要遍历子目录
     * Hint: 需要考虑目录大小，可能跨扇区，跨簇
    **/
    find_root(fat16_ins, &Dir, path);

    WORD ClusterN, FatClusEntryVal, FirstSectorofCluster;  //起始簇号   下个簇号   扇区

    ClusterN = Dir.DIR_FstClusLO;    

    do 
    {
      while (DirSecCnt <= fat16_ins->Bpb.BPB_SecPerClus) 
      {
        if (new = 1) 
        {
          first_sector_by_cluster(fat16_ins, ClusterN, &FatClusEntryVal,
                                  &FirstSectorofCluster, sector_buffer);
          new = 0;
        } 
        else 
        {
          sector_read(fat16_ins->fd, FirstSectorofCluster + DirSecCnt - 1,
                      sector_buffer);
          DirSecCnt++;
        }

        int k;
        for (k = 0; k < 16; k++) 
        {
          memcpy(&Dir, sector_buffer + k * 32, 32);

          if (Dir.DIR_Name[0] == 0)           //空
          {
            over = 1;
            break;
          } 
          else if (Dir.DIR_Name[0] == 0xE5)    //已被删除
          {
            continue;
          } 
          else if (Dir.DIR_Attr == 0x10 || Dir.DIR_Attr == 0x20) 
          {
            const char *filename = (const char *)path_decode(Dir.DIR_Name);
            filler(buffer, filename, NULL, 0);
          }
        }
        if (over)
          break;
      }
      if (over)
        break;
      new = 1;
      DirSecCnt = 1;
    } while (fat_entry_by_cluster(fat16_ins, ClusterN++) != 0xFFFF);
  }

  return 0;
}

/** TODO:
 * 从path对应的文件的offset字节处开始读取size字节的数据到buffer中，并返回实际读取的字节数
 *
 * Hint: 文件大小属性是Dir.DIR_FileSize；当offset超过文件大小时，应该返回0
**/
int fat16_read(const char *path, char *buffer, size_t size, off_t offset,
               struct fuse_file_info *fi) {
  FAT16 *fat16_ins;
  struct fuse_context *context;
  context = fuse_get_context();
  fat16_ins = (FAT16 *)context->private_data;
  DIR_ENTRY Dir;
  BYTE sector_buffer[BYTES_PER_SECTOR];
  WORD ClusterN, FatClusEntryVal, FirstSectorofCluster, SecNum;
  size_t bytes_per_sector = fat16_ins->Bpb.BPB_BytsPerSec;
  size_t bytes_per_clus =
      fat16_ins->Bpb.BPB_BytsPerSec * fat16_ins->Bpb.BPB_SecPerClus;
  size_t sector_per_clus = bytes_per_clus / bytes_per_sector;
  size_t sectors; // the number of other sectors(not the first sector)
  size_t bytes_read = 0;
  off_t offset1; // the offset of bytes in a sector

  find_root(fat16_ins, &Dir, path);
  ClusterN = Dir.DIR_FstClusLO;

  if (offset >= Dir.DIR_FileSize)
    return 0;
  else 
  {
    ClusterN += offset / bytes_per_clus; // the offset Cluster
    first_sector_by_cluster(fat16_ins, ClusterN, &FatClusEntryVal,
                            &FirstSectorofCluster, sector_buffer);
    SecNum = FirstSectorofCluster +
             (offset % bytes_per_clus) / bytes_per_sector; // the first sector
    offset1 = offset % bytes_per_sector;

    if (offset + size > Dir.DIR_FileSize) 
    {
      sectors = ((Dir.DIR_FileSize - offset - (bytes_per_sector - offset1)) +
                 bytes_per_sector - 1) /
                bytes_per_sector;

      sector_read(fat16_ins->fd, SecNum, sector_buffer);

      if (sectors == 1)
        memcpy(buffer, sector_buffer + offset1, Dir.DIR_FileSize - offset);
      else 
      {
        memcpy(buffer, sector_buffer + offset1, bytes_per_sector - offset1);
        bytes_read += bytes_per_sector - offset1;
        size_t i;
        for (i = 1; i < sectors; i++) 
        {
          sector_read(fat16_ins->fd, SecNum + i, sector_buffer);
          memcpy(buffer + bytes_read, sector_buffer, bytes_per_sector);
          bytes_read += bytes_per_sector;
        }
        sector_read(fat16_ins->fd, SecNum + i, sector_buffer);
        memcpy(buffer + bytes_read, sector_buffer,
               Dir.DIR_FileSize - offset - bytes_read);
      }

      return Dir.DIR_FileSize - offset;
    } 
    else 
    {
      sectors = ((size - (bytes_per_sector - offset1)) +
                 bytes_per_sector - 1) /
                bytes_per_sector;

      sector_read(fat16_ins->fd, SecNum, sector_buffer);

      if (sectors == 0)
        memcpy(buffer, sector_buffer + offset1, size);
      else 
      {
        memcpy(buffer, sector_buffer + offset1, bytes_per_sector - offset1);
        bytes_read += bytes_per_sector - offset1;
        size_t i;
        for (i = 1; i < sectors; i++) 
        {
          sector_read(fat16_ins->fd, SecNum + i, sector_buffer);
          memcpy(buffer + bytes_read, sector_buffer, bytes_per_sector);
          bytes_read += bytes_per_sector;
        }
        sector_read(fat16_ins->fd, SecNum + i, sector_buffer);
        memcpy(buffer + bytes_read, sector_buffer, size - bytes_read);
      }

      return size;
    }
  }
}

/**
 * ------------------------------------------------------------------------------
 * 测试函数
**/

void test_path_split() {
  printf("#1 running %s\n", __FUNCTION__);

  char s[][32] = {"/texts", "/dir1/dir2/file.txt", "/.Trash-100"};
  int dr[] = {1, 3, 1};
  char sr[][3][32] = {{"TEXTS      "}, {"DIR1       ", "DIR2       ", "FILE    TXT"}, {"        TRA"}};

  int i, j, r;
  for (i = 0; i < sizeof(dr) / sizeof(dr[0]); i++) {  
  
    char **ss = path_split(s[i], &r);
    assert(r == dr[i]);
    for (j = 0; j < dr[i]; j++) {
      assert(strcmp(sr[i][j], ss[j]) == 0);
      free(ss[j]);
    }
    free(ss);
    printf("test case %d: OK\n", i + 1);
  }

  printf("success in %s\n\n", __FUNCTION__);
}

void test_path_decode() {
  printf("#2 running %s\n", __FUNCTION__);

  char s[][32] = {"..        ", "FILE    TXT", "ABCD    RM "};
  char sr[][32] = {"..", "file.txt", "abcd.rm"};

  int i, j, r;
  for (i = 0; i < sizeof(s) / sizeof(s[0]); i++) {
    char *ss = (char *) path_decode((BYTE*)s[i]);
    assert(strcmp(ss, sr[i]) == 0);
    free(ss);
    printf("test case %d: OK\n", i + 1);
  }

  printf("success in %s\n\n", __FUNCTION__);
}

void test_pre_init_fat16() {
  printf("#3 running %s\n", __FUNCTION__);

  FAT16 *fat16_ins = pre_init_fat16();

  assert(fat16_ins->FirstRootDirSecNum == 124);
  assert(fat16_ins->FirstDataSector == 156);
  assert(fat16_ins->Bpb.BPB_RsvdSecCnt == 4);
  assert(fat16_ins->Bpb.BPB_RootEntCnt == 512);
  assert(fat16_ins->Bpb.BS_BootSig == 41);
  assert(fat16_ins->Bpb.BS_VollID == 1576933109);
  assert(fat16_ins->Bpb.Signature_word == 43605);
  
  fclose(fat16_ins->fd);
  free(fat16_ins);
  
  printf("success in %s\n\n", __FUNCTION__);
}

void test_fat_entry_by_cluster() {
  printf("#4 running %s\n", __FUNCTION__);

  FAT16 *fat16_ins = pre_init_fat16();

  int cn[] = {1, 2, 4};
  int ce[] = {65535, 0, 65535};

  int i;
  for (i = 0; i < sizeof(cn) / sizeof(cn[0]); i++) {
    int r = fat_entry_by_cluster(fat16_ins, cn[i]);
    assert(r == ce[i]);
    printf("test case %d: OK\n", i + 1);
  }
  
  fclose(fat16_ins->fd);
  free(fat16_ins);

  printf("success in %s\n\n", __FUNCTION__);
}

void test_find_root() {
  printf("#5 running %s\n", __FUNCTION__);

  FAT16 *fat16_ins = pre_init_fat16();
/*	char path[][32] = {"/dir1", "/libfus~1.zip"};
  char names[][32] = {"DIR1       ", "LIBFUS~1ZIP"};
*/

  char path[][32] = {"/dir1", "/makefile", "/log.c"};
  char names[][32] = {"DIR1       ", "MAKEFILE   ", "LOG     C  "};
  int others[][3] = {{100, 4, 0}, {100, 8, 226}, {100, 3, 517}};

  int i;
  for (i = 0; i < sizeof(path) / sizeof(path[0]); i++) {
    DIR_ENTRY Dir;
    find_root(fat16_ins, &Dir, path[i]);
    assert(strncmp(Dir.DIR_Name, names[i], 11) == 0);
    assert(Dir.DIR_CrtTimeTenth == others[i][0]);
    assert(Dir.DIR_FstClusLO == others[i][1]);
    assert(Dir.DIR_FileSize == others[i][2]);

    printf("test case %d: OK\n", i + 1);
  }
  
  fclose(fat16_ins->fd);
  free(fat16_ins);

  printf("success in %s\n\n", __FUNCTION__);
}

void test_find_subdir() {
  printf("#6 running %s\n", __FUNCTION__);

  FAT16 *fat16_ins = pre_init_fat16();
 
/* char path[][32] = {"/dir1/lab3-c~1.gz"};
  char names[][32] = {"LAB3-C~1GZ "};
*/


  char path[][32] = {"/dir1/dir2", "/dir1/dir2/dir3", "/dir1/dir2/dir3/test.c"};
  char names[][32] = {"DIR2       ", "DIR3       ", "TEST    C  "};
  int others[][3] = {{100, 5, 0}, {0, 6, 0}, {0, 7, 517}};

  int i;
  for (i = 0; i < sizeof(path) / sizeof(path[0]); i++) {
    DIR_ENTRY Dir;
    find_root(fat16_ins, &Dir, path[i]);
    assert(strncmp(Dir.DIR_Name, names[i], 11) == 0);
    assert(Dir.DIR_CrtTimeTenth == others[i][0]);
    assert(Dir.DIR_FstClusLO == others[i][1]);
    assert(Dir.DIR_FileSize == others[i][2]);

    printf("test case %d: OK\n", i + 1);
  }
  
  fclose(fat16_ins->fd);
  free(fat16_ins);

  printf("success in %s\n\n", __FUNCTION__);
}


struct fuse_operations fat16_oper = {
    .init = fat16_init,
    .destroy = fat16_destroy,
    .getattr = fat16_getattr,
    .readdir = fat16_readdir,
    .read = fat16_read
    };

int main(int argc, char *argv[])
{
  int ret;

  if (strcmp(argv[1], "--test") == 0) {
    printf("--------------\nrunning test\n--------------\n");
    FAT_FILE_NAME = "fat16_test.img";
//FAT_FILE_NAME = "fat16.img";
    test_path_split();
    test_path_decode();
    test_pre_init_fat16();
    test_fat_entry_by_cluster();
    test_find_root();
    test_find_subdir();
    exit(EXIT_SUCCESS);
  }

  FAT16 *fat16_ins = pre_init_fat16();

  ret = fuse_main(argc, argv, &fat16_oper, fat16_ins);

  return ret;
}