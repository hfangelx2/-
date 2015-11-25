//
//  ChannelViewController.h
//  CCMV
//
//  Created by zd on 15/4/13.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACollectionViewReorderableTripletLayout.h"

@interface ChannelViewController : UIViewController<RACollectionViewDelegateReorderableTripletLayout,
    RACollectionViewReorderableTripletLayoutDataSource>

@property(nonatomic,strong)id viewController;

@property(nonatomic,copy)void(^block)();
@property(nonatomic,copy)void(^block2)();
@property(nonatomic,copy)void(^block3Detail)();

- (void)beginConnect;


@end
