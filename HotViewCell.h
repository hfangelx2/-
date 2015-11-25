//
//  HotViewCell.h
//  CCMV
//
//  Created by zd on 15/4/16.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotModel;

@protocol HotViewCellDelegate;

@interface HotViewCell : UITableViewCell

- (void)setAllValues:(HotModel *)hotModel;

@property(nonatomic,weak)id<HotViewCellDelegate>delegate;
@property(nonatomic, assign)NSInteger indexPathNum;


@end

@protocol HotViewCellDelegate <NSObject>

- (void)putThreePointView:(NSInteger)indexPathNum;

@end