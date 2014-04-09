//
//  XAILogin.m
//  XAI
//
//  Created by touchhy on 14-4-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILogin.h"
//#include "openssl/ssl.h"

@implementation XAILogin

- (void) loginWithName:(NSString*)name Password:(NSString*)password Host:(NSString*)host{

    MosquittoClient*  mosq = [MQTT shareMQTT].client;

    host = @"192.168.1.1";
    name = @"admin@0x00000001";
    password = @"admin";
    
    
	[mosq setHost: host];
    [mosq setUsername:name];
    [mosq setPassword:password];
    [mosq setPort:9001];
    
//        mosquitto_tls_set(struct mosquitto *mosq, const char *cafile, const char *capath, const char *certfile, const char *keyfile, int (*pw_callback)(char *buf, int size, int rwflag, void *userdata))
    
    
//    SSL_CTX *ctx = NULL;
//    
//    const unsigned char *cert_data = NULL;
//    int cert_len = 0;
//    
//    X509 * cert = d2i_X509(NULL, &cert_data, cert_len);
//    SSL_CTX_use_certificate(ctx, cert);
    
    
    //curl_setopt($ch, CURLOPT_CAINFO, 'E:\path\to\curl-ca-bundle.crt');
	
    
    [[MQTT shareMQTT].packetManager setConnectDelegate:self];
    
    [mosq connect];

}

- (void) didConnect:(NSUInteger)code {
	
}

- (void) didDisconnect {
	
}

#pragma mark -------------
#pragma makr PacketPro

- (void) sendPacketIsSuccess:(BOOL) bl{
}
- (void) recivePacket:(void*)datas size:(int)size{

}

@end
