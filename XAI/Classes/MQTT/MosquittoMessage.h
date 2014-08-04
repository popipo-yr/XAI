//
//  MosquittoMessage.h
//  Marquette
//
//  Created by horace on 11/10/12.
//
//

#import <Foundation/Foundation.h>

@interface MosquittoMessage : NSObject
{
    unsigned short mid;
    NSString *topic;
    NSString *payload;
    unsigned short payloadlen;
    unsigned short qos;
    BOOL retained;
    
    void* payloadbyte;
}

@property (readwrite, assign) unsigned short mid;
@property (readwrite, strong) NSString *topic;
@property (readwrite, strong) NSString *payload;
@property (readwrite, assign) unsigned short payloadlen;
@property (readwrite, assign) unsigned short qos;
@property (readwrite, assign) BOOL retained;

@property (nonatomic,assign) int change;

-(void)  setPayloadbyte:(void*) bytes withSize:(int) size;
-(void*)  getPayloadbyte;

-(id)init;

@end