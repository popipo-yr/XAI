//
//  MosquittoClient.m
//
//  Copyright 2012 Nicholas Humfrey. All rights reserved.
//

#import "MosquittoClient.h"
#import "mosquitto.h"

@implementation MosquittoClient

@synthesize host;
@synthesize port;
@synthesize username;
@synthesize password;
@synthesize keepAlive;
@synthesize cleanSession;
//@synthesize delegate;

static bool __ISING = false;

static void on_connect(struct mosquitto *mosq, void *obj, int rc)
{
    MosquittoClient* client = (__bridge MosquittoClient*)obj;
    
    if (client != nil && client.delegate != nil &&  [client.delegate respondsToSelector:@selector(didConnect:)]) {
        [[client delegate] didConnect:(NSUInteger)rc];
    }
    
    if (client != nil && client.delegate != nil &&  [client.delegate respondsToSelector:@selector(change)]) {
        [[client delegate] change];
    }
    
    if (client != nil && client.keepAliveDelegate != nil && [client.keepAliveDelegate respondsToSelector:@selector(didConnect:)]) {
        [client.keepAliveDelegate didConnect:rc];
    }

}

static void on_disconnect(struct mosquitto *mosq, void *obj, int rc)
{
    XSLog_(@"disconnect call back");
    MosquittoClient* client = (__bridge MosquittoClient*)obj;
    
    if (client != nil && client.delegate != nil &&  [client.delegate respondsToSelector:@selector(didDisconnect)]) {
        [[client delegate] didDisconnect];
    }
    
    if (client != nil && client.delegate != nil &&  [client.delegate respondsToSelector:@selector(didDisconnect:)]) {
        [[client delegate] didDisconnect:rc];
    }
    
    if (client != nil && client.keepAliveDelegate != nil && [client.keepAliveDelegate respondsToSelector:@selector(didDisconnect)]) {
        [client.keepAliveDelegate didDisconnect];
    }
    
    if (client != nil && client.delegate != nil &&  [client.delegate respondsToSelector:@selector(change)]) {
        [[client delegate] change];
    }
}

static void on_publish(struct mosquitto *mosq, void *obj, int message_id)
{
    MosquittoClient* client = (__bridge MosquittoClient*)obj;
    
    if (client != nil && client.delegate != nil &&  [client.delegate respondsToSelector:@selector(didPublish:)]) {
        [[client delegate] didPublish:(NSUInteger)message_id];
    }

    
}

static void on_message(struct mosquitto *mosq, void *obj, const struct mosquitto_message *message)
{
    __ISING = true;
    //@autoreleasepool {
    XSLog(@"MQTT-MSG-IN");
    MosquittoMessage *mosq_msg = [[MosquittoMessage alloc] init];
    mosq_msg.mid = message->mid;
    mosq_msg.topic = [NSString stringWithUTF8String: message->topic];
    mosq_msg.payload = [[NSString alloc] initWithBytes:message->payload
                                                 length:message->payloadlen
                                               encoding:NSUTF8StringEncoding];
    
    [mosq_msg setPayloadbyte:message->payload withSize:message->payloadlen];
    
    MosquittoClient* client = (__bridge MosquittoClient*)obj;
    
    //[[client delegate] didReceiveMessage:payload topic:topic];
    if (client != nil && client.delegate != nil &&  [client.delegate respondsToSelector:@selector(didReceiveMessage:)]) {
        [[client delegate] didReceiveMessage:mosq_msg];
    }
    
//        MosquittoMessage *mosq_msg = [[MosquittoMessage alloc] init];
//        mosq_msg.topic = [NSString stringWithUTF8String: message->topic];
//        mosq_msg.payload = [[NSString alloc] initWithBytes:message->payload
//                                                    length:message->payloadlen
//                                                  encoding:NSUTF8StringEncoding];
//        
//        [mosq_msg setPayloadbyte:message->payload withSize:message->payloadlen];
//        
//        MosquittoClient* client = (__bridge MosquittoClient*)obj;
//        
//        [client performSelectorOnMainThread:@selector(hasmessage:) withObject:mosq_msg waitUntilDone:true];
    
    XSLog(@"MQTT-MSG-OUT");
    
    if (client != nil && client.delegate != nil &&  [client.delegate respondsToSelector:@selector(change)]) {
        [[client delegate] change];
    }

    //}
    __ISING = false;
}

static void on_subscribe(struct mosquitto *mosq, void *obj, int message_id, int qos_count, const int *granted_qos)
{
    MosquittoClient* client = (__bridge MosquittoClient*)obj;
    // FIXME: implement this
    if (client != nil && client.delegate != nil &&  [client.delegate respondsToSelector:@selector(didSubscribe:grantedQos:)]) {
        [[client delegate] didSubscribe:message_id grantedQos:nil];
    }
}

static void on_unsubscribe(struct mosquitto *mosq, void *obj, int message_id)
{
    MosquittoClient* client = (__bridge MosquittoClient*)obj;
     if (client != nil && client.delegate != nil &&  [client.delegate respondsToSelector:@selector(didUnsubscribe:)]) {
         [[client delegate] didUnsubscribe:message_id];
     }
}

static void on_log(struct mosquitto *mosq, void *userdata, int level, const char *str){
    
    //printf("mqtt-log:%s\n\n",str);
}


- (void) hasmessage:(MosquittoMessage*) mosq_msg{

    [[self delegate] didReceiveMessage:mosq_msg];
}

// Initialize is called just before the first object is allocated
+ (void)initialize {
    mosquitto_lib_init();
}

+ (NSString*)version {
    int major, minor, revision;
    mosquitto_lib_version(&major, &minor, &revision);
    return [NSString stringWithFormat:@"%d.%d.%d", major, minor, revision];
}

- (MosquittoClient*) initWithClientId: (NSString*) clientId {
    if ((self = [super init])) {
        const char* cstrClientId = [clientId cStringUsingEncoding:NSUTF8StringEncoding];
        [self setHost: nil];
        [self setPort: 9001];
        [self setKeepAlive: 60];
        [self setCleanSession: FALSE]; //NOTE: this isdisable clean to keep the broker remember this client
        
        
        
        

        
        mosq = mosquitto_new(cstrClientId, cleanSession, (__bridge void *)(self));
        mosquitto_connect_callback_set(mosq, on_connect);
        mosquitto_disconnect_callback_set(mosq, on_disconnect);
        mosquitto_publish_callback_set(mosq, on_publish);
        mosquitto_message_callback_set(mosq, on_message);
        mosquitto_subscribe_callback_set(mosq, on_subscribe);
        mosquitto_unsubscribe_callback_set(mosq, on_unsubscribe);
        mosquitto_log_callback_set(mosq, on_log);
        
        NSString *certPath = [[NSBundle mainBundle] pathForResource:@"ca" ofType:@"crt"];  
        mosquitto_tls_set(mosq,[certPath cStringUsingEncoding:NSUTF8StringEncoding]
                          ,[[[NSBundle mainBundle] bundlePath] cStringUsingEncoding:NSUTF8StringEncoding]
                          ,NULL//[certPath cStringUsingEncoding:NSUTF8StringEncoding],
                          ,NULL//[certPath cStringUsingEncoding:NSUTF8StringEncoding],
                          ,NULL);

        
        timer = nil;
    }
    return self;
}


- (void) connect {
//    const char *cstrHost = [host cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cstrUsername = NULL, *cstrPassword = NULL;
    
    if (username)
        cstrUsername =  [username cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (password)
        cstrPassword =  [password cStringUsingEncoding:NSUTF8StringEncoding];
    
    // FIXME: check for errors
    mosquitto_username_pw_set(mosq, cstrUsername, cstrPassword);
    
  
    [NSThread detachNewThreadSelector:@selector(startSynConnect) toTarget:self withObject:nil];
    
}

- (void) startSynConnect{

    const char *cstrHost = [host cStringUsingEncoding:NSASCIIStringEncoding];
    
    int rc = mosquitto_connect(mosq, cstrHost, port, keepAlive);

    [self performSelectorOnMainThread:@selector(connectFinish:) withObject:[NSNumber numberWithInt:rc] waitUntilDone:YES];
     

}
         
         
- (void) connectFinish:(NSNumber*) rc{
    
    if ([rc intValue] == MOSQ_ERR_SUCCESS) {
        
        if (timer != nil && [timer isValid]) {
            
            [timer invalidate];
        }
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 // 10ms
                                                 target:self
                                               selector:@selector(loop:)
                                               userInfo:nil
                                                repeats:YES];
        
        __ISING = false;
    }else{
        
        
        [self.delegate didDisconnect];
        
    }
    
    
}

- (void) connectToHost: (NSString*)aHost {
    [self setHost:aHost];
    [self connect];
}

- (void) reconnect {
    //mosquitto_reconnect(mosq);
    
        [NSThread detachNewThreadSelector:@selector(asynReconnect) toTarget:self withObject:nil];
}


- (void)asynReconnect{
    mosquitto_reconnect(mosq);
}

- (void) disconnect {
//    if (timer != nil) {
//        [timer invalidate];
//        timer = nil;
//    }
    mosquitto_disconnect(mosq);
}

- (void) loop: (NSTimer *)timer {
    if (__ISING) {
        return;
    }
    mosquitto_loop(mosq, 1, 1);
}


- (void)setWill: (NSString *)payload toTopic:(NSString *)willTopic withQos:(NSUInteger)willQos retain:(BOOL)retain;
{
    const char* cstrTopic = [willTopic cStringUsingEncoding:NSUTF8StringEncoding];
    const uint8_t* cstrPayload = (const uint8_t*)[payload cStringUsingEncoding:NSUTF8StringEncoding];
    size_t cstrlen = [payload lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    mosquitto_will_set(mosq, cstrTopic, cstrlen, cstrPayload, willQos, retain);
}

- (void)setWillB:(uint8_t)payload toTopic:(NSString *)willTopic withQos:(NSUInteger)willQos retain:(BOOL)retain{

    const char* cstrTopic = [willTopic cStringUsingEncoding:NSUTF8StringEncoding];
    mosquitto_will_set(mosq, cstrTopic, 1, &payload, willQos, retain);

}

- (void)clearWill
{
    mosquitto_will_clear(mosq);
}


- (void)publishString: (NSString *)payload toTopic:(NSString *)topic withQos:(NSUInteger)qos retain:(BOOL)retain {
    const char* cstrTopic = [topic cStringUsingEncoding:NSUTF8StringEncoding];
    const uint8_t* cstrPayload = (const uint8_t*)[payload cStringUsingEncoding:NSUTF8StringEncoding];
    size_t cstrlen = [payload lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    mosquitto_publish(mosq, NULL, cstrTopic, cstrlen, cstrPayload, qos, retain);
    
}


- (void)publish:(void*)payload size:(int)size toTopic:(NSString *)topic withQos:(NSUInteger)qos retain:(BOOL)retain{

    const char* cstrTopic = [topic cStringUsingEncoding:NSUTF8StringEncoding];
    const uint8_t* cstrPayload = (const uint8_t*)payload;
    size_t cstrlen = size;
    mosquitto_publish(mosq, NULL, cstrTopic, cstrlen, cstrPayload, qos, retain);


}


- (void)subscribe: (NSString *)topic {
    [self subscribe:topic withQos:0];
}

- (void)subscribe: (NSString *)topic withQos:(NSUInteger)qos {
    const char* cstrTopic = [topic cStringUsingEncoding:NSUTF8StringEncoding];
    mosquitto_subscribe(mosq, NULL, cstrTopic, qos);
}

- (void)unsubscribe: (NSString *)topic {
    const char* cstrTopic = [topic cStringUsingEncoding:NSUTF8StringEncoding];
    mosquitto_unsubscribe(mosq, NULL, cstrTopic);
}


- (void) setMessageRetry: (NSUInteger)seconds
{
    mosquitto_message_retry_set(mosq, (unsigned int)seconds);
}


- (void) startwork{
    __ISING = false;
    
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 // 10ms
                                                 target:self
                                               selector:@selector(loop:)
                                               userInfo:nil
                                                repeats:YES];

    }
}

- (void) endwork{
    __ISING = true;
    
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
}

- (void) willRemove{
    [self disconnect];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void) dealloc {
    if (mosq) {
        mosquitto_destroy(mosq);
        mosq = NULL;
    }
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
}

// FIXME: how and when to call mosquitto_lib_cleanup() ?

@end
