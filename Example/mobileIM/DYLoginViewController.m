//
//  DYLoginViewController.m
//  rpchat_Example
//
//  Created by 鄢彭超 on 2023/2/2.
//  Copyright © 2023 鄢彭超. All rights reserved.
//

#import "DYLoginViewController.h"
#import "ChatBaseEvent.h"
#import "LKChatClientManager.h"
#import "LKStatesEventHandler.h"
#import "ConfigEntity.h"
#import "ErrorCode.h"
#import "PLoginInfo.h"
#import "LocalDataSender.h"
#import "DYSimpleChatViewController.h"
#import <Toast/Toast.h>

@interface DYLoginViewController () <ChatBaseEvent>

@property (weak, nonatomic) IBOutlet UITextField *serverIPTextField;
@property (weak, nonatomic) IBOutlet UITextField *serverPortTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *passworldTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIdToChatTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

/// 是否登录成功
@property (nonatomic, assign) BOOL loginSuccessed;

@end

@implementation DYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[LKChatClientManager shareInstance].statesEventHandler registerReciever:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[LKChatClientManager shareInstance].statesEventHandler unregisterReciever:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)login:(id)sender {
    if ([self checkParams]) {
        NSString *loginUserIdStr = self.userIdTextField.text;
        NSString *loginTokenStr = self.passworldTextField.text;
        [self loginWithUserId:loginUserIdStr andPassworld:loginTokenStr];
    }
}

- (IBAction)gotoChat:(id)sender {
    DYSimpleChatViewController *chatViewController = [[DYSimpleChatViewController alloc] init];
    if (_userIdToChatTextField.text.length > 0) {
        chatViewController.chatUserId = _userIdToChatTextField.text;
    } else {
        chatViewController.chatUserId = _userIdTextField.text;
    }
    
    chatViewController.title = chatViewController.chatUserId;
    [self.navigationController pushViewController:chatViewController animated:YES];
}


#pragma mark - ChatBaseEvent functions

- (void)onKickout:(PKickoutInfo *)kickoutInfo {
    //
}

- (void)onLinkClose:(int)errorCode {
    //
}

- (void)onLoginResponse:(int)errorCode {
    if (errorCode == 0) {
        [self.view makeToast:@"登录成功"];
    } else {
        NSString *msg = [NSString stringWithFormat:@"登录失败，错误码：%d", errorCode];
        [self.view makeToast:msg];
    }
    
    if ([[LKChatClientManager shareInstance] isLoginSuccessed]) {
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    } else {
        [self.loginButton setTitle:@"登出" forState:UIControlStateNormal];
    }
}

#pragma mark - private functions

- (BOOL)checkParams {
    // 设置服务器地址和端口号
    NSString *serverIP = [self.serverIPTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *serverPort = self.serverPortTextField.text;
    if (serverIP.length > 0 && serverPort.length > 0) {
        // 设置好服务端的连接地址
        [ConfigEntity setServerIp:serverIP];
        
        // 设置好服务端的UDP监听端口号
        [ConfigEntity setServerPort:[serverPort intValue]];
    } else {
        [self.view makeToast:@"请确保服务端地址和端口号都不为空！"];
        return NO;
    }
    
    // 登陆名和密码
    NSString *loginUserIdStr = self.userIdTextField.text;
    if (loginUserIdStr.length <= 0) {
        [self.view makeToast:@"请输入登录名！"];
        return NO;
    }
    
    NSString *loginTokenStr = self.passworldTextField.text;
    if (loginTokenStr.length <= 0) {
      [self.view makeToast:@"请输入登密码！"];
      return NO;
    }
    
    return YES;
}

- (void)loginWithUserId:(NSString *)loginUserIdStr andPassworld:(NSString *)loginTokenStr {
    // 将要提交的登陆信息对象
    PLoginInfo *loginInfo = [[PLoginInfo alloc] init];
    loginInfo.loginUserId = loginUserIdStr;
    loginInfo.loginToken = loginTokenStr;
    
    // 发送登陆数据包(提交登陆名和密码)
    int code = [[LocalDataSender sharedInstance] sendLogin:loginInfo];
    if (code == COMMON_CODE_OK) {
        [self.view makeToast:@"登录请求已发出。。。"];
    } else {
        NSString *msg = [NSString stringWithFormat:@"登录请求发送失败，错误码：%d", code];
        [self.view makeToast:msg];
    }
}

@end
