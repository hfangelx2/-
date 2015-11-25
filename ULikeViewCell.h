//
//  ULikeViewCell.h
//  CCMV
//
//  Created by zd on 15/4/16.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ULikeModel;

@protocol ULikeViewCellDelegate;


@interface ULikeViewCell : UITableViewCell

- (void)setAllValues:(ULikeModel *)uLileModel;

@property(nonatomic,weak)id<ULikeViewCellDelegate>delegate;
@property(nonatomic, assign)NSInteger indexPathNum;

@end

@protocol HotViewCellDelegate <NSObject>

- (void)putThreePointView:(NSInteger)indexPathNum;


@end
