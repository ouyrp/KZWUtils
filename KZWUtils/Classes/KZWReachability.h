//
//  KZWReachability.h
//  BKJFUtils
//
//  Created by yang ou on 2019/4/17.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) \
    enum _name : _type _name; \
    enum _name : _type
#endif

extern NSString *const kReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, NetworkStatus) {
    // Apple NetworkStatus Compatible Names.
    NotReachable = 0,
    ReachableViaWiFi = 2,
    ReachableViaWWAN = 1
};

@class KZWReachability;

typedef void (^NetworkReachable)(KZWReachability *reachability);
typedef void (^NetworkUnreachable)(KZWReachability *reachability);

@interface KZWReachability : NSObject

@property (nonatomic, copy) NetworkReachable reachableBlock;
@property (nonatomic, copy) NetworkUnreachable unreachableBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;


+ (KZWReachability *)reachabilityWithHostname:(NSString *)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+ (KZWReachability *)reachabilityWithHostName:(NSString *)hostname;
+ (KZWReachability *)reachabilityForInternetConnection;
+ (KZWReachability *)reachabilityWithAddress:(void *)hostAddress;
+ (KZWReachability *)reachabilityForLocalWiFi;

- (KZWReachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

- (BOOL)startNotifier;
- (void)stopNotifier;

- (BOOL)isReachable;
- (BOOL)isReachableViaWWAN;
- (BOOL)isReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
- (BOOL)isConnectionRequired; // Identical DDG variant.
- (BOOL)connectionRequired; // Apple's routine.
// Dynamic, on demand connection?
- (BOOL)isConnectionOnDemand;
// Is user intervention required?
- (BOOL)isInterventionRequired;

- (NetworkStatus)currentReachabilityStatus;
- (SCNetworkReachabilityFlags)reachabilityFlags;
- (NSString *)currentReachabilityString;
- (NSString *)currentReachabilityFlags;

@end

NS_ASSUME_NONNULL_END
