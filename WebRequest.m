//
//  WebRequest.m
//  Looking
//
//  Created by lanou3g on 15/4/11.
//  Copyright (c) 2015年 li. All rights reserved.
//

#import "WebRequest.h"
#import "TFIndicatorView.h"


@interface WebRequest ()

@property(nonatomic, strong)TFIndicatorView *shuaxin;
@property(nonatomic, strong)UIAlertView *noNet;

@property(nonatomic, strong)AFNetworkReachabilityManager *manager;
/// 返回数据的block
@property (nonatomic, strong) void(^block)(id data);
/// 失败的block
@property(nonatomic, strong) void(^refreshAgain)();
/// 是否成功
@property(nonatomic, assign)BOOL flag;

@end

@implementation WebRequest

- (TFIndicatorView *)shuaxin
{
    if (!_shuaxin) {
        _shuaxin = [[TFIndicatorView alloc]initWithFrame:CGRectMake(135, 180, 50, 50)];
        [_shuaxin startAnimating];
        
    }
    return _shuaxin;
}

- (UIAlertView *)noNet
{
    if (!_noNet) {
        _noNet = [[UIAlertView alloc]initWithTitle:@"网络异常,请检查您的" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        [self performSelector:@selector(dismissAlert:) withObject:_noNet afterDelay:2];
    }
    return _noNet;
}

-(void)dismissAlert:(UIAlertView *)alert{
    
    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [AFNetworkReachabilityManager sharedManager];
    }
    return self;
}

+ (void)connectWithUrl:(NSString *)urlStr parmater:(NSMutableDictionary *)parmater requestHeader:(NSDictionary *)header
            httpMethod:(NSString *)httpMethod  view:(UIView *)view block:(void(^)(id data))block refresh:(void(^)())refresh
{
    WebRequest *request = [[WebRequest alloc] init];
    
    request.shuaxin.center = CGPointMake(view.center.x, view.center.y - 180);
    
    [view addSubview:request.shuaxin];
    
    request.block = block;
    request.refreshAgain = refresh;
    
//    [request connectWithUrl:urlStr parmater:parmater view:view];
    
    [request ConnectRequestAFWithURL:urlStr params:parmater requestHeader:header httpMethod:httpMethod view:view];
    
}

- (void)ConnectRequestAFWithURL:(NSString *)url
                                             params:(NSMutableDictionary *)params
                                      requestHeader:(NSDictionary *)header
                                         httpMethod:(NSString *)httpMethod view:(UIView *)view
                                              {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    //添加请求头
    for (NSString *key in header.allKeys) {
        [request addValue:header[key] forHTTPHeaderField:key];
        
    }
    //get请求
    NSComparisonResult compResult1 =[httpMethod caseInsensitiveCompare:@"GET"];
    if (compResult1 == NSOrderedSame) {
        [request setHTTPMethod:@"GET"];
        
        //添加参数，将参数拼接在url后面
        NSMutableString *paramsString = [NSMutableString string];
        NSArray *allkeys = [params allKeys];
        for (NSString *key in allkeys) {
            NSString *value = [params objectForKey:key];
            
            [paramsString appendFormat:@"&%@=%@", key, value];
        }
        
        if (paramsString.length > 0) {
            //重新设置url
            [request setURL:[NSURL URLWithString:[url stringByAppendingString:paramsString]]];
        }
    }
    
//    //post请求
//    NSComparisonResult compResult2 =[httpMethod caseInsensitiveCompare:@"POST"];
//    if (compResult2 == NSOrderedSame) {
//        [request setHTTPMethod:@"POST"];
//        
//        //添加参数
//        for (NSString *key in params) {
//            id value = params[key];
//            //如果参数无key，直接设置HTTPBody
//            if ([value isKindOfClass:[NSData class]]) {
//                [request setHTTPBody:value];
//            }else{
//                [request setValue:value forKey:key];
//            }
//        }
//    }
    
    if (self.manager.isReachableViaWWAN) {
        [self.noNet setTitle:@"流量访问"];
        [self.noNet show];
        [self performSelector:@selector(dismissAlert:) withObject:_noNet afterDelay:2];
        
        
        
    }else if(self.manager.isReachableViaWiFi){
        [self.noNet setTitle:@"wifi访问"];
        [self.noNet show];
        [self performSelector:@selector(dismissAlert:) withObject:_noNet afterDelay:2];
    }
    
    //发送请求
    AFHTTPRequestOperation *requstOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                                                  
    //设置返回数据的解析方式
    requstOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [requstOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.block(responseObject);
        [self.shuaxin stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (self.manager.reachable == NO) {
                NSLog(@"网络不可用");
                [self.shuaxin stopAnimating];
                [self.noNet setTitle:@"网络异常,请检查您的网络啊亲"];
                [self.noNet show];
                [self performSelector:@selector(dismissAlert:) withObject:_noNet afterDelay:2];
                
            }
            else
            {
                NSLog(@"数据异常");
                [self.shuaxin stopAnimating];
                [self.noNet setTitle:@"数据异常"];
                [self.noNet show];
                [self performSelector:@selector(dismissAlert:) withObject:_noNet afterDelay:2];
            }
            
            self.refreshAgain();
        
    }];
    [requstOperation start];
}








@end
