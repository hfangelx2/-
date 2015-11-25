//
//  RecommenViewCell.m
//  CCMV
//
//  Created by zd on 15/4/15.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "RecommenViewCell.h"
#import "RecommenModel.h"
#import "UIColor+info.h"
#import "UIImageView+WebCache.h"
#import "CustomView.h"


@interface RecommenViewCell()

@property(nonatomic,strong)UIImageView *backgroundImageView;
@property(nonatomic,strong)UIImageView *littleImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *singerLabel;

@property(nonatomic,strong)UIView *changeView;

@property(nonatomic,strong)CustomView *blackView;



@end


@implementation RecommenViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        
        self.backgroundImageView = [[UIImageView alloc]init];
        self.backgroundImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.backgroundImageView];
        
        
        self.littleImageView = [[UIImageView alloc]init];
        self.littleImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.littleImageView];
      
        
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
     
        
        self.singerLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.singerLabel];
    }
    return self;
}

- (void)setAllValues:(RecommenModel *)recommenModel
{
    self.titleLabel.text =recommenModel.title;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    self.singerLabel.text= recommenModel.descriptiontt;
    self.singerLabel.textColor = [UIColor colorWithHexString:@"33ffcc"];
    self.singerLabel.font = [UIFont systemFontOfSize:16];
    
    NSURL *backgroundUrl = [NSURL URLWithString:recommenModel.posterPic];
    [self.backgroundImageView setImageWithURL:backgroundUrl placeholderImage:[UIImage imageNamed:@"placeHold1.png"]];
    
    [self.littleImageView setImage:[UIImage imageNamed:@"HomePagePlay.png"]];
    
    // cell每次出现时盖一层黑色视图     // customView里写了点穿的方法
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
    [self.backgroundImageView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.titleLabel setFrame:CGRectMake(self.contentView.frame.size.width / 15 * 3, self.contentView.frame.size.height / 6 * 5, 300, 20)];
    [self.singerLabel setFrame:CGRectMake(self.contentView.frame.size.width / 15 * 3, self.contentView.frame.size.height / 10 * 9, 200, 20)];
    [self.littleImageView setFrame:CGRectMake(20, self.contentView.frame.size.height /5 * 4, 43, 43)];
    
 
    
    // 添加每个cell上渐变视图  (如果这个渐变图在初始化中写,尺寸会变成一个横柱)
    self.changeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height / 25 * 12, self.contentView.frame.size.width, self.contentView.frame.size.height / 25 * 13)];
    
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








- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
