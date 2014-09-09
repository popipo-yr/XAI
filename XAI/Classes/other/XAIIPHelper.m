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
#include <pthread.h>

#define _IP_SIZE_MAX  30

int getdefaultgateway(in_addr_t * addr);

void *_getIp_thread_ever(void *obj);
void *_getIp_thread_main(void *obj);

pthread_t thread_id;

pthread_t main_thread_id;



void getApserverIpResult(struct Helper* p_helper, _err rc){
    
    p_helper->err = rc;
    XAIIPHelper* aIPHelper  = (__bridge XAIIPHelper*)p_helper->who;
    [aIPHelper _res_getApserverIp:p_helper->ip_char err:rc];
    
    
    p_helper->isFinish = true;
    
}

void cleanup(void *arg){
    
    printf("cleanup: %s\n",(char *)arg);
}


@implementation XAIIPHelper


-(id)init{
    
    if (self = [super init]) {
        
        _p_helper = malloc(sizeof(Helper));
        
        _p_helper->who = (__bridge void *)(self);
        _p_helper->host = NULL;
        _p_helper->ip_char = malloc(_IP_SIZE_MAX);
        _p_helper->isGetSuc = false;
        _p_helper->getApserverIpResult = getApserverIpResult;
        
        
        _create_p = false;
    }
    
    return self;
}

-(void)dealloc{
    
    _p_helper->who = nil;
    
    if (_create_p) {
        
        pthread_cancel(thread_id);
        _create_p = false;
    }
    
    if (_timer != nil) {
        
        [_timer invalidate];
        _timer = nil;

    }
    
    if (_p_helper->host != NULL) {
        free(_p_helper->host);
        _p_helper->host = NULL;
    }
    
    free(_p_helper->ip_char);
    
    _p_helper->getApserverIpResult = nil;
    
    free(_p_helper);
    _p_helper = nil;

    
    XSLog(@"dealloc");
}

-(void)cancelTimeout
{
    //[[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (void) _res_getApserverIp:(const char*)ip err:(_err) rc{
    
    _create_p = false;
    
    //[self performSelectorOnMainThread:@selector(cancelTimeout) withObject:nil waitUntilDone:NO];
    
    
    if (rc == _err_none) {/*成功返回*/
        
        //        _ipStr = [NSString stringWithUTF8String:ip];
        //
        //        if (_delegate != NULL && [_delegate respondsToSelector:@selector(xaiIPHelper:getIp:errcode:)]) {
        //
        //            [_delegate xaiIPHelper:self getIp:_ipStr errcode:rc];
        //        }
        //
        //        if (_create_p) {
        //
        //            pthread_cancel(thread_id);
        //            _create_p = false;
        //        }
        
    }else{
        
        //[self getApserverIpHelper];
        
    }
    
}




- (int) _get_from_route_start{
    
    
    if (_create_p) {
        
        pthread_cancel(thread_id);
        _create_p = false;
    }
    
    
    /*从路由器获取*/
    in_addr_t gataway;
    int ret = getdefaultgateway(&gataway);
    
    /*获取网关成功*/
    if (ret == 0) {
        
        if (_p_helper->host != NULL) {
            free(_p_helper->host);
            _p_helper->host = NULL;
        }
        
        char*  routeip = inet_ntoa(*(struct in_addr *)&gataway);
        
        size_t size = strlen(routeip)+1;
        char*  s = malloc(size);
        memcpy(s, routeip, size);
        
        
        _p_helper->apsn = _apsn;
        _p_helper->host = s;
        
        _p_helper->isFinish = false;
        
        
        _create_p = true;
        pthread_create(&thread_id, NULL, _getIp_thread_ever, _p_helper);
        
        [[self class] cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(timeout) withObject:NULL afterDelay:1.0f];
        
        return 0;
        
    }
    
    return -1;
    
}


- (void) _get_from_cloud_start{
    
    
    if (_create_p) {
        
        pthread_cancel(thread_id);
        _create_p = false;
    }
    
    if (_p_helper->host != NULL) {
        free(_p_helper->host);
        _p_helper->host = NULL;
    }
    
    size_t size = [[_host dataUsingEncoding:NSUTF8StringEncoding] length]+1;
    char*  s = malloc(size);
    memset(s, 0, size);
    memcpy(s, [_host UTF8String], size);
    
    
    
    _p_helper->apsn = _apsn;
    _p_helper->host = s;
    _p_helper->isFinish = false;
    
    
    _create_p = true;
    pthread_create(&thread_id, NULL, _getIp_thread_ever, _p_helper);
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(timeout) withObject:NULL afterDelay:6.0f];
    
    
    
}



- (void)getApserverIpHelper{
    
    
    if (_p_helper->isGetSuc){
        
        printf("IPS = %s",_p_helper->ip_char);
        
        if ( _delegate != NULL && [_delegate respondsToSelector:@selector(xaiIPHelper:getIp:errcode:)]) {
            
            [_delegate xaiIPHelper:self getIp:[NSString stringWithUTF8String:_p_helper->ip_char] errcode:_p_helper->err];
        }
        
        
        [_timer invalidate];
        _timer = nil;
        
        return;
    }
    
    
    
    
    if (_getStep == _XAIIPHelper_GetStep_Start ) {
        
        _getStep = _XAIIPHelper_GetStep_FromRoute;
        
        if (0 != [self _get_from_route_start]) {
            
            _getStep = _XAIIPHelper_GetStep_FromRoute;
            [self _get_from_cloud_start];
        }
        
        
    }else if (_getStep == _XAIIPHelper_GetStep_FromRoute){
        
        _getStep = _XAIIPHelper_GetStep_FromCloud;
        [self _get_from_cloud_start];
        
        
    }else{
        
        [_timer invalidate]; //必须在前面
        
        /*所有方式结束,通知*/
        
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(xaiIPHelper:getIp:errcode:)]) {
            
            [_delegate xaiIPHelper:self getIp:nil errcode:_err_timeout];
        }
        
        if (_create_p) {
            
            pthread_cancel(thread_id);
            _create_p = false;
        }
        
        printf("%i",_p_helper->err);
        
    }
    
}



- (void)getApserverIpWithApsn:(XAITYPEAPSN)apsn fromRoute:(NSString*)host{
    
//            if ( _delegate != NULL && [_delegate respondsToSelector:@selector(xaiIPHelper:getIp:errcode:)]) {
//    
//                [_delegate xaiIPHelper:self getIp:@"192.168.1.236" errcode:0];
//            }
//    
//    
//        return;
    
    _host = host;
    _ipStr = nil;
    _apsn = apsn;
    
    _getStep = _XAIIPHelper_GetStep_Start;
    
    _p_helper->isFinish = false;
    _p_helper->isGetSuc = false;
    
    [self getApserverIpHelper];
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5  // 10ms
                                              target:self
                                            selector:@selector(getSteps)
                                            userInfo:nil
                                             repeats:YES];
    
}


- (void) getSteps{
    
    if (_p_helper->isFinish) {
        
        [self getApserverIpHelper];
        
    }
    
    
    
}


-(void)timeout{
    
    if (_create_p) {
        
        pthread_cancel(thread_id);
        _create_p =false;
        
    }
    
    _p_helper->isFinish = true;
    
}

void *_getIp_thread_ever(void *obj){
    
    //pthread_cleanup_push(cleanup, "ruote")
    
    Helper* p_helper = (Helper*)obj;
    
    int sock;
    int recbytes;
    char buffer[1024]={0};
    uint16_t portnum=9002;
    
    struct addrinfo hints;
	struct addrinfo *ainfo, *rp;
    
    
    memset(&hints, 0, sizeof(struct addrinfo));
	hints.ai_family = PF_UNSPEC;
	hints.ai_flags = AI_ADDRCONFIG;
	hints.ai_socktype = SOCK_STREAM;
    
    _err res = _err_unkown;
    
    do {
        
        int s = getaddrinfo(p_helper->host, NULL, &hints, &ainfo);
        
        if(s){
            
            printf("getaddr %s  : %s\n", p_helper->host, gai_strerror(s));
            res = _err_get_host_ip_fail;
            break;
        }

        
        #define INVALID_SOCKET -1
        
        BOOL bconnected = false;
        
        for(rp = ainfo; rp != NULL; rp = rp->ai_next){
            sock = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
            if(sock == INVALID_SOCKET) continue;
            
            if(rp->ai_family == PF_INET){
                ((struct sockaddr_in *)rp->ai_addr)->sin_port = htons(portnum);
            }else if(rp->ai_family == PF_INET6){
                ((struct sockaddr_in6 *)rp->ai_addr)->sin6_port = htons(portnum);
            }else{
                continue;
            }
            
            //ioctlsocket();
            if(connect(sock, rp->ai_addr, rp->ai_addrlen) != -1){
                
                bconnected = true;
                break;
            }
        }
        
        
        if (!bconnected) {
            
            res = _err_connect_fail;
            break;
        }
        
        
        
        printf("connect ok !\r\n");
        
        
        char  wBuf[100] = {0};
        uint8_t  req = 0x03;
        XAITYPEAPSN  apsn = p_helper->apsn;
        XAITYPEAPSN napsn = CFSwapInt32(apsn);
        uint32_t serip = 0x0;
        
        memcpy(wBuf, &req, sizeof(uint8_t));
        memcpy(wBuf+sizeof(uint8_t), &napsn, sizeof(XAITYPEAPSN));
        memcpy(wBuf+sizeof(uint8_t)+sizeof(XAITYPEAPSN), &serip, sizeof(serip));
        
        
        size_t pack_size = sizeof(uint8_t)+sizeof(XAITYPEAPSN)+sizeof(uint32_t);
        
        write(sock, wBuf , pack_size);
        
        memset(buffer, 0 , sizeof(buffer));
        
        if(pack_size != (recbytes = read(sock,buffer,1024)))
        {
            printf("read data fail !\r\n");
            close(sock);
            res = _err_get_data_fail;
            break;
        }
        printf("read ok\r\nREC:\r\n");
        buffer[recbytes]='\0';
        printf("%s\r\n",buffer);
        
        memcpy(&serip, buffer+sizeof(uint8_t)+sizeof(XAITYPEAPSN), sizeof(uint32_t));
        
        char*  ipstr = inet_ntoa(*(struct in_addr *)&serip);
        
        printf("ip = %s\n", ipstr);
        
        size_t copysize = strlen(ipstr) + 1;
        if (strlen(ipstr) + 1 > _IP_SIZE_MAX) {
            copysize = _IP_SIZE_MAX;
        }
        memset(p_helper->ip_char, 0, _IP_SIZE_MAX);
        memcpy(p_helper->ip_char, ipstr, copysize);
        
        close(sock);
        
        p_helper->isGetSuc = true;
        res = _err_none;
        
    } while (0);
    
    
    freeaddrinfo(ainfo);
    
    p_helper->getApserverIpResult(p_helper,res);
    
    return obj;
}


@end



#include <stdio.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <sys/sysctl.h>
#include <net/if.h>

#if TARGET_IPHONE_SIMULATOR
#include <net/route.h>
#else
#include "route.h"
#endif

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
            free(buf);
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





