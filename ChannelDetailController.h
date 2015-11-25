//
//  ChannelDetailController.h
//  CCMV
//
//  Created by zd on 15/4/19.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChannelDetailViewControllerDelegate;

@interface ChannelDetailController : UIViewController



@property(nonatomic,weak)id<ChannelDetailViewControllerDelegate>delegate;

@property(nonatomic,strong)NSNumber *idNum;

@property(nonatomic,strong)UILabel *titleLabel;



@property(nonatomic,copy) void(^videoPlayerBlock)();
@property (nonatomic)BOOL videoPlayState; // 设置一个播放状态,防止重复点击的时候,主viewController重复创建这个视图
@property(nonatomic,strong)id viewController; //  在主viewController中,创建播放视图的时候,把播放视图赋给自己的这个属性,方便在属性中调用,而且防止调用的不是原来的播放视图;


- (void)startConnect;


@end

@protocol ChannelDetailViewControllerDelegate <NSObject>

- (void)returnFromChannelDetailViewController;

@end