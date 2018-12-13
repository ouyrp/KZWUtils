//
//  NSError+KZWErrorMessage.m
//  KZWCrowdsource
//
//  Created by 沈强 on 16/3/7.
//  Copyright © 2016年 elm. All rights reserved.
//

#import "NSError+KZWErrorMessage.h"

@implementation NSError (KZWErrorMessage)
- (NSString *)message {
  NSDictionary *userInfo = self.userInfo;
  return userInfo[KZWBNetworkUserMessage] ? userInfo[KZWBNetworkUserMessage] : @"服务异常";
}

- (NSString *)businessMessage {
  if (self.code == KZWBNeteworkBusinessError) {
    NSDictionary *userInfo = self.userInfo;
    return userInfo[KZWBNetworkUserMessage];
  }
  return nil;
}

- (NSString *)businessMessage:(NSString *)defaultMessage {
  if (self.code == KZWBNeteworkBusinessError) {
    NSDictionary *userInfo = self.userInfo;
    return userInfo[KZWBNetworkUserMessage];
  }
  return defaultMessage;
}

- (NSString *)businessErrorCode {
  if (self.code == KZWBNeteworkBusinessError) {
    NSDictionary *userInfo = self.userInfo;
    return userInfo[KZWBNetworkBusinessErrorCode];
  }
  return nil;
}

@end
