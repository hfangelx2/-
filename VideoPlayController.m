//
//  VideoPlayController.m
//  CCMV
//
//  Created by zd on 15/4/22.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "VideoPlayController.h"
#import "UIImageView+WebCache.h"

#import "VideoPlayModel.h"
#import "VideoPlayArtistModel.h"
#import "VideoPlayTableViewModel.h"

#import "VideoPlayViewCell.h"
#import "MJRefresh.h"
#import "WebRequest.h"

#import "UIColor+info.h"



#import "HaishenPlayerViewController.h"
#define   WIDTH [[UIScreen mainScreen] bounds].size.width
#define   HEIGHT [[UIScreen mainScreen] bounds].size.height



@interface VideoPlayController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,strong)NSMutableDictionary *urlDic;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *ViewSameAsTableView;
@property(nonatomic,strong)UIImageView *viewAvatarView;
@property(nonatomic,strong)UILabel *artistLabel;
@property(nonatomic,strong)UILabel *artistNameLabel;
@property(nonatomic,strong)UILabel *playTimesLabel;
@property(nonatomic,strong)UILabel *playTimesLabel2;
@property(nonatomic,strong)UILabel *onLineTimeLabel;
@property(nonatomic,strong)UILabel *onLineTimeLabel2;
@property(nonatomic,strong)UILabel *descriptionLabel;

@property(nonatomic,strong)HaishenPlayerViewController *haishenPlayer;

@property(nonatomic,strong)VideoPlayModel *videoPlayModel;

@property(nonatomic,strong)VideoPlayArtistModel *videoPlayArtistModel;

@property(nonatomic,strong)VideoPlayTableViewModel *videoPlayTableViewModel;

@property(nonatomic,assign)NSInteger viewHidden;

@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIButton *rightButton;


@end

@implementation VideoPlayController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.modelArray =[NSMutableArray array];
        self.urlDic =[NSMutableDictionary dictionary];
        self.viewHidden = 1;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [backgroundView setImage:[self getPhoto:@"Blur-2" type:@"png"]];
    [self.view addSubview:backgroundView];
    
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 84)];
    [navView setBackgroundColor:[UIColor blackColor]];
    navView.alpha = 0.5;
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnButton setFrame:CGRectMake(15, 20, 30, 30)];
    [returnButton setImage:[UIImage imageNamed:@"returnButton.png"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:returnButton];
    [self.view addSubview:navView];
    
    [self createVideoPlayView];
    [self createButton];
    [self createTableView];
    [self createView];
//    [self createTabbarView];
    
    self.tableView.alpha = 0;
    self.tableView.userInteractionEnabled = NO;
}

- (void)returnAction:(id)sender
{
    [self.haishenPlayer.player stop];
    
    if([self.delegate respondsToSelector:@selector(videoPlayViewDispare)]){
        [self.delegate videoPlayViewDispare];
    }
}


- (void)startConnect
{
    NSLog(@"这是播放页面的网络请求");
    
    //http://mapi.yinyuetai.com/video/show.json?D-A=0&id=2276804&relatedVideos=true&supportHtml=true
    
    [_urlDic setObject:@"0" forKey:@"D-A"];
    [_urlDic setObject:self.idNum forKey:@"id"];
    [_urlDic setObject:@"true" forKey:@"relatedVideos"];
    [_urlDic setObject:@"true" forKey:@"supportHtml"];
    
    [WebRequest connectWithUrl:VideoPlay parmater:_urlDic requestHeader:RequestHeader httpMethod:@"GET" view:self.view block:^(id data) {
        if(data){
            
            NSDictionary *bigDic = (NSDictionary *)data;
            self.videoPlayModel = [[VideoPlayModel alloc]initWithDictionary:bigDic];
            
            [self.tableView reloadData];
            
            NSString *url = self.videoPlayModel.hdUrl;
            NSURL *urlStr = [NSURL URLWithString:url];
            self.haishenPlayer.player.contentURL = urlStr;
            [self.haishenPlayer.player play];
            
            
            self.videoPlayArtistModel = [self.videoPlayModel.artists firstObject];
            
            
            NSURL *avatarUrl = [NSURL URLWithString:self.videoPlayArtistModel.artistAvatar];
            [self.viewAvatarView setImageWithURL:avatarUrl];
            
            
            self.artistNameLabel.text = self.videoPlayArtistModel.artistName;
            
            
            NSString *total = [NSString stringWithFormat:@"%@",self.videoPlayModel.totalViews];
            self.playTimesLabel2.text = total;
            
            
            self.onLineTimeLabel2.text = self.videoPlayModel.regdate;
            
            // 设置介绍label的自适应
            self.descriptionLabel.text = self.videoPlayModel.descriptiontt;
            NSDictionary *strAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
            NSString *value = self.videoPlayModel.descriptiontt;
            CGFloat width = self.ViewSameAsTableView.frame.size.width;
            CGRect strRect = [value boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:strAtt context:nil];
            [self.descriptionLabel setFrame:CGRectMake(self.descriptionLabel.frame.origin.x , self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width - 20, strRect.size.height)];
            
            
        }else if (!data){
            
            }
        
    } refresh:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startConnect];
        });
    }];
}


- (void)createVideoPlayView
{
    self.haishenPlayer = [[HaishenPlayerViewController alloc] init];
    [self.haishenPlayer addHaishenPlayerOn:self rect:CGRectMake(0, 64, WIDTH, 230)];
    
}

- (void)createButton
{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 294, self.view.frame.size.width / 2, 45)];
    buttonView.backgroundColor = [UIColor blackColor];
    buttonView.alpha = 0.6;
    buttonView.layer.masksToBounds = YES;
    buttonView.clipsToBounds = YES;
    buttonView.layer.borderWidth = 1;
    buttonView.layer.borderColor = (__bridge CGColorRef)([UIColor blackColor]);
    [self.view addSubview:buttonView];
    
    UIView *buttonView2 = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2, 294, self.view.frame.size.width / 2, 45)];
    buttonView2.backgroundColor = [UIColor blackColor];
    buttonView2.alpha = 0.6;
    buttonView2.layer.masksToBounds = YES;
    buttonView2.clipsToBounds = YES;
    buttonView2.layer.borderWidth = 1;
    buttonView2.layer.borderColor = (__bridge CGColorRef)([UIColor blackColor]);
    [self.view addSubview:buttonView2];

    
    
    
    
    
    
    
    self.leftButton = [[UIButton alloc]initWithFrame:CGRectMake(buttonView.frame.size.width - 130, 6, 136, 30)];
    
    [self.leftButton setTitle:@"MV描述" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftButton setBackgroundColor:[UIColor colorWithHexString:@"00cc99"]];
    self.leftButton.layer.masksToBounds = YES;
    self.leftButton.layer.cornerRadius = 6.0f;
    self.leftButton.titleLabel.font = [UIFont fontWithName:@"Copperplate-Light" size:16];
    
    [self.leftButton addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:self.leftButton];
    
    
    self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(-6,6,136,30)];
    
    [self.rightButton setTitle:@"相关MV" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"00cc99"] forState:UIControlStateNormal];
    self.rightButton.backgroundColor = [UIColor clearColor];
    self.rightButton.layer.masksToBounds = YES;
    self.rightButton.layer.cornerRadius = 6.0f;
    self.rightButton.titleLabel.font = [UIFont fontWithName:@"Copperplate-Light" size:16];

    self.rightButton.layer.borderColor = [UIColor colorWithHexString:@"00cc99"].CGColor;
    self.rightButton.layer.borderWidth = 1.0f;
    
    [self.rightButton addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView2 addSubview:self.rightButton];

}

- (void)button1Action:(id)sender
{
    if(self.viewHidden == 1){
        }
    else{
        self.ViewSameAsTableView.alpha = 0.7;
        self.ViewSameAsTableView.userInteractionEnabled = YES;
        self.tableView.alpha = 0;
        self.tableView.userInteractionEnabled = NO;
        self.viewHidden -- ;
        
        [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.leftButton setBackgroundColor:[UIColor colorWithHexString:@"00cc99"]];
        self.leftButton.layer.cornerRadius = 4.0f;
        
        self.rightButton.backgroundColor = [UIColor clearColor];
        self.rightButton.layer.cornerRadius = 4.0f;
        self.rightButton.layer.borderColor = [UIColor colorWithHexString:@"00cc99"].CGColor;
        self.rightButton.layer.borderWidth = 1.0f;

    }
}

- (void)button2Action:(id)sender
{
    if(self.viewHidden == 1){
        self.ViewSameAsTableView.alpha = 0;
        self.ViewSameAsTableView.userInteractionEnabled = NO;
        self.tableView.alpha = 0.7;
        self.tableView.userInteractionEnabled = YES;
        self.viewHidden ++;
        
        self.leftButton.backgroundColor = [UIColor clearColor];
        self.leftButton.layer.cornerRadius = 4.0f;
        self.leftButton.layer.borderColor = [UIColor colorWithHexString:@"00cc99"].CGColor;
        self.leftButton.layer.borderWidth = 1.0f;

        
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightButton setBackgroundColor:[UIColor colorWithHexString:@"00cc99"]];
        self.rightButton.layer.cornerRadius = 4.0f;

        
    }else{
    
    }
}


- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 340, self.view.frame.size.width, self.view.frame.size.height - 310  ) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoPlayModel.relatedVideos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *pool = @"name1";
    
    VideoPlayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pool];
    if(!cell){
        cell = [[VideoPlayViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:pool];
    }
    
    if(self.videoPlayModel.relatedVideos.count > indexPath.row){
        VideoPlayTableViewModel *videoPlayTableViewModel = self.videoPlayModel.relatedVideos[indexPath.row];
        
        [cell setAllValues:videoPlayTableViewModel];
        
        }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.tableView.frame.size.height / 4);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.videoPlayTableViewModel = [self.videoPlayModel.relatedVideos objectAtIndex:indexPath.row];
    self.idNum = self.videoPlayTableViewModel.albumId;
    
    [self startConnect];
    
    
    
}





- (void)createView
{
    
    // 和tableView一样大的View
    self.ViewSameAsTableView = [[UIView alloc]initWithFrame:CGRectMake(0, 340, self.view.frame.size.width, self.view.frame.size.height - 310)];
    self.ViewSameAsTableView.backgroundColor = [UIColor blackColor];
    self.ViewSameAsTableView.alpha = 0.7;
    
    // view上的头像
    self.viewAvatarView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 50, 50)];
    [self.viewAvatarView.layer setMasksToBounds:YES]; // 设置完这个属性,layer层的东西就可以改变了
    self.viewAvatarView.layer.cornerRadius = 25.0f;
    
    [self.ViewSameAsTableView addSubview:self.viewAvatarView];
    
    // 艺人Label
    self.artistLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 20, 100, 15)];
    self.artistLabel.text = @"艺人";
    self.artistLabel.textColor = [UIColor grayColor];
    self.artistLabel.font = [UIFont systemFontOfSize:12];
    [self.ViewSameAsTableView addSubview:self.artistLabel];
    
    
    // 艺人姓名label
    self.artistNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 35, 100, 15)];
    self.artistNameLabel.textColor = [UIColor colorWithHexString:@"33ffcc"];
    self.artistNameLabel.font = [UIFont systemFontOfSize:12];
    [self.ViewSameAsTableView addSubview:self.artistNameLabel];
    
    
    // 播放次数label
    self.playTimesLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 60, 20)];
    self.playTimesLabel.text = @"播放次数: ";
    self.playTimesLabel.textColor = [UIColor grayColor];
    self.playTimesLabel.font = [UIFont systemFontOfSize:12];
    [self.ViewSameAsTableView addSubview:self.playTimesLabel];
    
    self.playTimesLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(70, 70, 90, 20)];
    self.playTimesLabel2.textColor = [UIColor whiteColor];
    self.playTimesLabel2.font = [UIFont systemFontOfSize:12];
    [self.ViewSameAsTableView addSubview:self.playTimesLabel2];
    
    
    // 发布时间Label
    self.onLineTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(180,70 , 60, 20)];
    self.onLineTimeLabel.text = @"发布时间: ";
    self.onLineTimeLabel.textColor = [UIColor grayColor];
    self.onLineTimeLabel.font = [UIFont systemFontOfSize:12];
    [self.ViewSameAsTableView addSubview:self.onLineTimeLabel];
    
    self.onLineTimeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(240, 70, 130, 20)];
    self.onLineTimeLabel2.textColor = [UIColor whiteColor];
    self.onLineTimeLabel2.font = [UIFont systemFontOfSize:12];
    [self.ViewSameAsTableView addSubview:self.onLineTimeLabel2];
    
    
    // 简介Label
    self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, self.ViewSameAsTableView.frame.size.width, self.ViewSameAsTableView.frame.size.height - 100)];
    self.descriptionLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.font = [UIFont systemFontOfSize:14];
    self.descriptionLabel.numberOfLines = 0;
    [self.ViewSameAsTableView addSubview:self.descriptionLabel];
    
    [self.view addSubview:self.ViewSameAsTableView];
}


- (void)createTabbarView
{
    UIView *tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50,self.view.frame.size.width , 50)];
    [tabBarView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:tabBarView];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.haishenPlayer.player pause];
    self.haishenPlayer.player.contentURL = nil;
}


- (UIImage *)getPhoto:(NSString *)name type:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
