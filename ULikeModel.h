//
//  ULikeModel.h
//  CCMV
//
//  Created by zd on 15/4/16.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULikeModel : NSObject

@property(nonatomic,strong)NSNumber *albumId; // 编号
@property(nonatomic,strong)NSString *title;//标题
@property (nonatomic, strong)NSString *descriptiontt; // 描述
@property(nonatomic,strong)NSString *artistName; // 艺术家名字
@property(nonatomic,strong)NSString *posterPic;//海报图片(缩略图)
@property(nonatomic,strong)NSString *thumbnailPic;//海报图片(缩略图)
@property(nonatomic,strong)NSNumber *totalViews;


@property(nonatomic,strong)NSNumber *videoSize;//视频边框大小
@property(nonatomic,strong)NSNumber *hdVideoSize;//hd视频边框大小
@property(nonatomic,strong)NSNumber *uhdVideoSize;//uhd视频边框大小
@property(nonatomic,strong)NSNumber *shdVideoSize; // shd视频边框大小
@property(nonatomic,strong)NSNumber *duration;
@property(nonatomic,strong)NSNumber *status;

@property(nonatomic,strong)NSString *promoTitle; // 广告标题
@property(nonatomic,strong)NSString *playListPic; // 播放列表的图片




@end
