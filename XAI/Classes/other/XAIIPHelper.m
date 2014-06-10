//
//  XAIIPHelper.m
//  XAI
//
//  Created by office on 14-6-9.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIIPHelper.h"

#import "MQTT.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>





@implementation XAIIPHelper



- (int)getApserverIp:(const char*) host{

    int cfd,sock;
    int recbytes;
    char buffer[1024]={0};
    struct sockaddr_in s_add;
    uint16_t portnum=9002;
    
    struct addrinfo hints;
	struct addrinfo *ainfo, *rp;
    
    
    memset(&hints, 0, sizeof(struct addrinfo));
	hints.ai_family = PF_UNSPEC;
	hints.ai_flags = AI_ADDRCONFIG;
	hints.ai_socktype = SOCK_STREAM;
    
    
    int s = getaddrinfo(host, NULL, &hints, &ainfo);
    if(s) return -1;
    
    int res = -1;
    
    do {
        
        
        
  
        
        s = getaddrinfo(host, NULL, &hints, &ainfo);
        if(s) return -1;
        
        #define INVALID_SOCKET -1
        
        for(rp = ainfo; rp != NULL; rp = rp->ai_next){
            sock = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
            if(sock == INVALID_SOCKET) continue;
            
            struct sockaddr_in *s  = (struct sockaddr_in *) rp->ai_addr;
            
            if(rp->ai_family == PF_INET){
                ((struct sockaddr_in *)rp->ai_addr)->sin_port = htons(portnum);
            }else if(rp->ai_family == PF_INET6){
                ((struct sockaddr_in6 *)rp->ai_addr)->sin6_port = htons(portnum);
            }else{
                continue;
            }
            if(connect(sock, rp->ai_addr, rp->ai_addrlen) != -1){
                break;
                
                cfd = sock;
            }
            
            
            return -1;
        }

        
//        cfd = socket(AF_INET, SOCK_STREAM, 0);
//        if(-1 == cfd)
//        {
//            printf("socket fail ! \r\n");
//            break;
//        }
//        printf("socket ok !\r\n");
//        
//        bzero(&s_add,sizeof(struct sockaddr_in));
//        s_add.sin_family=AF_INET;
//        s_add.sin_addr.s_addr= inet_addr("114.215.178.75");
//        s_add.sin_port=htons(portnum);
//        printf("s_addr = %#x ,port : %#x\r\n",s_add.sin_addr.s_addr,s_add.sin_port);
//
//        
//        struct sockaddr * sk = (struct sockaddr *) &s_add;
//        
//        if(-1 == connect(cfd,(struct sockaddr *)(&s_add), sizeof(struct sockaddr)))
//        {
//            printf("connect fail !\r\n");
//            break;
//        }

        
        printf("connect ok !\r\n");
        
        
        char  wBuf[1000] = {0};
        uint8_t  req = 0x03;
        XAITYPEAPSN  apsn = 0x01;
        XAITYPEAPSN napsn = CFSwapInt32(apsn);
        uint32_t serip = 0x0;
        
        memcpy(wBuf, &req, sizeof(uint8_t));
        memcpy(wBuf+sizeof(uint8_t), &napsn, sizeof(XAITYPEAPSN));
        memcpy(wBuf+sizeof(uint8_t)+sizeof(XAITYPEAPSN), &serip, sizeof(serip));
        
        
        size_t pack_size = sizeof(uint8_t)+sizeof(XAITYPEAPSN)+sizeof(uint32_t);

        write(sock, wBuf , pack_size);
        
  
            
        if(pack_size != (recbytes = read(sock,buffer,1024)))
        {
            printf("read data fail !\r\n");
            break;
        }
        printf("read ok\r\nREC:\r\n");
        buffer[recbytes]='\0';
        printf("%s\r\n",buffer);
        
        memcpy(&serip, buffer+sizeof(uint8_t)+sizeof(XAITYPEAPSN), sizeof(uint32_t));

        serip = CFSwapInt32(serip);
        

        
        if(-1 == (recbytes = read(cfd,buffer,1024)))
        {
            printf("read data fail !\r\n");
            break;
        }
        printf("read ok\r\nREC:\r\n");
        buffer[recbytes]='\0';
        printf("%s\r\n",buffer);
        getchar();
        close(cfd);

        res = 0;
        
    } while (0);
    
    
    freeaddrinfo(ainfo);
    
    return res;
}

@end


int down()
{
    int sfp,nfp;
    struct sockaddr_in s_add,c_add;
    int sin_size;
    unsigned short portnum=0x8888;
    printf("Hello,welcome to my server !\r\n");
    sfp = socket(AF_INET, SOCK_STREAM, 0);
    if(-1 == sfp)
    {
        printf("socket fail ! \r\n");
        return -1;
    }
    printf("socket ok !\r\n");
    
    bzero(&s_add,sizeof(struct sockaddr_in));
    s_add.sin_family=AF_INET;
    s_add.sin_addr.s_addr=htonl(INADDR_ANY);
    s_add.sin_port=htons(portnum);
    
    if(-1 == bind(sfp,(struct sockaddr *)(&s_add), sizeof(struct sockaddr)))
    {
        printf("bind fail !\r\n");
        return -1;
    }
    printf("bind ok !\r\n");
    
    if(-1 == listen(sfp,5))
    {
        printf("listen fail !\r\n");
        return -1;
    }
    printf("listen ok\r\n");
    while(1)
    {
        sin_size = sizeof(struct sockaddr_in);
        
        nfp = accept(sfp, (struct sockaddr *)(&c_add), &sin_size);
        if(-1 == nfp)
        {
            printf("accept fail !\r\n");
            return -1;
        }
        printf("accept ok!\r\nServer start get connect from %#x : %#x\r\n",ntohl(c_add.sin_addr.s_addr),ntohs(c_add.sin_port));
        
        if(-1 == write(nfp,"hello,welcome to my server \r\n",32))
        {
            printf("write fail!\r\n");
            return -1;
        }
        printf("write ok!\r\n");
        close(nfp);
    }
    close(sfp);
    return 0;
}


#include <stdio.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/route.h>
#include <string.h>

#define CTL_NET         4               /* network, see socket.h */


#if defined(BSD) || defined(__APPLE__)

#define ROUNDUP(a) \
((a) > 0 ? (1 + (((a) - 1) | (sizeof(long) - 1))) : sizeof(long))

int getdefaultgateway(in_addr_t * addr)
{
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
        NET_RT_FLAGS, RTF_GATEWAY};
    size_t l;
    char * buf, * p;
    struct rt_msghdr * rt;
    struct sockaddr * sa;
    struct sockaddr * sa_tab[RTAX_MAX];
    int i;
    int r = -1;
    if(sysctl(mib, sizeof(mib)/sizeof(int), 0, &l, 0, 0) < 0) {
        return -1;
    }
    if(l>0) {
        buf = malloc(l);
        if(sysctl(mib, sizeof(mib)/sizeof(int), buf, &l, 0, 0) < 0) {
            return -1;
        }
        for(p=buf; p<buf+l; p+=rt->rtm_msglen) {
            rt = (struct rt_msghdr *)p;
            sa = (struct sockaddr *)(rt + 1);
            for(i=0; i<RTAX_MAX; i++) {
                if(rt->rtm_addrs & (1 << i)) {
                    sa_tab[i] = sa;
                    sa = (struct sockaddr *)((char *)sa + ROUNDUP(sa->sa_len));
                } else {
                    sa_tab[i] = NULL;
                }
            }
            
            if( ((rt->rtm_addrs & (RTA_DST|RTA_GATEWAY)) == (RTA_DST|RTA_GATEWAY))
               && sa_tab[RTAX_DST]->sa_family == AF_INET
               && sa_tab[RTAX_GATEWAY]->sa_family == AF_INET) {
                
                
                if(((struct sockaddr_in *)sa_tab[RTAX_DST])->sin_addr.s_addr == 0) {
                    char ifName[128];
                    if_indextoname(rt->rtm_index,ifName);
                    
                    if(strcmp("en0",ifName)==0){
                        
                        *addr = ((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr;
                        r = 0;
                    }
                }
            }
        }
        free(buf);
    }
    return r;
}
#endif



//#define BUFSIZE 8192
//
//
//struct route_info{
//    u_int dstAddr;
//    u_int srcAddr;
//    u_int gateWay;
//    char ifName[IF_NAMESIZE];
//};
//
//int readNlSock(int sockFd, char *bufPtr, int seqNum, int pId){
//    struct nlmsghdr *nlHdr;
//    int readLen = 0, msgLen = 0;
//    
//    do{
//        /* Recieve response from the kernel */
//        if((readLen = recv(sockFd, bufPtr, BUFSIZE - msgLen, 0)) < 0){
//            perror("SOCK READ: ");
//            return -1;
//        }
//        
//        nlHdr = (struct nlmsghdr *)bufPtr;
//        
//        /* Check if the header is valid */
//        if((NLMSG_OK(nlHdr, readLen) == 0) || (nlHdr->nlmsg_type == NLMSG_ERROR))
//        {
//            perror("Error in recieved packet");
//            return -1;
//        }
//        
//        /* Check if the its the last message */
//        if(nlHdr->nlmsg_type == NLMSG_DONE) {
//            break;
//        }
//        else{
//            /* Else move the pointer to buffer appropriately */
//            bufPtr += readLen;
//            msgLen += readLen;
//        }
//        
//        /* Check if its a multi part message */
//        if((nlHdr->nlmsg_flags & NLM_F_MULTI) == 0) {
//            /* return if its not */
//            break;
//        }
//    } while((nlHdr->nlmsg_seq != seqNum) || (nlHdr->nlmsg_pid != pId));
//    return msgLen;
//}
//
///* For printing the routes. */
//void printRoute(struct route_info *rtInfo)
//{
//    char tempBuf[512];
//    
//    /* Print Destination address */
//    if(rtInfo->dstAddr != 0)
//        strcpy(tempBuf, (char *)inet_ntoa(rtInfo->dstAddr));
//    else
//        sprintf(tempBuf,"*.*.*.*\t");
//    fprintf(stdout,"%s\t", tempBuf);
//    
//    /* Print Gateway address */
//    if(rtInfo->gateWay != 0)
//        strcpy(tempBuf, (char *)inet_ntoa(rtInfo->gateWay));
//    else
//        sprintf(tempBuf,"*.*.*.*\t");
//    fprintf(stdout,"%s\t", tempBuf);
//    
//    /* Print Interface Name*/
//    fprintf(stdout,"%s\t", rtInfo->ifName);
//    
//    /* Print Source address */
//    if(rtInfo->srcAddr != 0)
//        strcpy(tempBuf, (char *)inet_ntoa(rtInfo->srcAddr));
//    else
//        sprintf(tempBuf,"*.*.*.*\t");
//    fprintf(stdout,"%s\n", tempBuf);
//}
//
///* For parsing the route info returned */
//void parseRoutes(struct nlmsghdr *nlHdr, struct route_info *rtInfo,char *gateway)
//{
//    struct rtmsg *rtMsg;
//    struct rtattr *rtAttr;
//    int rtLen;
//    char *tempBuf = NULL;
//    
//    tempBuf = (char *)malloc(100);
//    rtMsg = (struct rtmsg *)NLMSG_DATA(nlHdr);
//    
//    /* If the route is not for AF_INET or does not belong to main routing table
//     then return. */
//    if((rtMsg->rtm_family != AF_INET) || (rtMsg->rtm_table != RT_TABLE_MAIN))
//        return;
//    
//    /* get the rtattr field */
//    rtAttr = (struct rtattr *)RTM_RTA(rtMsg);
//    rtLen = RTM_PAYLOAD(nlHdr);
//    for(;RTA_OK(rtAttr,rtLen);rtAttr = RTA_NEXT(rtAttr,rtLen)){
//        switch(rtAttr->rta_type) {
//            case RTA_OIF:
//                if_indextoname(*(int *)RTA_DATA(rtAttr), rtInfo->ifName);
//                break;
//            case RTA_GATEWAY:
//                rtInfo->gateWay = *(u_int *)RTA_DATA(rtAttr);
//                break;
//            case RTA_PREFSRC:
//                rtInfo->srcAddr = *(u_int *)RTA_DATA(rtAttr);
//                break;
//            case RTA_DST:
//                rtInfo->dstAddr = *(u_int *)RTA_DATA(rtAttr);
//                break;
//        }
//    }
//    //printf("%s\n", (char *)inet_ntoa(rtInfo->dstAddr));
//    
//    // ADDED BY BOB - ALSO COMMENTED printRoute
//    
//    if (strstr((char *)inet_ntoa(rtInfo->dstAddr), "0.0.0.0"))
//        sprintf(gateway, (char *)inet_ntoa(rtInfo->gateWay));
//    //printRoute(rtInfo);
//    
//    free(tempBuf);
//    return;
//}
//
//int get_gateway(char *gateway)
//{
//    struct nlmsghdr *nlMsg;
//    struct rtmsg *rtMsg;
//    struct route_info *rtInfo;
//    char msgBuf[BUFSIZE];
//    
//    int sock, len, msgSeq = 0;
//    char buff[1024];
//    
//    
//    /* Create Socket */
//    if((sock = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_ROUTE)) < 0)
//        perror("Socket Creation: ");
//    
//    /* Initialize the buffer */
//    memset(msgBuf, 0, BUFSIZE);
//    
//    /* point the header and the msg structure pointers into the buffer */
//    nlMsg = (struct nlmsghdr *)msgBuf;
//    rtMsg = (struct rtmsg *)NLMSG_DATA(nlMsg);
//    
//    /* Fill in the nlmsg header*/
//    nlMsg->nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg)); // Length of message.
//    
//    nlMsg->nlmsg_type = RTM_GETROUTE; // Get the routes from kernel routing table .
//    
//    
//    nlMsg->nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST; // The message is a request for dump.
//    
//    nlMsg->nlmsg_seq = msgSeq++; // Sequence of the message packet.
//    
//    nlMsg->nlmsg_pid = getpid(); // PID of process sending the request.
//    
//    
//    /* Send the request */
//    if(send(sock, nlMsg, nlMsg->nlmsg_len, 0) < 0){
//        printf("Write To Socket Failed...\n");
//        return -1;
//    }
//    
//    /* Read the response */
//    if((len = readNlSock(sock, msgBuf, msgSeq, getpid())) < 0) {
//        printf("Read From Socket Failed...\n");
//        return -1;
//    }
//    /* Parse and print the response */
//    rtInfo = (struct route_info *)malloc(sizeof(struct route_info));
//    // ADDED BY BOB
//    
//    /* THIS IS THE NETTSTAT -RL code I commented out the printing here and in parse routes */
//    //fprintf(stdout, "Destination\tGateway\tInterface\tSource\n");
//    
//    for(;NLMSG_OK(nlMsg,len);nlMsg = NLMSG_NEXT(nlMsg,len)){
//        memset(rtInfo, 0, sizeof(struct route_info));
//        parseRoutes(nlMsg, rtInfo,gateway);
//    }
//    free(rtInfo);
//    close(sock);
//    
//    return 0;
//}
//
//int route()
//{
//    char gateway[255]={0};
//    get_gateway(gateway);
//    printf("Gateway:%s\n", gateway);
//}
