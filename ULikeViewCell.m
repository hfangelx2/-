//
//  ULikeViewCell.m
//  CCMV
//
//  Created by zd on 15/4/16.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "ULikeViewCell.h"
#import "ULikeModel.h"
#import "UIImageView+WebCache.h"
#import "UIColor+info.h"
#import "CustomView.h"


@interface ULikeViewCell();
@property(nonatomic,strong)UIImageView *backgroundImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *singerLabel;

@property(nonatomic,strong)UIView *changeView;

@property(nonatomic,strong)UIButton *threePointButton;

@property(nonatomic,strong)CustomView *blackView;

@end



@implementation ULikeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundImageView = [[UIImageView alloc]init];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
      /*
        UIViewContentModeScaleToFill,  // 图片缩到cell大小
        UIViewContentModeScaleAspectFit, // 以上下对齐 或左右对齐
        UIViewContentModeScaleAspectFill,  // 保持原图片比例
       */
        [self.contentView addSubview:self.backgroundImageView];
        [self setClipsToBounds:YES];
        
        
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
        
        
        self.singerLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.singerLabel];
        
        
        self.threePointButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.threePointButton addTarget:self action:@selector(threePointAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.threePointButton];
        
    }
    return self;
}

- (void)setAllValues:(ULikeModel *)uLileModel
{
    
    
    [self.threePointButton setBackgroundImage:[UIImage imageNamed:@"threePoint.png"] forState:UIControlStateNormal];
    
    self.titleLabel.text =uLileModel.title;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    self.singerLabel.text= uLileModel.artistName;
    self.singerLabel.textColor = [UIColor colorWithHexString:@"33ffcc"];
    self.singerLabel.font = [UIFont systemFontOfSize:14];
    
    NSURL *backgroundUrl = [NSURL URLWithString:uLileModel.thumbnailPic];
    [self.backgroundImageView setImageWithURL:backgroundUrl placeholderImage:[UIImage imageNamed:@"placeHold1.png"]];
    
    
    // cell每次出现时盖一层黑色视图
    self.blackView = [[CustomView alloc]init];
    [self.blackView setBackgroundColor:[UIColor blackColor]];
    [self.contentView addSubview:self.blackView];
    [UIView animateWithDuration:1 animations:^{
        [self.blackView setBackgroundColor:[UIColor clearColor]];
    }];

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.changeView removeFromSuperview];
    
    [self.blackView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    
    [self.threePointButton setFrame:CGRectMake(self.contentView.frame.size.width - 50, self.contentView.frame.size.height - 30, 30, 30)];
    
    [self.backgroundImageView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 667 / 13.0 * 4)];
    [self.titleLabel setFrame:CGRectMake(self.contentView.frame.size.width / 75 + 10, self.contentView.frame.size.height / 3 * 2, 300, 20)];
    [self.singerLabel setFrame:CGRectMake(self.contentView.frame.size.width / 75 + 10, self.contentView.frame.size.height / 8 * 7 - 5, 200, 20)];

    
    
    // 添加每个cell上渐变视图  (如果这个渐变图在初始化中写,尺寸会变成一个横柱)
    self.changeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height / 25 * 16, self.contentView.frame.size.width, self.contentView.frame.size.height/ 25 * 9)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, _changeView.frame.size.width, _changeView.frame.size.height);
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,
                       (id)[UIColor blackColor].CGColor,nil];
    [_changeView.layer insertSublayer:gradient atIndex:0];
    _changeView.alpha = 0.8;
    [self.contentView addSubview:_changeView];
    
    [self.changeView.superview sendSubviewToBack:self.changeView];
    [self.backgroundImageView.superview sendSubviewToBack:self.backgroundImageView];
    
    
}


- (void)threePointAction:(id)sender
{
    //    if([self.delegate respondsToSelector:@selector(putThreePointView:)]){
    //        [self.delegate putThreePointView:self.indexPathNum];
    //    }
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
