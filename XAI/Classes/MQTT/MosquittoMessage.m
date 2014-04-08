//
//  MosquittoMessage.m
//  Marquette
//
//  Created by horace on 11/10/12.
//
//

#import "MosquittoMessage.h"

@implementation MosquittoMessage

@synthesize mid, topic, payload, payloadlen, qos, retained;

-(id)init
{
    self.mid = 0;
    self.topic = nil;
    self.payload = nil;
    self.payloadlen = 0;
    self.qos = 0;
    self.retained = FALSE;
    payloadbyte = NULL;
    
    return self;
}

- (void)dealloc{

    free(payloadbyte);
    payloadbyte = NULL;
}

-(void)  setPayloadbyte:(void*) bytes withSize:(int) size{
    
    payloadbyte = malloc(size);
    memcpy(payloadbyte, bytes, size);
}
-(void*)  getPayloadbyte{

    return payloadbyte;
}

@end
