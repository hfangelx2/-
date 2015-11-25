//
//  ViewController.m
//  CCMV
//
//  Created by zd on 15/4/9.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "ViewController.h"
#import "LeftViewController.h"

#import "RecommendViewController.h"
#import "HotViewController.h"
#import "PopViewController.h"
#import "ULikeViewController.h"

#import "ChannelViewController.h"
#import "ChannelDetailController.h"
#import "VV_ViewController.h"
#import "PlayRecordViewController.h"
#import "LoadManagerViewController.h"
#import "SearchViewController.h"

#import "VideoPlayController.h"


#import "UIColor+info.h"



@interface ViewController ()<LeftViewControllerDelegate,SearchViewControllerDelegate,ChannelDetailViewControllerDelegate,VideoPlayControllerDelegate>

@property(nonatomic,strong)LeftViewController *leftViewController; // 左边视图
@property(nonatomic,strong)SearchViewController *searchController; // 右边的搜索视图
@property(nonatomic,strong)ChannelDetailController *channelDetailController; // 右边的频道详情页面;(和搜索页面的原理相同)

@property(nonatomic,strong)UIImageView *backgroundView; // 整个大视图的背景
@property(nonatomic,strong)UIGestureRecognizer *tap;


@property(nonatomic,strong)UITabBarController *tabBarController;   // 中间视图
@property(nonatomic,strong)ChannelViewController *channelViewController; // 频道视图
@property(nonatomic,strong)VV_ViewController *VVViewController; // V榜页面
@property(nonatomic,strong)LoadManagerViewController *loadManagerController; // 下载管理页面
@property(nonatomic,strong)PlayRecordViewController *playRecordController; // 播放记录页面;
@property(nonatomic,strong)VideoPlayController *videoPlayController; // 视频播放页面

@property(nonatomic,strong)RecommendViewController *recommendViewController;
@property(nonatomic,strong)HotViewController *hotViewController;
@property(nonatomic,strong)PopViewController *popViewController;
@property(nonatomic,strong)ULikeViewController *uLikeViewController;





@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
    }
    return self;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.videoPlayController.delegate = self;
    
    // 通过路径设置整个大视图的背景图片
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Blur-6" ofType:@"png"];
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:path]];
    self.backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.backgroundView.userInteractionEnabled = YES; // 因为是ImageView,手动打开用户交互
    [self.view addSubview:self.backgroundView];

    
    
    __block ViewController *view = self;

    
    // 创建左边的视图
    self.leftViewController = [[LeftViewController alloc]init];
    self.leftViewController.delegate = self;
    [self addChildViewController:_leftViewController];
    [self.view addSubview:_leftViewController.view];
    [_leftViewController.view setFrame:CGRectMake(-self.view.frame.size.width, 0, 280, self.view.frame.size.height)];
    
    
    // 创建右边的搜索视图
    self.searchController  = [[SearchViewController alloc]init];
    self.searchController.delegate = self;
    [self.searchController setVideoPlayerBlock:^{
        [view createVideoPlayView];
    }];
    
    [self addChildViewController:_searchController];
    [self.view addSubview:_searchController.view];
    [_searchController.view setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width,self.view.frame.size.height)];
    
    

    // 创建tabBarController(中间的视图)
    self.tabBarController = [[UITabBarController alloc]init];
    
    
    
    // 创建频道视图
    self.channelViewController = [[ChannelViewController alloc]init];
    [self.channelViewController setBlock:^{
        [view createLeftView];
    }];
    [self.channelViewController setBlock2:^{
        [view createRightView];
    }];
    [self.channelViewController setBlock3Detail:^{
        [view createChannelDetailView];
    }];
    
    [self addChildViewController:self.channelViewController];
    [self.view addSubview:self.channelViewController.view];
    
    
    // 创建v榜视图
    self.VVViewController = [[VV_ViewController alloc]init];
    [self.VVViewController setBlock:^{
        [view createLeftView];
    }];
    [self.VVViewController setBlock2:^{
        [view createRightView];
    }];
    [self.VVViewController setVideoPlayerBlock:^{
        [view createVideoPlayView];
    }];
    [self addChildViewController:self.VVViewController];
    [self.view addSubview:self.VVViewController.view];
    
    
    // 创建下载管理页面
    self.loadManagerController = [[LoadManagerViewController alloc]init];
    [self.loadManagerController setBlock:^{
        [view createLeftView];
    }];
    [self.loadManagerController setBlock2:^{
        [view createRightView];
    }];
    [self addChildViewController:self.loadManagerController];
    [self.view addSubview:self.loadManagerController.view];

    
    //创建播放历史界面
    self.playRecordController = [[PlayRecordViewController alloc]init];
    [self.playRecordController setBlock:^{
        [view createLeftView];
    }];
    [self.playRecordController setBlock2:^{
        [view createRightView];
    }];
    [self addChildViewController:self.playRecordController];
    [self.view addSubview:self.playRecordController.view];
    
    
    
    // 初始化首页中的几个页面
    // 第一个页面
    self.recommendViewController = [[RecommendViewController alloc]init];
    [self.recommendViewController setBlock:^{
        [view createLeftView];
    }];
    [self.recommendViewController setBlock2:^{
        [view createRightView];
    }];
    [self.recommendViewController setVideoPlayerBlock:^{
        [view createVideoPlayView];
    }];
    
    UINavigationController *recommendNav = [[UINavigationController alloc]initWithRootViewController:self.recommendViewController];
    
    UIImage *normal1 = [UIImage imageNamed:@"11.png"];
    UIImage *rendNormal1 = [normal1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *select1 = [UIImage imageNamed:@"1.png"];
    UIImage *rendSelect1 = [select1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.recommendViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我们推荐" image:rendNormal1 selectedImage:rendSelect1];
    
    
    
    // 第二个页面
    self.hotViewController = [[HotViewController alloc]init];
    [self.hotViewController setBlock:^{
        [view createLeftView];
    }];
    [self.hotViewController setBlock2:^{
        [view createRightView];
    }];
    [self.hotViewController setVideoPlayerBlock:^{
        [view createVideoPlayView];
    }];
    UINavigationController *hotNav = [[UINavigationController alloc]initWithRootViewController:self.hotViewController];
    
    UIImage *normal2 = [UIImage imageNamed:@"22.png"];
    UIImage *rendNormal2 = [normal2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *select2 = [UIImage imageNamed:@"2.png"];
    UIImage *rendSelect2 = [select2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.hotViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"热度很高" image:rendNormal2 selectedImage:rendSelect2];

    
    
    // 第三个页面
    self.popViewController = [[PopViewController alloc]init];
    [self.popViewController setBlock:^{
        [view createLeftView];
    }];
    [self.popViewController setBlock2:^{
        [view createRightView];
    }];
    [self.popViewController setVideoPlayerBlock:^{
        [view createVideoPlayView];
    }];
    UINavigationController *popNav = [[UINavigationController alloc]initWithRootViewController:self.popViewController];
    
    UIImage *normal3 = [UIImage imageNamed:@"33.png"];
    UIImage *rendNormao3 = [normal3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *select3 = [UIImage imageNamed:@"3.png"];
    UIImage *rendSelect3 = [select3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.popViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"听说流行" image:rendNormao3 selectedImage:rendSelect3];
    
    
    
    // 第四个页面
    self.uLikeViewController = [[ULikeViewController alloc]init];
    [self.uLikeViewController setBlock:^{
        [view createLeftView];
    }];
    [self.uLikeViewController setBlock2:^{
        [view createRightView];
    }];
    [self.uLikeViewController setVideoPlayerBlock:^{
        [view createVideoPlayView];
    }];
    UINavigationController *uLikeNav = [[UINavigationController alloc]initWithRootViewController:self.uLikeViewController];
    
    UIImage *normal4 = [UIImage imageNamed:@"44.png"];
    UIImage *rendNormal4 = [normal4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *select4 = [UIImage imageNamed:@"4.png"];
    UIImage *rendSelect4 = [select4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.uLikeViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"猜你喜欢" image:rendNormal4 selectedImage:rendSelect4];
    
    
    
    // 将四个页面放到中间的页面上.
    _tabBarController.viewControllers = @[recommendNav,hotNav,popNav,uLikeNav];
    [self addChildViewController:_tabBarController];
    [self.view addSubview:_tabBarController.view];
    
    
    
    // 设置tabBar字体颜色
    UIColor *tabColor = [UIColor colorWithHexString:@"33ffcc"];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:tabColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    
    
    // 设置tabBar颜色
    _tabBarController.tabBar.barTintColor = [UIColor blackColor];

}


#pragma mark-
#pragma 左边抽屉和右边搜索页面的协议方法

// 进入设置页面时,让中间视图铺满全屏 , 点击首页时也执行这个协议方法
- (void)setButtonDidPress {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [_leftViewController.view setFrame:CGRectMake(-self.view.frame.size.width, 0, 280, self.view.frame.size.height)];
        
        [_tabBarController.view setFrame:[[UIScreen mainScreen] bounds]];
        
        [_tabBarController.view.superview bringSubviewToFront:_tabBarController.view];
        
        
    } completion:^(BOOL finished) {
        
    }];
}


// 进入频道页面
- (void)pushToChannelController
{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [_leftViewController.view setFrame:CGRectMake(-self.view.frame.size.width, 0, 280, self.view.frame.size.height)];
                
        [_channelViewController.view setFrame:[[UIScreen mainScreen]bounds]];
        
        [_channelViewController.view.superview bringSubviewToFront:_channelViewController.view];
                
    } completion:^(BOOL finished) {
        
    }];
    
}



// 进入V榜页面
- (void)pushToVVController
{
    [UIView animateWithDuration:0.2 animations:^{
        
        [_VVViewController beginConnect];
        
        [_leftViewController.view setFrame:CGRectMake(-self.view.frame.size.width, 0, 280, self.view.frame.size.height)];
        
        [_VVViewController.view setFrame:[[UIScreen mainScreen]bounds]];
        
        [_VVViewController.view.superview bringSubviewToFront:_VVViewController.view];
        
        
        
    } completion:^(BOOL finished) {
        
    }];

}


// 进入下载管理界面
- (void)pushToLoadManagerController
{
    [UIView animateWithDuration:0.2 animations:^{
        
        [_leftViewController.view setFrame:CGRectMake(-self.view.frame.size.width, 0, 280, self.view.frame.size.height)];
        
        [_loadManagerController.view setFrame:[[UIScreen mainScreen]bounds]];
        
        [_loadManagerController.view.superview bringSubviewToFront:_loadManagerController.view];
        
    } completion:^(BOOL finished) {
        
    }];
}


// 进入播放历史界面
- (void)pushToPlayRecordController
{
    [UIView animateWithDuration:0.2 animations:^{
        
        [_leftViewController.view setFrame:CGRectMake(-self.view.frame.size.width, 0, 280, self.view.frame.size.height)];
        
        [_playRecordController.view setFrame:[[UIScreen mainScreen]bounds]];
        
        [_playRecordController.view.superview bringSubviewToFront:_playRecordController.view];
        
    } completion:^(BOOL finished) {
        
    }];
}


// 从搜索页面返回
- (void)returnFromSearchViewController
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.searchController.view setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
//  [self.searchController.view.superview bringSubviewToFront:self.searchController.view];
        
    } completion:^(BOOL finished) {
        
    }];
}

// 从频道详情页面返回
- (void)returnFromChannelDetailViewController
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.channelDetailController.view setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
//  [self.searchController.view.superview bringSubviewToFront:self.searchController.view];
    } completion:^(BOOL finished) {
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.channelDetailController.view removeFromSuperview];
        [self.channelDetailController removeFromParentViewController];
    });

}


// 进入频道详情页面,并把频道详情页面放到中间
- (void)createChannelDetailView
{
    __block ViewController *view = self;

    
    // 创建右边的频道详情视图
    self.channelDetailController = [[ChannelDetailController alloc]init];
    [self.channelDetailController setVideoPlayerBlock:^{
        [view createVideoPlayView];
    }];
    self.channelDetailController.delegate = self;
    self.channelViewController.viewController = self.channelDetailController;
    [self.channelDetailController.view setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self addChildViewController:_channelDetailController];
    [self.view addSubview:_channelDetailController.view];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.channelDetailController.view setFrame:self.view.frame];
        [self.channelDetailController.view.superview bringSubviewToFront:self.channelDetailController.view];
        
    } completion:^(BOOL finished) {
        
    }];
}





// 设置左边页面 ,作为四个小页面的block方法中的动作
- (void)createLeftView
{
    [UIView animateWithDuration:0.2 animations:^{
        _leftViewController.view.frame = CGRectMake(0, 0, 300, self.view.frame.size.height);
        
        [_VVViewController.view setFrame:CGRectMake(300, 60, 300, self.view.frame.size.height - 120)];
        
        [_channelViewController.view setFrame:CGRectMake(300, 60, 300, self.view.frame.size.height - 120)];
        
        [_tabBarController.view setFrame:CGRectMake(300, 60, 300, self.view.frame.size.height - 120)];

        
        [_playRecordController.view setFrame:CGRectMake(300, 60, 300, self.view.frame.size.height - 120)];
        
        [_loadManagerController.view setFrame:CGRectMake(300, 60, 300, self.view.frame.size.height - 120)];
        
    } completion:^(BOOL finished) {
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(300, 0, self.view.frame.size.width - 300, self.view.frame.size.height)];
        [rightView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:rightView];
        
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftHidden:)];
        [rightView addGestureRecognizer:self.tap];
        
    }];
}


// 左边视图出现后,点击右边的视图,恢复到中间视图
- (void)leftHidden:(UITapGestureRecognizer *)tap
{
    
    [UIView animateWithDuration:0.2 animations:^{
        [_leftViewController.view setFrame:CGRectMake(-self.view.frame.size.width, 0, 280, self.view.frame.size.height)];
        
        [_VVViewController.view setFrame:[[UIScreen mainScreen]bounds]];
        
        [_channelViewController.view setFrame:[[UIScreen mainScreen] bounds]];
        
        [_tabBarController.view setFrame:[[UIScreen mainScreen] bounds]];
        
        [_playRecordController.view setFrame:[[UIScreen mainScreen] bounds]];
        
        [_loadManagerController.view setFrame:[[UIScreen mainScreen] bounds]];
        
    } completion:^(BOOL finished) {
        
    }];
    
    [tap.view removeFromSuperview];
}


// 设置右边页面,作为所有页面搜索按钮的block方法
- (void)createRightView
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.searchController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.searchController.view.superview bringSubviewToFront:self.searchController.view];
        
        [self.searchController startConnect];
        
    } completion:^(BOOL finished) {
        
    }];
}



// 进入播放界面
- (void)createVideoPlayView
{
    self.videoPlayController = [[VideoPlayController alloc]init];
    self.videoPlayController.delegate = self;
    
    self.recommendViewController.viewController = self.videoPlayController; // 把self.videoPlayController 添加给其他视图的属性. 在其他视图中方便调用
    self.hotViewController.viewController = self.videoPlayController;
    self.popViewController.viewController = self.videoPlayController;
    self.uLikeViewController.viewController = self.videoPlayController;
    self.channelDetailController.viewController = self.videoPlayController;
    self.VVViewController.viewController = self.videoPlayController;
    self.searchController.viewController = self.videoPlayController;
    
    [self addChildViewController:self.videoPlayController];
    [self.view addSubview:self.videoPlayController.view];
    
    [self.videoPlayController.view setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.videoPlayController.view.superview bringSubviewToFront:self.videoPlayController.view];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.videoPlayController.view setFrame:self.view.frame];
        
    }];
}




- (void)videoPlayViewDispare
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.videoPlayController.view setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];

    } completion:^(BOOL finished) {

    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.videoPlayController.view removeFromSuperview];
        [self.videoPlayController removeFromParentViewController];
        
        
        
        self.recommendViewController.videoPlayState = NO; // 将播放状态设为no 重复点击的时候不会重复创建
        self.popViewController.videoPlayState = NO;
        self.uLikeViewController.videoPlayState = NO;
        self.hotViewController.videoPlayState = NO;
        self.VVViewController.videoPlayState = NO;
        self.channelDetailController.videoPlayState = NO;
        self.searchController.videoPlayState = NO;
    });
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
