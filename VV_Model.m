//
//  VV_Model.m
//  CCMV
//
//  Created by zd on 15/4/20.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "VV_Model.h"

@implementation VV_Model

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self){
        
        self.videos = [NSMutableArray array];
        self.no = [dic objectForKey:@"no"];
        self.endDataText = [dic objectForKey:@"endDataText"];
        self.beginDataText = [dic objectForKey:@"beginDataText"];
        
        
        NSArray *array = [dic objectForKey:@"videos"];
        
        for (NSDictionary *dict in array) {
            VVVV_Model *model = [[VVVV_Model alloc] initWithDictionary:dict];
            [self.videos addObject:model];
        }
    }
    return self;
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}







@end
