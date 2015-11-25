//
//  VVViewCell.m
//  CCMV
//
//  Created by zd on 15/4/20.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "VVViewCell.h"
#import "VV_Model.h"
#import "UIImageView+WebCache.h"
#import "UIColor+info.h"
#import "CustomView.h"

@interface VVViewCell ();

@property(nonatomic,strong)UIImageView *backgroundImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *singerLabel;

@property(nonatomic,strong)UILabel *NumLabel;

@property(nonatomic,strong)UILabel *scoreLabel;
@property(nonatomic,strong)UILabel *scoreRightLabel;

@property(nonatomic,strong)UIView *changeView;

@property(nonatomic,strong)CustomView *blackView;

@end

@implementation VVViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundImageView = [[UIImageView alloc]init];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.backgroundImageView];
        self.clipsToBounds= YES;
        
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
        
        self.singerLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.singerLabel];
        
        self.NumLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.NumLabel];

        self.scoreLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.scoreLabel];
        self.scoreRightLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.scoreRightLabel];
    }
    return self;
}

- (void)setAllValues:(VVVV_Model *)vvvvModel
{
    self.titleLabel.text = vvvvModel.title;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    self.singerLabel.text = vvvvModel.artistName;
    self.singerLabel.textColor = [UIColor colorWithHexString:@"33ffcc"];
    self.singerLabel.font = [UIFont systemFontOfSize:14];
    
    
    self.NumLabel.text = vvvvModel.num;
    self.NumLabel.textColor = [UIColor colorWithHexString:@"33ffcc"];
    self.NumLabel.font = [UIFont boldSystemFontOfSize:40];

    
    self.scoreLabel.text = vvvvModel.score;
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:18];
    self.scoreRightLabel.text = @"分";
    self.scoreRightLabel.textColor = [UIColor whiteColor];
    self.scoreRightLabel.font = [UIFont boldSystemFontOfSize:18];
    
    NSURL *backgroundUrl;
    
    if(![vvvvModel.albumImg isEqualToString:@""]){
        
        backgroundUrl = [NSURL URLWithString:vvvvModel.albumImg];
    }else if(![vvvvModel.posterPic isEqualToString:@""]){
        backgroundUrl = [NSURL URLWithString:vvvvModel.posterPic];
    }else{
        backgroundUrl = [NSURL URLWithString:vvvvModel.thumbnailPic];
    }
    [self.backgroundImageView setImageWithURL:backgroundUrl placeholderImage:[UIImage imageNamed:@"placeHold2.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    
    
    self.blackView =[[CustomView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
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
    
    [self.backgroundImageView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, [[UIScreen mainScreen] bounds].size.height / 13.0 * 4)];
    
    [self.titleLabel setFrame:CGRectMake(self.contentView.frame.size.width - 180, self.contentView.frame.size.height / 3 * 2 -10, 160, 20)];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [self.singerLabel setFrame:CGRectMake(self.contentView.frame.size.width - 180, self.contentView.frame.size.height / 3 * 2 + 10, 160, 20)];
    self.singerLabel.textAlignment = NSTextAlignmentRight;
    
    [self.NumLabel setFrame:CGRectMake(self.contentView.frame.size.width / 18 + 20, self.contentView.frame.size.height / 2 - 15, 100, 40)];
    
    [self.scoreLabel setFrame:CGRectMake(self.contentView.frame.size.width / 18, self.contentView.frame.size.height / 2 + 20, 50, 30)];
    [self.scoreRightLabel setFrame:CGRectMake(self.contentView.frame.size.width / 18 + 50, self.contentView.frame.size.height / 2+ 20, 50, 30)];
    
    
    // 添加每个cell上渐变视图  (如果这个渐变图在初始化中写,尺寸会变成一个横柱)
    self.changeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height / 20 * 11, self.contentView.frame.size.width, self.contentView.frame.size.height/ 20 * 9)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, _changeView.frame.size.width, _changeView.frame.size.height);
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,
                       (id)[UIColor blackColor].CGColor,nil];
    [_changeView.layer insertSublayer:gradient atIndex:0];
    _changeView.alpha = 0.7;
    [self.contentView addSubview:_changeView];
    
    // 将两个视图分别放到最后,不然会盖到字体
    [self.changeView.superview sendSubviewToBack:self.changeView];
    [self.backgroundImageView.superview sendSubviewToBack:self.backgroundImageView];
    
    
    
}








- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
