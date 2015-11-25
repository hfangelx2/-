//
//  VideoPlayViewCell.m
//  CCMV
//
//  Created by zd on 15/4/22.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "VideoPlayViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+info.h"
#import "CustomView.h"

@interface VideoPlayViewCell ();

@property(nonatomic,strong)UIImageView *backgroundImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *singerLabel;
@property(nonatomic,strong)UIView *changeView;

@end


@implementation VideoPlayViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundImageView = [[UIImageView alloc]init];
        //        self.backgroundImageView.contentMode =UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.backgroundImageView];
        //        self.clipsToBounds = YES;
        
        
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
        
        self.singerLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.singerLabel];
    }
    return self;
}

- (void)setAllValues:(VideoPlayTableViewModel *)videoPlayTableviewModel;
{
    self.titleLabel.text = videoPlayTableviewModel.title;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    self.singerLabel.text = videoPlayTableviewModel.artistName;
    self.singerLabel.textColor = [UIColor colorWithHexString:@"33ffcc"];
    self.singerLabel.font = [UIFont systemFontOfSize:14];
    
    NSURL *backgroundUrl;
    if (![videoPlayTableviewModel.albumImg isEqualToString:@""]) {
        
        backgroundUrl = [NSURL URLWithString:videoPlayTableviewModel.albumImg];
        
    } else if (![videoPlayTableviewModel.posterPic isEqualToString:@""]) {
        
        backgroundUrl = [NSURL URLWithString:videoPlayTableviewModel.posterPic];
        
    } else {
        
        backgroundUrl = [NSURL URLWithString:videoPlayTableviewModel.thumbnailPic];
    }
    
    [self.backgroundImageView setImageWithURL:backgroundUrl placeholderImage:[UIImage imageNamed:@"placeHold2.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    
    
    
    // cell每次出现时盖一层黑色视图 (用点穿视图 给黑色视图加一个点击效果--让tableView停止)
    //    CustomView  *blackView = [[CustomView alloc]initWithFrame:CGRectMake(0, 0, 375, 154)];
    //    [blackView setBackgroundColor:[UIColor blackColor]];
    //    [self.contentView addSubview:blackView];
    //    [UIView animateWithDuration:1 animations:^{
    //        [blackView setBackgroundColor:[UIColor clearColor]];
    //    }];
    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    //    [self.changeView removeFromSuperview];
    [self.backgroundImageView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width / 5 * 2, self.contentView.frame.size.height)];
    
    [self.titleLabel setFrame:CGRectMake(self.contentView.frame.size.width / 5 * 2 + 10, self.contentView.frame.size.height / 3 - 20, 100, 20)];
    
    [self.singerLabel setFrame:CGRectMake(self.contentView.frame.size.width / 5 * 2 + 10, self.contentView.frame.size.height / 3 * 2 - 20, 100, 20)];
    
    
    
    // 添加每个cell上渐变视图  (如果这个渐变图在初始化中写,尺寸会变成一个横柱)
    //    self.changeView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, self.contentView.frame.size.width, self.contentView.frame.size.height - 79)];
    //
    //    CAGradientLayer *gradient = [CAGradientLayer layer];
    //    gradient.frame = CGRectMake(0, 0, _changeView.frame.size.width, _changeView.frame.size.height);
    //    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,
    //                       (id)[UIColor blackColor].CGColor,nil];
    //    [_changeView.layer insertSublayer:gradient atIndex:0];
    //    _changeView.alpha = 0.7;
    //    [self.contentView addSubview:_changeView];
    //
    //    // 将两个视图分别放到最后,不然会盖到字体
    //    [self.changeView.superview sendSubviewToBack:self.changeView];
    //    [self.backgroundImageView.superview sendSubviewToBack:self.backgroundImageView];
    
    
    
}







- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
