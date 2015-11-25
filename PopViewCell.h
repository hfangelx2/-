//
//  PopViewCell.h
//  CCMV
//
//  Created by zd on 15/4/18.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PopModel;

@protocol PopViewCellDelegate;


@interface PopViewCell : UITableViewCell

- (void)setAllValues:(PopModel *)popModel;

@property(nonatomic,weak)id<PopViewCellDelegate>delegate;
@property(nonatomic, assign)NSInteger indexPathNum;


@end

@protocol HotViewCellDelegate <NSObject>

- (void)putThreePointView:(NSInteger)indexPathNum;

@end