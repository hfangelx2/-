//
//  VideoPlayController.h
//  CCMV
//
//  Created by zd on 15/4/22.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoPlayControllerDelegate;


@interface VideoPlayController : UIViewController

@property(nonatomic,assign)id<VideoPlayControllerDelegate>delegate;

@property(nonatomic,strong)NSNumber *idNum;

- (void)startConnect;

@end

@protocol VideoPlayControllerDelegate <NSObject>

- (void)videoPlayViewDispare;

@end



