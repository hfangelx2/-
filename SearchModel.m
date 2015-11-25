//
//  SearchModel.m
//  CCMV
//
//  Created by zd on 15/4/23.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel


- (instancetype)init
{
    self = [super init];
    if(self){
        self.artists = [NSArray array];
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
