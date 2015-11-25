//
//  VideoPlayModel.h
//  CCMV
//
//  Created by zd on 15/4/22.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoPlayArtistModel.h"
#import "VideoPlayTableViewModel.h"

@interface VideoPlayModel : NSObject


@property(nonatomic,strong)NSNumber *albumId; // 编号
@property(nonatomic,strong)NSString *title;//标题
@property (nonatomic, strong)NSString *descriptiontt; // 描述

@property(nonatomic,strong)NSMutableArray *artists;// 艺术家model

@property(nonatomic,strong)NSString *artistName; // 艺术家名字
@property(nonatomic,strong)NSString *posterPic;//海报图片(缩略图)
@property(nonatomic,strong)NSString *thumbnailPic;//海报图片(缩略图)

@property(nonatomic,strong)NSString *albumImg; //  海报图片(大图)
@property(nonatomic,strong)NSString *regdate; // 发布时间

@property(nonatomic,strong)NSNumber *totalViews; // 播放次数

@property(nonatomic,strong)NSString *url;  // 网址
@property(nonatomic,strong)NSString *hdUrl; // hd类型的视频网址;
@property(nonatomic,strong)NSString *uhdUrl; // uhd类型网址
@property(nonatomic,strong)NSString *shdUrl;

@property(nonatomic,strong)NSNumber *videoSize;//视频边框大小
@property(nonatomic,strong)NSNumber *hdVideoSize;//hd视频边框大小
@property(nonatomic,strong)NSNumber *uhdVideoSize;//uhd视频边框大小
@property(nonatomic,strong)NSNumber *shdVideoSize; // shd视频边框大小
@property(nonatomic,strong)NSNumber *duration;
@property(nonatomic,strong)NSNumber *status;

@property(nonatomic,strong)NSString *playListPic; // 播放列表的图片

@property(nonatomic,strong)NSMutableArray *relatedVideos;
@property(nonatomic,strong)NSNumber *totalPcViews;
@property(nonatomic,strong)NSNumber *totalMobileViews;
@property(nonatomic,strong)NSNumber *totalComments;
@property(nonatomic,assign)BOOL favorite;


- (instancetype)initWithDictionary:(NSDictionary *)dic;


@end
