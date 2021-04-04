/*
 * mm-naive.c - The fastest, least memory-efficient malloc package.
 * 
 * In this naive approach, a block is allocated by simply incrementing
 * the brk pointer.  A block is pure payload. There are no headers or
 * footers.  Blocks are never coalesced or reused. Realloc is
 * implemented directly using mm_malloc and mm_free.
 *
 * NOTE TO STUDENTS: Replace this header comment with your own header
 * comment that gives a high level description of your solution.
 */
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <unistd.h>
#include <string.h>

#include "mm.h"
#include "memlib.h"

/*********************************************************
 * NOTE TO STUDENTS: Before you do anything else, please
 * provide your team information in the following struct.
 ********************************************************/

/* single word (4) or double word (8) alignment */
#define ALIGNMENT 8

/* rounds up to the nearest multiple of ALIGNMENT */
#define ALIGN(size) (((size) + (ALIGNMENT-1)) & ~0x7)


#define SIZE_T_SIZE (ALIGN(sizeof(size_t)))

#define WSIZE 4
#define DSIZE 8           /*Double word size*/
#define CHUNKSIZE (1<<12) /*the page size in bytes is 4K*/

#define MAX(x,y)    ((x)>(y)?(x):(y))

#define PACK(size,alloc)    ((size) | (alloc))       //PACK将块大小和分配位结合返回一个值（即将size的最低位赋值为分配位）

#define GET(p)  (*(unsigned int *)(p))              //GET/PUT分别对指针p指向的位置取值/赋值
#define PUT(p,val)  (*(unsigned int *)(p) = (val))

#define GET_SIZE(p)  (GET(p) & ~0x7)             //GET_SIZE/GET_ALLOC分别从p指向位置获取块大小和分配位。p指向头/脚部
#define GET_ALLOC(p)    (GET(p) & 0x1)


#define HDRP(bp)    ((char *)(bp)-WSIZE)     //HDRP/FTRP返回bp指向块的头/脚部
#define FTRP(bp)    ((char *)(bp)+GET_SIZE(HDRP(bp))-DSIZE)

#define NEXT_BLKP(bp)   ((char *)(bp)+GET_SIZE(((char *)(bp)-WSIZE)))       //NEXT_BLKP/PREV_BLKP返回与bp相邻的下一/上一块
#define PREV_BLKP(bp)   ((char *)(bp)-GET_SIZE(((char *)(bp)-DSIZE)))

#define PRED(bp) ((char*)(bp))              //前驱指针
#define SUCC(bp) ((char*)(bp)+WSIZE)        //后继指针

static char *heap_listp = NULL;
static char *free_list_head = NULL;

static void *extend_heap(size_t words);
inline void *coalesce(void *bp);
static void *find_fit(size_t size);
static void place(void *bp,size_t size);
inline void insert_to_Emptylist(char *p);
inline void fix_linklist(char *p);

/* 
 * mm_init - initialize the malloc package.
 */
int mm_init(void)
{
    if((heap_listp = mem_sbrk(6*WSIZE))==(void *)-1) 
        return -1;
    PUT(heap_listp,0);                            // Alignment padding
    PUT(heap_listp+(1*WSIZE),0);                  // Free PREV POINTER
    PUT(heap_listp+(2*WSIZE),0);                  // Free NEXT POINTER
    PUT(heap_listp+(3*WSIZE),PACK(DSIZE,1));      // Prologue header
    PUT(heap_listp+(4*WSIZE),PACK(DSIZE,1));      // Prologue footer
    PUT(heap_listp+(5*WSIZE),PACK(0,1));          // Epilogue header
    free_list_head=heap_listp+WSIZE;
    heap_listp+=(4*WSIZE);
    if (extend_heap(CHUNKSIZE/DSIZE) == NULL) 
        return -1;
    return 0;
}

static void *extend_heap(size_t words)
{
    char *bp;
    size_t size;
    size=(words%2)?((words+1)*DSIZE):(words*DSIZE);      //保证4字,前驱&后继指针
    if ((long)(bp=mem_sbrk(size))==(void *)-1)  
        return NULL;
    PUT(HDRP(bp),PACK(size,0));             // Free block header
    PUT(FTRP(bp),PACK(size,0));             // Free block footer
    PUT(SUCC(bp),0);            // Next linknode
    PUT(PRED(bp),0);            // Prev linknode
    PUT(HDRP(NEXT_BLKP(bp)),PACK(0,1));     // New epilogue header
    return coalesce(bp);
}

inline void *coalesce(void *bp)                        // 4 cases
{
    size_t prev_alloc=GET_ALLOC(FTRP(PREV_BLKP(bp)));   
    size_t next_alloc=GET_ALLOC(HDRP(NEXT_BLKP(bp)));
    size_t size=GET_SIZE(HDRP(bp));

    if(prev_alloc && next_alloc)
    {

    }
    else if(prev_alloc && !next_alloc)
    {
        size+=GET_SIZE(HDRP(NEXT_BLKP(bp)));
        fix_linklist(NEXT_BLKP(bp));
        PUT(HDRP(bp),PACK(size,0));
        PUT(FTRP(bp),PACK(size,0));
    }
    else if(!prev_alloc && next_alloc)
    {
        size+=GET_SIZE(HDRP(PREV_BLKP(bp)));
        fix_linklist(PREV_BLKP(bp));
        PUT(FTRP(bp),PACK(size,0));
        PUT(HDRP(PREV_BLKP(bp)),PACK(size,0));
        bp=PREV_BLKP(bp);
    }
    else
    {
        size+=GET_SIZE(HDRP(PREV_BLKP(bp)))+GET_SIZE(HDRP(NEXT_BLKP(bp)));
        fix_linklist(PREV_BLKP(bp));
        fix_linklist(NEXT_BLKP(bp));
        PUT(FTRP(NEXT_BLKP(bp)),PACK(size,0));
        PUT(HDRP(PREV_BLKP(bp)),PACK(size,0));
        bp=PREV_BLKP(bp);
    }
    insert_to_emptylist(bp);
    return bp;
}

inline void insert_to_emptylist(char *p)    // insert the free block p to the head of emptylist, LIFO
{
    char *nextp=GET(free_list_head);
    if(nextp!=NULL)
        PUT(PRED(nextp),p);
    PUT(SUCC(p),nextp);
    PUT(free_list_head,p);
}

/*
 * mm_malloc - Allocate a block by incrementing the brk pointer.
 *     Always allocate a block whose size is a multiple of the alignment.
 */
void *mm_malloc(size_t size)
{
    size_t asize;
    size_t extendsize;
    char *bp;
    if(size==0)
        return NULL;
    else if(size<=DSIZE)                               // The mininum size of a block is 16 byte
    {
        asize=2*DSIZE;
    }
    else
    {
        asize=DSIZE*((size+DSIZE+(DSIZE-1)) / DSIZE);
    }
    if((bp=find_fit(asize))!=NULL)
    {
        place(bp,asize);
        return bp;
    }
    extendsize=MAX(asize,CHUNKSIZE);
    if((bp=extend_heap(extendsize/DSIZE))==NULL)
        return NULL;
    place(bp,asize);
    return bp;
}

/*
 * mm_free - Freeing a block does nothing.
 */
void mm_free(void *bp)
{
    if(bp==0)
        return NULL;
    size_t size=GET_SIZE(HDRP(bp));
    PUT(HDRP(bp),PACK(size,0));
    PUT(FTRP(bp),PACK(size,0));
    PUT(SUCC(bp),0);
    PUT(PRED(bp),0);
    coalesce(bp);
}

/*
 * mm_realloc - Implemented simply in terms of mm_malloc and mm_free
 */
void *mm_realloc(void *ptr, size_t size)
{
    size_t oldsize;
    void *newptr;
    if(size==0)
    {
        mm_free(ptr);
        return NULL;
    }
    else if(ptr==NULL)
    {
        return mm_malloc(size);
    }
    else
    {
        newptr=mm_malloc(size);
        if(!newptr)
            return NULL;
        else
        {
            oldsize=GET_SIZE(HDRP(ptr));
            if(size<oldsize)
            {
                oldsize=size;
            }
            memcpy(newptr,ptr,oldsize);        
            mm_free(ptr);
            return newptr;
        }
    }
}

inline void fix_linklist(char *p)
{
    char *prevp=GET(PRED(p));
    char *nextp=GET(SUCC(p));
    if(prevp==NULL)
    {
        if(nextp!=NULL)
            PUT(PRED(nextp),0);
        PUT(free_list_head,nextp);
    }
    else
    {
        if(nextp!=NULL)
            PUT(PRED(nextp),prevp);
        PUT(SUCC(prevp),nextp);
    }
    PUT(PRED(p),0);
    PUT(SUCC(p),0);
}

static void *find_fit(size_t size)
{
    void *tmpP=GET(free_list_head);
    while (tmpP!=NULL)
    {
        if(GET_SIZE(HDRP(tmpP))>=size)
            return tmpP;
        tmpP=GET(SUCC(tmpP));
    }
    return NULL;
}

static void place(void *bp,size_t size)            
{
    size_t asize=GET_SIZE(HDRP(bp));
    fix_linklist(bp);
    if((asize-size)>=(2*DSIZE))
    {
        PUT(HDRP(bp),PACK(size,1));
        PUT(FTRP(bp),PACK(size,1));
        bp=NEXT_BLKP(bp);
        PUT(HDRP(bp),PACK(asize-size,0));
        PUT(FTRP(bp),PACK(asize-size,0));
        PUT(SUCC(bp),0);
        PUT(PRED(bp),0);
        coalesce(bp);
    }
    else
    {
        PUT(HDRP(bp),PACK(asize,1));
        PUT(FTRP(bp),PACK(asize,1));
    }
}
