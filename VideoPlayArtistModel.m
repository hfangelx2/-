//
//  VideoPlayArtistModel.m
//  CCMV
//
//  Created by zd on 15/4/22.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "VideoPlayArtistModel.h"

@implementation VideoPlayArtistModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self){
        self.artistId = [dic objectForKey:@"artistId"];
        self.artistAvatar = [dic objectForKey:@"artistAvatar"];
        self.artistName = [dic objectForKey:@"artistName"];
    }
    return self;
}


@end
