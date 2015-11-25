//
//  VV_Model.h
//  CCMV
//
//  Created by zd on 15/4/20.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVVV_Model.h"


@interface VV_Model : NSObject

@property(nonatomic,strong)NSString *no; // 期数
@property(nonatomic,strong)NSString *beginDataText; // 本期榜开始日期
@property(nonatomic,strong)NSString *endDataText; // 本期榜结束日期;
@property(nonatomic,strong)NSMutableArray *videos; 


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
