//
//  UserService.m
//  XAI
//
//  Created by office on 14-4-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XAIUserService.h"


#import "LoginPlugin.h"

XAITYPELUID  ____luid;

@interface UserServiceTest  : LoginPlugin <XAIUserServiceDelegate> {//XCTestCase <XAIUserServiceDelegate> {


    XAIUserService*  _userService;
    
    
    int _addStatus;
    int _delStatus;
    int _changeNameStatus;
    int _changePWDStatus;
    
    int _findStatus;
    int _findAllStatus;
    
    int _getStatus;
    
    NSString* _name4Change;
    NSString* _pwd4Change;
    
    
    NSString* _pwd4Change_end;
    NSString* _name4Change_end;
    
    
    XAITYPELUID  _luiduser;
    
    XAI_ERROR _err;

}

@end

@implementation UserServiceTest

- (void)setUp
{
    _userService = [[XAIUserService alloc] init];
    [MQTT shareMQTT].apsn = 1;
    _userService.apsn = [MQTT shareMQTT].apsn;
    _userService.luid = MQTTCover_LUID_Server_03;
    _userService.userServiceDelegate = self;
    
    
    _name4Change = @"NAME222";
    _pwd4Change = @"PWD1";
    _pwd4Change_end = @"PWD2";
    _name4Change_end = @"NAME2";
    
    
    ____luid = 258;
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

- (void)_testGetDeviceStatus
{
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService getDeviceStatus];
        
        
        _getStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getStatus != start, @"delegate did not get called");
        XCTAssertTrue (_getStatus != Fail, @"get dev status faild");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


- (void) _addName:(NSString*)name pawd:(NSString*)pawd{

    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService addUser:_name4Change Password:_pwd4Change];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > 0) {
                
                *done = YES;
            }
        });
    }

}

- (void)_del:(XAITYPELUID)luid
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        [_userService delUser:_luiduser];
        
        
        _delStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_delStatus > start) {
                
                *done = YES;
            }
        });
    }
    
}


- (void)test_1_1_Add_TRUE
{

    [self _addName:_name4Change pawd:_pwd4Change];
    
    if (_loginStatus == Success) {
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Fail, @"add faild");
        XCTAssert(_err == XAI_ERROR_NONE, @"yes. add user suc");
    }else{
    
    
        XCTFail(@"LOGIN FAILD");
    }

}


- (void)test_1_2_Add_NameRep
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService addUser:_name4Change Password:_pwd4Change];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > 0) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"add faild");
        XCTAssert(_err == XAI_ERROR_MODLE_BRIDGE, @"yes. username is exist");
        
        //XAI_ERROR_name_exit
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}




- (void)test_1_3_Add_NameNull
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService addUser:NULL Password:@"NOTUSE"];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > 0) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"add faild");
        XCTAssert(_err == XAI_ERROR_NULL_POINTER, @"yes , username is NULL");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void)test_1_4_Add_PawdNull
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService addUser:@"NOTUSE" Password:NULL];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > 0) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"add faild");
        XCTAssert(_err == XAI_ERROR_NULL_POINTER, @"yes , password is NULL");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}



- (void)test_2_1_ChangeName_TRUE
{
    
    [self testLoginWithName:_name4Change PWD:_pwd4Change];
    
    if (_loginStatus_normal == Success) {
        
        
        
        [_userService changeUser:_luiduser withName:_name4Change_end];
        
        
        _changeNameStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changeNameStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_changeNameStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changeNameStatus != Fail, @"change name faild");
        XCTAssert(_err == XAI_ERROR_NONE, @"yes . change username suc");
        
        
        if (_changeNameStatus == Success) {
            
            NSString* swap = _name4Change;
            _name4Change = _name4Change_end;
            _name4Change_end = swap;
        }
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


- (void)test_2_2_ChangeName_NameNull
{
    
    [self testLoginWithName:_name4Change PWD:_pwd4Change];
    
    if (_loginStatus_normal == Success) {
        
        
        
        [_userService changeUser:_luiduser withName:NULL];
        
        
        _changeNameStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changeNameStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_changeNameStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changeNameStatus != Success, @"change name faild");
        XCTAssert(_err == XAI_ERROR_NULL_POINTER, @"yes . username for change is null");
        
        if (_changeNameStatus == Success) {
            
            NSString* swap = _name4Change;
            _name4Change = _name4Change_end;
            _name4Change_end = swap;
        }
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
}


- (void)test_2_3_ChangeName_LuidOther
{
    
    [self testLoginWithName:_name4Change PWD:_pwd4Change];
    
    if (_loginStatus_normal == Success) {
        
        
        
        [_userService changeUser:0x001 withName:@"ABCCCC"];
        
        
        _changeNameStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changeNameStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_changeNameStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changeNameStatus != Success, @"change name faild");
        XCTAssert(_err == XAI_ERROR_NO_PRIV, @"yes . it cannot change by other");
        
        if (_changeNameStatus == Success) {
            
            NSString* swap = _name4Change;
            _name4Change = _name4Change_end;
            _name4Change_end = swap;
        }
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
}





- (void)test_3_1_ChangePawd_TRUE
{
    
    [self testLoginWithName:_name4Change PWD:_pwd4Change];
    //[self testLogin];
    
    if (_loginStatus_normal == Success) {
        
        
        
        [_userService changeUser:_luiduser oldPassword:_pwd4Change to:_pwd4Change_end ];
        
        
        _changePWDStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changePWDStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_changePWDStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changePWDStatus != Fail, @"change pwd faild");
        XCTAssert(_err == XAI_ERROR_NONE, @"yes, change pwd true");
        
        if (_changePWDStatus == Success) {
            
            NSString* swap = _pwd4Change;
            _pwd4Change = _pwd4Change_end;
            _pwd4Change_end = swap;
        }
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


- (void)test_3_2_ChangePawd_Other
{
    
    [self testLoginWithName:_name4Change PWD:_pwd4Change];
    //[self testLogin];
    
    if (_loginStatus_normal == Success) {
        
        [_userService changeUser:0x1 oldPassword:_pwd4Change to:_pwd4Change_end ];
        
        
        _changePWDStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changePWDStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_changePWDStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changePWDStatus != Success, @"change pwd faild");
        XCTAssert(_err == XAI_ERROR_NO_PRIV, @"yes, it cannot change by other");
        
        if (_changePWDStatus == Success) {
            
            NSString* swap = _pwd4Change;
            _pwd4Change = _pwd4Change_end;
            _pwd4Change_end = swap;
        }
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


- (void)test_3_3_ChangePawd_OldNull
{
    
    [self testLoginWithName:_name4Change PWD:_pwd4Change];
    //[self testLogin];
    
    if (_loginStatus_normal == Success) {
        
        
        
        [_userService changeUser:_luiduser oldPassword:NULL to:_pwd4Change_end ];
        
        
        _changePWDStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changePWDStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_changePWDStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changePWDStatus != Success, @"change pwd faild");
        XCTAssert(_err == XAI_ERROR_NULL_POINTER, @"yes, old pwd for change is null");
        
        if (_changePWDStatus == Success) {
            
            NSString* swap = _pwd4Change;
            _pwd4Change = _pwd4Change_end;
            _pwd4Change_end = swap;
        }
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


- (void)test_3_4_ChangePawd_NewNull
{
    
    [self testLoginWithName:_name4Change PWD:_pwd4Change];
    //[self testLogin];
    
    if (_loginStatus_normal == Success) {
        
        
        
        [_userService changeUser:_luiduser oldPassword:_pwd4Change to:NULL ];
        
        
        _changePWDStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changePWDStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_changePWDStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changePWDStatus != Success, @"change pwd faild");
        XCTAssert(_err == XAI_ERROR_NULL_POINTER, @"yes, new pwd for change is null");
        
        if (_changePWDStatus == Success) {
            
            NSString* swap = _pwd4Change;
            _pwd4Change = _pwd4Change_end;
            _pwd4Change_end = swap;
        }
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
}




- (void)testFind
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService finderUserLuidHelper:_name4Change];
        
        _findStatus = start;
        
        
        runInMainLoop(^(BOOL * done) {
            
            if (_findStatus > 0) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_findStatus != start, @"delegate did not get called");
        XCTAssertTrue (_findStatus != Fail, @"Find faild");
        XCTAssert(_err == XAI_ERROR_NONE, @"yes it can be find");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void)testFindALL
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService finderAllUser];
        
        _findAllStatus = start;
        
        
        runInMainLoop(^(BOOL * done) {
            
            if (_findAllStatus > 0) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_findAllStatus != start, @"delegate did not get called");
        XCTAssertTrue (_findAllStatus != Fail, @"Find faild");
        XCTAssert(_err == XAI_ERROR_NONE, @"YES. it is always true");
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}

- (void)test_4_1_Del_NOPriv
{
    
    [self testLoginWithName:_name4Change PWD:_pwd4Change];
    
    if (_loginStatus_normal == Success) {
        
        
        
        [_userService delUser:0x1];
        
        
        _delStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_delStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Success, @"del user faild");
        XCTAssert(_err == XAI_ERROR_NO_PRIV, @"yes . normal user do not has privacy");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}




- (void)test_4_2_Del_TRUE
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService delUser:_luiduser];
        
        
        _delStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_delStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Fail, @"del user faild");
        XCTAssert(_err == XAI_ERROR_NONE, @"oh , del not suc with err %d",_err);
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}

- (void)test_4_2_Del_NotExist
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_userService delUser:(_luiduser+10)];
        
        
        _delStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_delStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Success, @"del user faild");
        XCTAssert(_err == XAI_ERROR_MODLE_BRIDGE, @"yes . no have the user %d", _err);
        
        //_err == XAI_ERROR_LUID_NONE_EXISTED;
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


-(void)testALL{

    [self test_1_1_Add_TRUE];
    [self test_1_2_Add_NameRep];
    [self test_1_3_Add_NameNull];
    [self test_1_4_Add_PawdNull];
    
    [self testFind];
    [self testFindALL];
    
    
    [self test_2_1_ChangeName_TRUE];
    [self test_2_2_ChangeName_NameNull];
    [self test_2_3_ChangeName_LuidOther];
    
    
    [self test_3_1_ChangePawd_TRUE];
    [self test_3_2_ChangePawd_Other];
    [self test_3_3_ChangePawd_OldNull];
    [self test_3_4_ChangePawd_NewNull];

    
    [self test_4_1_Del_NOPriv];
    [self test_4_2_Del_NotExist];
    [self test_4_2_Del_TRUE];

}


- (void) userService:(XAIUserService*)userService addUser:(BOOL) isSuccess errcode:(XAI_ERROR)errcode{
    
    if (_addStatus != start) return;

    if (isSuccess == TRUE) {
        
        _addStatus = 1;
    }else{
        
        _addStatus = 2;
    }
    
    _err = errcode;

}
- (void) userService:(XAIUserService*)userService delUser:(BOOL) isSuccess errcode:(XAI_ERROR)errcode{
    
    if (_delStatus != start) return;
    
    if (isSuccess == TRUE) {
        
        _delStatus = Success;
    }else{
        
        _delStatus = Fail;
    }
    
    _err = errcode;


}
- (void) userService:(XAIUserService*)userService changeUserName:(BOOL) isSuccess errcode:(XAI_ERROR)errcode{
    
    if (_changeNameStatus != start) return;
    
    if (isSuccess == TRUE) {
        
        _changeNameStatus = Success;
    }else{
        
        _changeNameStatus = Fail;
    }
    
    _err = errcode;


}
- (void) userService:(XAIUserService*)userService changeUserPassword:(BOOL) isSuccess errcode:(XAI_ERROR)errcode{
    
    
     if (_changePWDStatus != start) return;
    
    if (isSuccess == TRUE) {
        
        _changePWDStatus = Success;
    }else{
        
        _changePWDStatus = Fail;
    }

      _err = errcode;
    
}

- (void) userService:(XAIUserService*)userService findedAllUser:(NSSet*)users
              status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

     if (_findAllStatus != start) return;
    
    if (isSuccess == TRUE) {
        
        _findAllStatus = Success;
        
        
        //[[NSUserDefaults standardUserDefaults] setInteger:luid forKey:@"LUID"];
        
    }else{
        
        _findAllStatus = Fail;
    }

      _err = errcode;

}

- (void) userService:(XAIUserService*)userService findedUser:(XAITYPELUID)luid
            withName:(NSString*)name status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
     if (_findStatus != start) return;

    if (isSuccess == TRUE) {
        
        _findStatus = Success;
        
        _luiduser = luid;
        ____luid = luid;
        
        //[[NSUserDefaults standardUserDefaults] setInteger:luid forKey:@"LUID"];
        
    }else{
        
        _findStatus = Fail;
    }
    
      _err = errcode;


}

- (void) getStatus:(XAIDeviceStatus)status withFinish:(BOOL)finish{
    
    if (finish) {
        
        _getStatus = Success;
        
    }else{
        
        _getStatus = Fail;
        
    }
}


@end
