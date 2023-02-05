//
//  DYSimpleChatViewController.h
//  rpchat_Example
//
//  Created by pengchao yan on 2023/2/4.
//  Copyright © 2023 鄢彭超. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYSimpleChatViewController : UIViewController

/// 聊天时对方的UserId
@property (nonatomic, strong) NSString *chatUserId;

@end

NS_ASSUME_NONNULL_END
