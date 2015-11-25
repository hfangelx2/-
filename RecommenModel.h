//
//  RecommenModel.h
//  CCMV
//
//  Created by zd on 15/4/15.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommenModel : NSObject

@property(nonatomic,strong)NSString *type; // 节目种类
@property(nonatomic,strong)NSNumber *albumId; // 编号
@property (nonatomic, strong)NSString *descriptiontt; // 描述
@property(nonatomic,strong)NSString *title;//标题

@property(nonatomic,strong)NSString *posterPic;//海报图片(缩略图)
@property(nonatomic,strong)NSString *thumbnailPic;//海报图片(缩略图)
@property(nonatomic,strong)NSString *url;//首页详情中的视频url(极速)
@property(nonatomic,strong)NSString *hdurl;//首页详情中的视频url(高清)
@property(nonatomic,strong)NSString *uhdurl;//首页详情中的视频url(超清)


@property(nonatomic,strong)NSNumber *videoSize;//视频边框大小
@property(nonatomic,strong)NSNumber *hdVideoSize;//hd视频边框大小
@property(nonatomic,strong)NSNumber *uhdVideoSize;//uhd视频边框大小


@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,strong)NSString *traceUrl;
@property(nonatomic,strong)NSString *clickUrl;

@property(nonatomic,strong)id viewController;


- (id)initWithId:(NSNumber *)albumId;

+ (id)recommenModelWithId:(NSNumber *)albumId;





@end
