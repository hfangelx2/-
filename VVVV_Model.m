//
//  VVVV_Model.m
//  CCMV
//
//  Created by zd on 15/4/20.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "VVVV_Model.h"

@implementation VVVV_Model


- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self){
        self.albumId = [dic objectForKey:@"id"];
        self.title = [dic objectForKey:@"title"];
        self.descriptiontt = [dic objectForKey:@"description"];
        self.artists = [dic objectForKey:@"artists"];
        self.artistName = [dic objectForKey:@"artistName"];
        self.posterPic = [dic objectForKey:@"posterPic"];
        self.thumbnailPic = [dic objectForKey:@"thumbnailPic"];
        self.albumImg = [dic objectForKey:@"albumImg"];
        self.totalViews = [dic objectForKey:@"totalViews"];
        self.url = [dic objectForKey:@"url"];
        self.hdUrl = [dic objectForKey:@"hdUrl"];
        self.uhdUrl = [dic objectForKey:@"uhdUrl"];
        self.shdUrl = [dic objectForKey:@"shdUrl"];
        self.videoSize = [dic objectForKey:@"videoSize"];
        self.hdVideoSize = [dic objectForKey:@"hdVideoSize"];
        self.uhdVideoSize = [dic objectForKey:@"uhdVideoSize"];
        self.shdVideoSize = [dic objectForKey:@"shdVideoSize"];
        self.duration = [dic objectForKey:@"duration"];
        self.status = [dic objectForKey:@"status"];
        self.score = [dic objectForKey:@"score"];
        self.up =[dic objectForKey:@"up"];
        self.trendScore = [dic objectForKey:@"trendScore"];
        self.playListPic = [dic objectForKey:@"playListPic"];
        
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
