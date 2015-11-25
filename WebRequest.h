//
//  WebRequest.h
//  Looking
//
//  Created by lanou3g on 15/4/11.
//  Copyright (c) 2015年 li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "Connect.h"


@interface WebRequest : NSObject

+ (void)connectWithUrl:(NSString *)urlStr
              parmater:(NSMutableDictionary *)parmater
         requestHeader:(NSDictionary *)header
            httpMethod:(NSString *)httpMethod
                  view:(UIView *)view
                 block:(void(^)(id data))block
               refresh:(void(^)())refresh;



@end
