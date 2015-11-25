//
//  ChannelViewCell.m
//  CCMV
//
//  Created by zd on 15/4/18.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "ChannelViewCell.h"
#import "ChannelModel.h"
#import "UIImageView+WebCache.h"
#import "CustomView.h"


@interface ChannelViewCell ();

@property(nonatomic,strong)UIImageView *backgroundimageView;
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIView *changeView;


@end



@implementation ChannelViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        self.backgroundimageView = [[UIImageView alloc]init];
        self.backgroundimageView.userInteractionEnabled = YES;
        self.backgroundimageView.clipsToBounds = YES;
        self.backgroundimageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.backgroundimageView];
        
        
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)setAllValues:(ChannelModel *)channelModel
{
    NSURL *backgroundUrl = [NSURL URLWithString:channelModel.img];
    [self.backgroundimageView setImageWithURL:backgroundUrl placeholderImage:[UIImage imageNamed:@"placeHold1.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];

    self.titleLabel.text = channelModel.title;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.textColor = [UIColor whiteColor];
    
}





- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self.changeView removeFromSuperview];
    
    [self.backgroundimageView setFrame:self.contentView.frame];
    
    [self.titleLabel setFrame:CGRectMake(0, self.frame.size.height - 30, 100, 30)];
    
    
//    self.changeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height / 4 * 3, self.frame.size.width, self.frame.size.height / 4 )];
//
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.changeView.frame;
//    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,
//                       (id)[UIColor blackColor].CGColor,nil];
//    [_changeView.layer insertSublayer:gradient atIndex:0];
//    _changeView.alpha = 0.8;
//    [self.contentView addSubview:_changeView];
//    
//    [self.changeView.superview sendSubviewToBack:self.changeView];
//    [self.backgroundimageView.superview sendSubviewToBack:self.backgroundimageView];
    
}



- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if(self){
        self.backgroundimageView = [[UIImageView alloc]init];
        self.backgroundimageView.userInteractionEnabled = YES;
        self.backgroundimageView.clipsToBounds = YES;
        self.backgroundimageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.backgroundimageView];
        
        
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if(highlighted){
        self.backgroundimageView.alpha = .7f;
    }else{
        self.backgroundimageView.alpha = 1.0f;
    }
}







@end
