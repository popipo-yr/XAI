//
//  UserService.m
//  XAI
//
//  Created by office on 14-4-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XAIUserService.h"


#import "LoginTest.h"

XAITYPELUID  ____luid;

@interface UserServiceTest  : LoginTest <XAIUserServiceDelegate> {//XCTestCase <XAIUserServiceDelegate> {


    XAIUserService*  _userService;
    
    
    int _addStatus;
    int _delStatus;
    int _changeNameStatus;
    int _changePWDStatus;
    
    int _findStatus;
    
    NSString* _name4Change;
    NSString* _pwd4Change;
    
    
    NSString* _pwd4Change_end;
    NSString* _name4Change_end;
    
    
    XAITYPELUID  _luiduser;

}

@end

@implementation UserServiceTest

- (void)setUp
{
    _userService = [[XAIUserService alloc] init];
    _userService.delegate = self;
    
    
    _name4Change = @"NAME2";
    _pwd4Change = @"PWD1";
    _pwd4Change_end = @"PWD2";
    _name4Change_end = @"NAME2";
    
    
    ____luid = 0x118;
//    ____luid = [[NSUserDefaults standardUserDefaults] integerForKey:@"LUID"];
//    
//    NSDictionary* _dic;
//    [_dic writeToFile:[ns ] atomically:<#(BOOL)#>]
    _luiduser = ____luid;//0x118;
    
    
    
    
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    _userService = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

static inline void runInMainLoop(void(^block)(BOOL *done)) {
    __block BOOL done = NO;
    
    while (!done) {
        
        block(&done);
        [[NSRunLoop mainRunLoop] runUntilDate:
         [NSDate dateWithTimeIntervalSinceNow:.1]];
    }
}



- (void)testAdd
{

    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService addUser:_name4Change Password:_pwd4Change apsn:[MQTT shareMQTT].apsn luid:MQTTCover_LUID_Server_03];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > 0) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_addStatus != 0, @"delegate did not get called");
        XCTAssertTrue (_addStatus != 2, @"add faild");
    }else{
    
    
        XCTFail(@"LOGIN FAILD");
    }
    
    
    [_userService finderUserLuidHelper:_name4Change apsn:[MQTT shareMQTT].apsn luid:
     MQTTCover_LUID_Server_03];
    
    _findStatus = start;
    
    
    runInMainLoop(^(BOOL * done) {
        
        if (_findStatus > 0) {
            
            *done = YES;
        }
    });
    
    
    XCTAssertTrue (_findStatus != start, @"delegate did not get called");
    XCTAssertTrue (_findStatus != Fail, @"add faild");

    
    
    

}


- (void)testFind
{
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService finderUserLuidHelper:_name4Change apsn:[MQTT shareMQTT].apsn luid:
         MQTTCover_LUID_Server_03];
        
        _findStatus = start;
        
        
        runInMainLoop(^(BOOL * done) {
            
            if (_findStatus > 0) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_findStatus != start, @"delegate did not get called");
        XCTAssertTrue (_findStatus != Fail, @"Find faild");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
    
    
    
    
}


- (void)testChangePWD
{
    
    [self testLoginWithName:_name4Change PWD:_pwd4Change];
    //[self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService changeUser:_luiduser oldPassword:_pwd4Change to:_pwd4Change_end apsn:[MQTT shareMQTT].apsn luid:MQTTCover_LUID_Server_03];
        
        
        _changePWDStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changePWDStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_changePWDStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changePWDStatus != Fail, @"change pwd faild");
        
        if (_changePWDStatus == Success) {
            
            NSString* swap = _pwd4Change;
            _pwd4Change = _pwd4Change_end;
            _pwd4Change_end = swap;
        }
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}



- (void)testChangeName
{
    
    [self testLoginWithName:_name4Change PWD:_pwd4Change_end];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService changeUser:_luiduser withName:_name4Change_end apsn:[MQTT shareMQTT].apsn luid:MQTTCover_LUID_Server_03];
        
        
        _changeNameStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changeNameStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_changeNameStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changeNameStatus != Fail, @"change name faild");
        
        
        if (_changeNameStatus == Success) {
            
            NSString* swap = _name4Change;
            _name4Change = _name4Change_end;
            _name4Change_end = swap;
        }

        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}




- (void)testDel
{
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService delUser:_luiduser  apsn:[MQTT shareMQTT].apsn luid:MQTTCover_LUID_Server_03];
        
        
        _delStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_delStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Fail, @"del user faild");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}




- (void) addUser:(BOOL) isSuccess{

    if (isSuccess == TRUE) {
        
        _addStatus = 1;
    }else{
        
        _addStatus = 2;
    }

}
- (void) delUser:(BOOL) isSuccess{
    
    if (isSuccess == TRUE) {
        
        _delStatus = Success;
    }else{
        
        _delStatus = Fail;
    }


}
- (void) changeUserName:(BOOL) isSuccess{
    
    if (isSuccess == TRUE) {
        
        _changeNameStatus = Success;
    }else{
        
        _changeNameStatus = Fail;
    }


}
- (void) changeUserPassword:(BOOL)isSuccess{
    
    if (isSuccess == TRUE) {
        
        _changePWDStatus = Success;
    }else{
        
        _changePWDStatus = Fail;
    }

    
}
- (void) findedUser:(BOOL) isFinded Luid:(XAITYPELUID) luid withName:(NSString*) name{

    if (isFinded == TRUE) {
        
        _findStatus = Success;
        
        _luiduser = luid;
        ____luid = luid;
        
        [[NSUserDefaults standardUserDefaults] setInteger:luid forKey:@"LUID"];
        
    }else{
        
        _findStatus = Fail;
    }


}

@end
