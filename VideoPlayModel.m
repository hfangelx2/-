//
//  VideoPlayModel.m
//  CCMV
//
//  Created by zd on 15/4/22.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "VideoPlayModel.h"

@implementation VideoPlayModel


- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self){
        self.albumId = [dic objectForKey:@"id"]; // 编号
        self.title = [dic objectForKey:@"title"];//标题
        self.descriptiontt = [dic objectForKey:@"description"]; // 描述
        self.artistName = [dic objectForKey:@"artistName"]; // 艺术家名字
        self.posterPic = [dic objectForKey:@"posterPic"];//海报图片(缩略图)
        self.thumbnailPic = [dic objectForKey:@"thumbnailPic"];//海报图片(缩略图)
        
        self.albumImg = [dic objectForKey:@"albumImg"]; //  海报图片(大图)
        self.regdate = [dic objectForKey:@"regdate"]; // 发布时间
        self.totalViews = [dic objectForKey:@"totalViews"]; // 播放次数
        
        self.url = [dic objectForKey:@"url"];  // 网址
        self.hdUrl = [dic objectForKey:@"hdUrl"]; // hd类型的视频网址;
        self.uhdUrl = [dic objectForKey:@"uhdUrl"]; // uhd类型网址
        self.shdUrl = [dic objectForKey:@"shdUrl"];
        self.videoSize = [dic objectForKey:@"videoSize"];//视频边框大小
        self.hdVideoSize = [dic objectForKey:@"hdVideoSize"];//hd视频边框大小
        self.uhdVideoSize = [dic objectForKey:@"uhdVideoSize"];//uhd视频边框大小
        self.shdVideoSize = [dic objectForKey:@"shdVideoSize"]; // shd视频边框大小
        self.duration = [dic objectForKey:@"duration"];
        self.status = [dic objectForKey:@"status"];
        
        self.playListPic = [dic objectForKey:@"playListPic"]; // 播放列表的图片
        self.totalPcViews = [dic objectForKey:@"totalPcViews"];
        self.totalMobileViews = [dic objectForKey:@"totalMobileViews"];
        self.totalComments = [dic objectForKey:@"totalComments"];	
        self.favorite = [dic objectForKey:@"favorite"];
        
        
        self.artists = [NSMutableArray array];// 装艺术家信息model的数组
        self.relatedVideos = [NSMutableArray array];//装相关视频的model的数组
        
        NSArray *array1 = [dic objectForKey:@"artists"];
        NSDictionary *littleDic1 = [array1 firstObject];
        VideoPlayArtistModel *artistModel = [[VideoPlayArtistModel alloc]initWithDictionary:littleDic1];
        [self.artists addObject:artistModel];
        
        
        NSArray *array2 = [dic objectForKey:@"relatedVideos"];
        for (NSDictionary *littleDic2 in array2) {
            VideoPlayTableViewModel *tableViewModel =[[VideoPlayTableViewModel alloc]initWithDictionary:littleDic2];
            [self.relatedVideos addObject:tableViewModel];
        }
        
    }
    return self;
}










@end
