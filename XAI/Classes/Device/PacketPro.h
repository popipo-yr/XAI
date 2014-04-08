//
//  PacketPro.h
//  XAI
//
//  Created by mac on 14-4-7.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#ifndef XAI_PacketPro_h
#define XAI_PacketPro_h

@protocol PacketPro <NSObject>

- (void) sendPacketIsSuccess:(BOOL) bl;
- (void) recivePacket:(void*)datas size:(int)size;

@end


#endif
