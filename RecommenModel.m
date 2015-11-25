//
//  RecommenModel.m
//  CCMV
//
//  Created by zd on 15/4/15.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "RecommenModel.h"

@implementation RecommenModel

- (id)initWithId:(NSNumber *)albumId
{
    self = [super init];
    if(self){
        self.albumId = albumId;
    }
    return self;
}

+ (id)recommenModelWithId:(NSNumber *)albumId
{
    RecommenModel *recommenModel = [[RecommenModel alloc]initWithId:albumId];
    return recommenModel;
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
