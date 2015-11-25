//
//  LeftViewController.h
//  CCMV
//
//  Created by zd on 15/4/10.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftViewControllerDelegate;

@interface LeftViewController : UIViewController

@property (nonatomic, assign)id<LeftViewControllerDelegate>delegate;

@end

@protocol LeftViewControllerDelegate <NSObject>

- (void)setButtonDidPress;

- (void)pushToChannelController;

- (void)pushToVVController;

- (void)pushToLoadManagerController;

- (void)pushToPlayRecordController;

@end