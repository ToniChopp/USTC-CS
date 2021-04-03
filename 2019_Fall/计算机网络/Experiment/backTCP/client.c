#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#define MAX_BUF_SIZE 512
#define WIN_SIZE 8
#define LOAD_SIZE 64
#define SEQ_MAX 256

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

int expectedseqnum = 0;

int main()
{
    char filename[100] = "Output.txt";
    FILE *fp = fopen(filename,"wb");
    if(fp == NULL)
    {
        printf("ERROR:cannot open the file,please exit!\n");
        system("pause");
        exit(0);
    }
    int sock = socket(AF_INET,SOCK_STREAM,0);
    struct sockaddr_in serv_Addr;
    memset(&serv_Addr,0,sizeof(serv_Addr));
    serv_Addr.sin_family = AF_INET;                           /*ipv4*/
    serv_Addr.sin_addr.s_addr = inet_addr("127.0.0.1");       /*in_addr_t inet_addr(const char *ip)*/  
	serv_Addr.sin_port = htons(1145);                         /*uint8_t  htons(uint8_t hostshort)*/
    connect(sock,(struct sockaddr*)&serv_Addr, sizeof(serv_Addr));
    expectedseqnum = 0;
    unsigned char buffer[sizeof(Package)];
    int cnt;
    Package* recv_Package;
    while((cnt = read(sock,buffer,sizeof(Package)))>0)
    {
        recv_Package = (Package*)buffer;
        printf("expectedseqnum:%d\n",expectedseqnum);
        if(recv_Package->header.btcp_seq < expectedseqnum)
        {
            printf("ack old\n");
            Package* sndpkt = Data_Package(expectedseqnum,recv_Package->header.btcp_seq,0,WIN_SIZE,0,NULL);
            write(sock,(void*)sndpkt,sizeof(Package));
        }
        if(recv_Package->header.btcp_seq == expectedseqnum)
        {
            printf("%s\n",recv_Package->payload);
            if(recv_Package->payload[0] == '\0')
                break;
            fwrite(recv_Package->payload,sizeof(unsigned char),LOAD_SIZE,fp);
    		Package* sndpkt = Data_Package(expectedseqnum,recv_Package->header.btcp_seq,0,WIN_SIZE,0,NULL);
    		write(sock,(void*)sndpkt,sizeof(Package));
    		printf("%d",expectedseqnum);
    		expectedseqnum = (expectedseqnum+1)%SEQ_MAX; 
        }
    }
    printf("Success in file transfer!\n");
    fclose(fp);
    if(recv_Package->payload[0] == '\0')
        close(sock);
    return 0;
}