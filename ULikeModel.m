//
//  ULikeModel.m
//  CCMV
//
//  Created by zd on 15/4/16.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "ULikeModel.h"

@implementation ULikeModel

- (instancetype)init
{
    self = [super init];
    if(self){
    }
    return self;
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqual:@"description"]){
        self.descriptiontt = value;
    }
    if([key isEqual:@"id"]){
        self.albumId = value;
    }
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}






@end
