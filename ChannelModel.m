//
//  ChannelModel.m
//  CCMV
//
//  Created by zd on 15/4/18.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "ChannelModel.h"

@implementation ChannelModel

- (instancetype)init
{
    self = [super init];
    if(self){

    }
    return self;
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqual:@"id"]){
        self.albumId = value;
    }
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}


@end
