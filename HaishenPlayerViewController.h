//
//  HaishenPlayerViewController.h
//  HaiShnePlay
//
//  Created by lanou3g on 15/4/19.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface HaishenPlayerViewController : UIViewController

@property (nonatomic, strong) MPMoviePlayerController *player;

- (void)addHaishenPlayerOn:(UIViewController *)controller rect:(CGRect)rect;

@end
