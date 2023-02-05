//
//  DYSimpleChatViewController.m
//  rpchat_Example
//
//  Created by pengchao yan on 2023/2/4.
//  Copyright © 2023 鄢彭超. All rights reserved.
//

#import "DYSimpleChatViewController.h"
#import "ChatMessageEvent.h"
#import "LKChatMessageHandler.h"
#import "LKChatClientManager.h"
#import "LocalDataSender.h"
#import <Toast/Toast.h>

#define ChatMessageTableViewCellId  @"chatMessageTableViewId"

@interface DYSimpleChatViewController () <UITableViewDelegate, UITableViewDataSource, ChatMessageEvent>

@property (weak, nonatomic) IBOutlet UITableView *chatMessageTableView;
@property (weak, nonatomic) IBOutlet UITextField *msgTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic, strong) NSArray *chatMessageArray;

@end

@implementation DYSimpleChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_chatMessageTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ChatMessageTableViewCellId];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[LKChatClientManager shareInstance].chatMessageHandler registerReciever:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[LKChatClientManager shareInstance].chatMessageHandler unregisterReciever:self];
}

#pragma mark - action functions

- (IBAction)sendMessage:(id)sender {
    if (_msgTextField.text.length > 0) {
        [self sendMsg:_msgTextField.text];
        [self refreshTableViewForMsg];
        _msgTextField.text = @"";
    }
}

#pragma mark - tableView functions

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [_chatMessageTableView dequeueReusableCellWithIdentifier:ChatMessageTableViewCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatMessageTableViewCellId];
    }
    
    cell.textLabel.text = _chatMessageArray[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_chatMessageArray count];
}

#pragma mark - ChatMessageEvent functions

- (void)onErrorResponse:(int)errorCode withErrorMsg:(NSString *)errorMsg {
    NSString *msg = [NSString stringWithFormat:@"通讯错误：%@", errorMsg];
    [self.view makeToast:msg];
}

- (void)onRecieveMessage:(NSString *)fingerPrintOfProtocal withUserId:(NSString *)userid andContent:(NSString *)dataContent andTypeu:(int)typeu {
    if (dataContent.length > 0) {
        [self saveMsg:dataContent direction:NO with:userid];
        [self refreshTableViewForMsg];
    }
}

#pragma mark - private functions

- (BOOL)sendMsg:(NSString *)msg {
    // 发送消息
    int code = [[LocalDataSender sharedInstance] sendCommonDataWithStr:msg toUserId:_chatUserId qos:YES fp:nil withTypeu:-1];
    if (code == COMMON_CODE_OK) {
        [self saveMsg:msg direction:YES with:_chatUserId];
        return YES;
    } else {
        msg = [NSString stringWithFormat:@"您的消息\"%@\"发送失败，错误码：%d", msg, code];
        [self.view makeToast:msg];
        return NO;
    }
}

- (void)saveMsg:(NSString *)msg direction:(BOOL)sendDirection with:(NSString *)userId {
    NSString *withUserId = userId;
    if (withUserId.length <= 0) {
        withUserId = _chatUserId;
    }
    
    if (sendDirection) {
        msg = [NSString stringWithFormat:@"你对%@说：%@", withUserId, msg];
    } else {
        msg = [NSString stringWithFormat:@"%@对你说：%@", withUserId, msg];
    }
    
    @synchronized (_chatMessageArray) {
        NSMutableArray *mArray = [[NSMutableArray alloc] initWithArray:_chatMessageArray];
        [mArray insertObject:msg atIndex:0];
        _chatMessageArray = mArray;
    }
}

- (void)refreshTableViewForMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chatMessageTableView reloadData];
        [self.chatMessageTableView scrollsToTop];
    });
}

@end
