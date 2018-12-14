//
//  NSError+KZWErrorMessage.h
//  KZWCrowdsource
//
//  Created by 沈强 on 16/3/7.
//  Copyright © 2016年 elm. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *KZWNetworkErrorDomain = @"KZWNetworkErrorDomain";

static NSString *KZWNetworkUserMessage = @"userErrorMessage";

static NSString *KZWNetworkBusinessErrorCode = @"businessErrorCode";

typedef NS_ENUM(NSUInteger, KZWNeteworkErrorCode) {
    KZWNeteworkResponseDataError = 1000,
    KZWNeteworkBusinessError = 10001,
    KZWNeteworkError = 10002
};

@interface NSError (KZWErrorMessage)

/**
 *  用户错误提示信息
 *
 *
 */
- (NSString *)message;

/**
 *  用户业务逻辑错误信息
 *
 *
 */
- (NSString *)businessMessage;

/**
 *  用户业务逻辑错误信息
 *
 *  @param defaultMessage 当用户业务逻辑错误信息 是空的时候，返回默认值
 *
 *
 */
- (NSString *)businessMessage:(NSString *)defaultMessage;


/**
 *  用户业务逻辑错误code
 *
 *
 */
- (NSString *)businessErrorCode;

@end
