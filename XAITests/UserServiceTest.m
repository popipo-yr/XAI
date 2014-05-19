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
    
    
    _name4Change = @"admin";
    _pwd4Change = @"admin";
    _pwd4Change_end = @"adminn";
    _name4Change_end = @"adminn";
    
    
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
        
        
        
        [_userService addUser:name Password:pawd];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > 0) {
                
                *done = YES;
            }
        });
    }

}

- (XAITYPELUID)_findLuid:(NSString*)name
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        [_userService finderUserLuidHelper:name];
        
        _findStatus = start;
        
        
        runInMainLoop(^(BOOL * done) {
            
            if (_findStatus > 0) {
                
                *done = YES;
            }
        });
        
    }
    
    return _luiduser;
    
}

- (void)_change:(XAITYPELUID)luid Name:(NSString*)name pawd:(NSString*)pawd toName:(NSString*)toname{
    
    [self loginWithName:name PWD:pawd];
    
    if (_loginStatus_normal == Success) {
    
        
        [_userService changeUser:luid withName:toname];
        
        
        _changeNameStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changeNameStatus > start) {
                
                *done = YES;
            }
        });
        
    }
    
    
}


- (void)_change:(XAITYPELUID)luid Name:(NSString*)name pawd:(NSString*)pawd toPWD:(NSString*)toPwd{
    

    [self _change:luid Name:name pawd:pawd toPWD:toPwd newPut:pawd];
}

- (void)_change:(XAITYPELUID)luid Name:(NSString*)name pawd:(NSString*)pawd toPWD:(NSString*)toPwd newPut:(NSString*)newPut{
    
    [self loginWithName:name PWD:pawd];
    //[self testLogin];
    
    if (_loginStatus_normal == Success) {
        
        
        
        [_userService changeUser:luid  oldPassword:newPut to:toPwd];
        
        
        _changePWDStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changePWDStatus > start) {
                
                *done = YES;
            }
        });
        
        
    }
    
}



- (void)_del:(XAITYPELUID)luid
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        [_userService delUser:luid];
        
        
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
        XCTAssertTrue (_addStatus != Fail, @"no, add user should be suc");
        XCTAssert(_err == XAI_ERROR_NONE, @"-err : %d",_err);
        
    }else{
    
    
        XCTFail(@"LOGIN FAILD");
    }
    
    
    [self _del:[self _findLuid:_name4Change]];

}


- (void)test_1_2_Add_NameRep
{
    
    [self _addName:_name4Change pawd:_pwd4Change];
    
    if (_loginStatus != Success && _addStatus != Success) {
        
        XCTFail(@"Add_NameRep generate data fail");
        return;
    }
    
    [self _addName:_name4Change pawd:_pwd4Change];
    
    if (_loginStatus == Success) {
        
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"no, add user should be fail , name is rep");
        XCTAssert(_err == XAI_ERROR_NAME_EXISTED, @"-err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
    [self _del:[self _findLuid:_name4Change]];
    
}




- (void)test_1_3_Add_NameNull
{
    
    [self _addName:NULL pawd:_pwd4Change];
    
    if (_loginStatus == Success) {
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"NO, add user should be fail, name is null");
        XCTAssert(_err == XAI_ERROR_NAME_INVALID, @"-err : %d",_err);
        
    }else{
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
    [self _del:[self _findLuid:_name4Change]];

    
 }


- (void)test_1_4_Add_PawdNull
{
    
    [self _addName:NULL pawd:_pwd4Change];
    
    if (_loginStatus == Success) {
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"NO, add user should be fail, pawd is null");
        XCTAssert(_err == XAI_ERROR_NAME_INVALID, @"-err : %d",_err);
        
    }else{
        
        XCTFail(@"LOGIN FAILD");
    }
    
}



- (void)test_2_1_ChangeName_TRUE
{
    [self _addName:_name4Change pawd:_pwd4Change];
    
    if (_loginStatus != Success && _addStatus != Success) {
        
        XCTFail(@"ChangeName_TRUE generate data fail");
        return;
    }

    
    [self _change:[self _findLuid:_name4Change] Name:_name4Change pawd:_pwd4Change toName:_name4Change_end];
    
    if (_loginStatus_normal == Success) {
        
        
        XCTAssertTrue (_changeNameStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changeNameStatus != Fail, @"no, change name should be suc");
        XCTAssert(_err == XAI_ERROR_NONE, @"-err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    [self _del:_luiduser];
    
}


- (void)test_2_2_ChangeName_NameNull
{
    
    [self _addName:_name4Change pawd:_pwd4Change];
    
    if (_loginStatus != Success && _addStatus != Success) {
        
        XCTFail(@"ChangeName_NameNull generate data fail");
        return;
    }
    
    
    [self _change:[self _findLuid:_name4Change] Name:_name4Change pawd:_pwd4Change toName:NULL];
    
    if (_loginStatus_normal == Success) {
        
        
        XCTAssertTrue (_changeNameStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changeNameStatus != Success, @"no, change name should be fail, name is null");
        XCTAssert(_err == XAI_ERROR_NAME_INVALID, @"-err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    [self _del:_luiduser];
    
}


- (void)test_2_3_ChangeName_LuidOther
{
    
    [self _addName:_name4Change pawd:_pwd4Change];
    
    if (_loginStatus != Success && _addStatus != Success) {
        
        XCTFail(@"ChangeName_LuidOther generate data fail");
        return;
    }
    
    
    [self _change:0x1 Name:_name4Change pawd:_pwd4Change toName:_name4Change_end];
    
    if (_loginStatus_normal == Success) {
        
        
        XCTAssertTrue (_changeNameStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changeNameStatus != Success, @"no, change other name should be fail");
        XCTAssert(_err == XAI_ERROR_NO_PRIV, @"-err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    [self _del:[self _findLuid:_name4Change]];
    
    
}





- (void)test_3_1_ChangePawd_TRUE
{
    
    [self _addName:_name4Change pawd:_pwd4Change];
    
    if (_loginStatus != Success && _addStatus != Success) {
        
        XCTFail(@"test_3_1_ChangePawd_TRUE generate data fail");
        return;
    }
    
    
    [self _change:[self _findLuid:_name4Change] Name:_name4Change pawd:_pwd4Change toPWD:_pwd4Change_end];
    
    if (_loginStatus_normal == Success) {
        
        
        XCTAssertTrue (_changePWDStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changePWDStatus != Fail, @"no, change pwad should be suc");
        XCTAssert(_err == XAI_ERROR_NONE, @"-err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    [self _del:_luiduser];

    
    
}


- (void)test_3_2_ChangePawd_Other
{
    
    [self _addName:_name4Change pawd:_pwd4Change];
    
    if (_loginStatus != Success && _addStatus != Success) {
        
        XCTFail(@"test_3_2_ChangePawd_Other generate data fail");
        return;
    }
    
    
    [self _change:0x1 Name:_name4Change pawd:_pwd4Change toPWD:_pwd4Change_end];
    
    if (_loginStatus_normal == Success) {
        
        
        XCTAssertTrue (_changePWDStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changePWDStatus != Success, @"no, change other pwad should be fail");
        XCTAssert(_err == XAI_ERROR_NO_PRIV, @"-err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    [self _del:[self _findLuid:_name4Change]];
    
    
}


- (void)test_3_3_ChangePawd_OldNull
{
    
    [self _addName:_name4Change pawd:_pwd4Change];
    
    if (_loginStatus != Success && _addStatus != Success) {
        
        XCTFail(@"test_3_3_ChangePawd_OldNull generate data fail");
        return;
    }
    
    
    [self _change:[self _findLuid:_name4Change] Name:_name4Change pawd:_pwd4Change toPWD:_pwd4Change_end newPut:NULL];
    
    if (_loginStatus_normal == Success) {
        
        
        XCTAssertTrue (_changePWDStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changePWDStatus != Success, @"no, change  pwad should be fail,old is null");
        XCTAssert(_err == XAI_ERROR_NULL_POINTER, @"-err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    [self _del:_luiduser];


}


- (void)test_3_4_ChangePawd_NewNull
{
    [self _addName:_name4Change pawd:_pwd4Change];
    
    if (_loginStatus != Success && _addStatus != Success) {
        
        XCTFail(@"test_3_4_ChangePawd_NewNull generate data fail");
        return;
    }
    
    
    [self _change:[self _findLuid:_name4Change] Name:_name4Change pawd:_pwd4Change toPWD:NULL];
    
    if (_loginStatus_normal == Success) {
        
        
        XCTAssertTrue (_changePWDStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changePWDStatus != Success, @"no, change  pwad should be fail,NEW is null");
        XCTAssert(_err == XAI_ERROR_NULL_POINTER, @"-err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    [self _del:_luiduser];}




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
    
    
    [self _del:0x1];
    
    if (_loginStatus == Success) {
        
        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Success, @"del user should faild,no privacy");
        XCTAssert(_err == XAI_ERROR_NO_PRIV, @"-err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}




- (void)test_4_2_Del_TRUE
{
    
    [self _addName:_name4Change pawd:_pwd4Change];
    
    if (_loginStatus != Success && _addStatus != Success) {
        
        XCTFail(@"test_4_2_Del_TRUE generate data fail");
        return;
    }
    
    [self _del:[self _findLuid:_name4Change]];
    
    if (_loginStatus == Success) {
        
        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Fail, @"del user should syc");
        XCTAssert(_err == XAI_ERROR_NONE, @"-err %d",_err);
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}

- (void)test_4_2_Del_NotExist
{
    
    [self _addName:_name4Change pawd:_pwd4Change];
    
    if (_loginStatus != Success && _addStatus != Success) {
        
        XCTFail(@"test_4_2_Del_TRUE generate data fail");
        return;
    }
    
    [self _del:[self _findLuid:_name4Change]];
    [self _del:[self _findLuid:_name4Change]];

    
    if (_loginStatus == Success) {
        

        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Success, @"del user should faild, already be del");
        XCTAssert(_err == XAI_ERROR_LUID_NONE_EXISTED, @"-err : %d", _err);
        
        //_err == XAI_ERROR_LUID_NONE_EXISTED;
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


-(void)_testALL{

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
