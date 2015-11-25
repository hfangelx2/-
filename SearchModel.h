//
//  SearchModel.h
//  CCMV
//
//  Created by zd on 15/4/23.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject


@property(nonatomic,strong)NSNumber *albumId; // 编号
@property(nonatomic,strong)NSString *title;//标题
@property (nonatomic, strong)NSString *descriptiontt; // 描述

@property(nonatomic,strong)NSArray *artists;

@property(nonatomic,strong)NSString *artistName; // 艺术家名字
@property(nonatomic,strong)NSString *posterPic;//海报图片(缩略图)
@property(nonatomic,strong)NSString *thumbnailPic;//海报图片(缩略图)

@property(nonatomic,strong)NSString *albumImg; //  海报图片(大图)
@property(nonatomic,strong)NSNumber *totalViews; // 全部的视图

@property(nonatomic,strong)NSString *url;  // 网址
@property(nonatomic,strong)NSString *hdUrl; // hd类型的视频网址;

@property(nonatomic,strong)NSNumber *videoSize;//视频边框大小
@property(nonatomic,strong)NSNumber *hdVideoSize;//hd视频边框大小
@property(nonatomic,strong)NSNumber *uhdVideoSize;//uhd视频边框大小
@property(nonatomic,strong)NSNumber *shdVideoSize; // shd视频边框大小
@property(nonatomic,strong)NSNumber *duration;
@property(nonatomic,strong)NSNumber *status;

@property(nonatomic,strong)NSString *playListPic; // 播放列表的图片




@end
