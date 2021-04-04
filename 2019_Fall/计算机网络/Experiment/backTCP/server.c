#include <pthread.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/time.h>
#include <time.h>
#include <signal.h>
#define TIME_INTERVAL 10000
#define MAX_BUF_SIZE 512
#define WIN_SIZE 8
#define LOAD_SIZE 64
#define SEQ_MAX 256
#define FULL 1
#define EMPTY 10

typedef struct Input_Send
{
    FILE* fp;
    int clnt_sock;
}Input_Send;

typedef uint8_t tcp_seq;
typedef struct tcphdr {
    uint8_t btcp_sport; /* source port */
    uint8_t btcp_dport; /* destination port */
    tcp_seq btcp_seq; /* sequence number */
    tcp_seq btcp_ack; /* acknowledgment number */
    uint8_t data_off; /* data offset */
    uint8_t win_size; /* window size */
    uint8_t flag; /* retransmission or not*/
} BTcpHeader;

typedef struct Package{
    BTcpHeader header;
    unsigned char payload[LOAD_SIZE];
} Package;

struct itimerval oldtv;
int result_send;
int result_recv;
int base = 0;
int nextseqnum = 0;
int clnt_sock;
int finish = 0;

Package* Data_Package(tcp_seq btcp_seq,tcp_seq btcp_ack,uint8_t data_off,uint8_t win_size,uint8_t flag,unsigned char* payload)
{
    Package* New_Package = (Package*)malloc(sizeof(Package));
    New_Package->header.btcp_sport = 0;
	New_Package->header.btcp_dport = 0;
	New_Package->header.btcp_seq = btcp_seq;
	New_Package->header.btcp_ack = btcp_ack;
	New_Package->header.data_off = data_off;
	New_Package->header.win_size = win_size;
	New_Package->header.flag = flag;
    for(uint8_t i=0;i < data_off; i++)
    {
        New_Package->payload[i] = payload[i];
    }
    return New_Package;
}

Package* package_buffer_send[SEQ_MAX];

void start_timer()
{
    printf("start\n");
    struct itimerval itv;
    itv.it_interval.tv_sec = 1;
    itv.it_interval.tv_usec = TIME_INTERVAL;
    itv.it_value.tv_sec = 1;
    itv.it_value.tv_usec = TIME_INTERVAL;
    setitimer(ITIMER_REAL, &itv, &oldtv);
}

void stop_timer()
{
    printf("end\n");
    struct itimerval itv;
    itv.it_interval.tv_sec = 0;
    itv.it_interval.tv_usec = TIME_INTERVAL;
    itv.it_value.tv_sec = 0;  //不触发
    itv.it_value.tv_usec = 0;
    setitimer(ITIMER_REAL, &itv, &oldtv);
}

void* rdt_send(void* args)
{
    Input_Send in = *((Input_Send*)args);
    FILE* fp = in.fp;
    int clnt_sock = in.clnt_sock;
    while(1)
    {
        if(finish)
        {
            break;
        }
        unsigned char buffer[MAX_BUF_SIZE];
        int cnt;
        if((nextseqnum>=SEQ_MAX-WIN_SIZE&&nextseqnum<base + WIN_SIZE)||(base+WIN_SIZE<SEQ_MAX&&nextseqnum<base+WIN_SIZE)||(nextseqnum<(base+WIN_SIZE)%SEQ_MAX))
        {
            if((cnt = fread(buffer,sizeof(unsigned char),LOAD_SIZE,fp)) >= 0)
            {
                printf("%s",buffer);
                for(int i=cnt;i<MAX_BUF_SIZE;i++)
                {
                    buffer[i]='\0';
                }
                package_buffer_send[nextseqnum] = Data_Package(nextseqnum,0,cnt,WIN_SIZE,0,buffer);
                printf("send window:%d %d\n",base,nextseqnum);
                write(clnt_sock,(void*)package_buffer_send[nextseqnum],sizeof(Package));
            }
            else
            {
                start_timer();
                printf("EMPTY\n");
                result_send = EMPTY;
            }
            if(base == nextseqnum)
            {
                start_timer();
            }
            nextseqnum = (nextseqnum+1)%SEQ_MAX;
        }
        else
        {
            result_send = FULL;
        }
        usleep(1000);
    }
    pthread_exit(NULL);
}

void timeout(int clint_clock)
{
    printf("Timeout\n");
    if(base >= nextseqnum)
    {
        stop_timer();
        package_buffer_send[nextseqnum-1]->header.flag = 1;
        package_buffer_send[nextseqnum-1]->header.btcp_seq = nextseqnum;
        package_buffer_send[nextseqnum-1]->header.data_off = 0;
        write(clnt_sock,(void*)package_buffer_send[nextseqnum-1],sizeof(Package));
    }
    for (int i = base; i < nextseqnum; ++i)
    {
        printf("Send again\n");
        package_buffer_send[i]->header.flag = 1;
        write(clnt_sock,(void*)package_buffer_send[i],sizeof(Package));
    }
}

void* rdt_rcv(void* args)
{
    int clnt_sock = *((int*)args);
    while(1)
    {
        if(finish)
            break;
        unsigned char buffer[sizeof(Package)];
        int cnt;
        Package* recvPackage;
        if((cnt = read(clnt_sock, buffer, sizeof(Package)))>0)
        {
            printf("buffer:%s",buffer);
            printf("recv!\n");
            recvPackage = (Package*)buffer;
            base = (recvPackage->header.btcp_ack + 1)%SEQ_MAX;
            printf("base:%d\n",base);
            if(base == nextseqnum)
            {
                stop_timer();
                //stop_timer
            }
            else{
                start_timer();
                //start_timer
            }
            result_recv = recvPackage->header.btcp_seq;
        }
        usleep(1000);
    }
    pthread_exit(NULL);
}

void signal_handler(int m)
{
    timeout(clnt_sock);
}

int main()
{
    char filename[100] = "testdata.txt";
    FILE *fp = fopen(filename,"rb");
    if(fp == NULL)
    {
        printf("ERROR:cannot open the file,please exit!\n");
        system("pause");
        exit(0);
    }
    int serv_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));  //每个字节都用0填充
    serv_addr.sin_family = AF_INET;  //使用IPv4地址
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");  //具体的IP地址
    serv_addr.sin_port = htons(1150);  //端口
    bind(serv_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
    listen(serv_sock, 20);
    struct sockaddr_in clnt_addr;
    socklen_t clnt_addr_size = sizeof(clnt_addr);
    clnt_sock = accept(serv_sock, (struct sockaddr*)&clnt_addr, &clnt_addr_size);
    signal(SIGALRM, signal_handler); //定时器信号设置

    pthread_t threads[2];
    int s = 0;
    int rc;
    while(1)
    {
        if(s == 0)
        {
            Input_Send in = {.fp = fp,.clnt_sock = clnt_sock};
            rc = pthread_create(&threads[s], NULL, rdt_send, (void *)&in);
            if(rc)
            {
                printf("ERROR: cannot create thread %d\n",rc);
                exit(-1);
            }
            s++;
        }
        else if(s == 1)
        {
            rc = pthread_create(&threads[s], NULL, rdt_rcv, (void *)&clnt_sock);
            if (rc){
                printf("ERROR: cannot create thread %d\n",rc);
                exit(-1);
            }
            s++;
        }
        if(result_send == EMPTY)
        {

            finish = 1;
            break;
        }
    }
    shutdown(clnt_sock,SHUT_WR);
    fclose(fp);
    close(clnt_sock);
    close(serv_sock);
    return 0;
}