//
//  HaishenPlayerViewController.m
//  HaiShnePlay
//
//  Created by lanou3g on 15/4/19.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "HaishenPlayerViewController.h"
#import "UIColor+info.h"


#define   WIDTH  [[UIScreen mainScreen] bounds].size.width
#define   HEIGHT  [[UIScreen mainScreen] bounds].size.height


typedef NS_ENUM(NSInteger, BoardType) {
    BoardHidden,
    BoardNoHidden
};



@interface HaishenPlayerViewController ()


// 控制面板是否出现
@property (nonatomic, assign) BoardType boardType;

/// 视频总长
@property (nonatomic, assign) CGFloat chief;

/// 开始播放器大小
@property (nonatomic, assign) CGRect previousFrame;

/// 开始播放器中心点
@property (nonatomic, assign) CGPoint previousCenter;

/// 父视图控制器
@property (nonatomic, strong) UIViewController *controller;

/// 顶部控制板
@property (nonatomic, strong) UIView *topPanel;

/// 底部控制板
@property (nonatomic, strong) UIView *downPabel;

/// 全屏/返回
@property (nonatomic, strong) UIButton *fullAndBack;

/// 播放/暂停
@property (nonatomic, strong) UIButton *playAndPause;

/// 缓冲进度
@property (nonatomic, strong) UIProgressView *progress;

/// 进度条
@property (nonatomic, strong) UISlider *slider;

/// 当前进度
@property (nonatomic, strong) UIView *sliderView;

/// 显示时间
@property (nonatomic, strong) UILabel *timeLabel;

/// 计时器
@property (nonatomic, strong) NSTimer *time;

@property(nonatomic,strong)UIButton *rePlayButton;

@end

@implementation HaishenPlayerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}


#pragma mark - 添加播放器(外部方法)

- (void)addHaishenPlayerOn:(UIViewController *)controller rect:(CGRect)rect
{
    [controller addChildViewController:self];
    self.view.frame = rect;
    self.previousFrame = rect;
    self.controller = controller;
    self.previousCenter = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
    [controller.view addSubview:self.view];
    [self createPlayer];
    
}



#pragma mark - 添加播放器

- (void)createPlayer
{
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:nil];
    self.player.view.frame = self.view.bounds;
    self.player.controlStyle = MPMovieControlStyleNone;
    [self.view addSubview:self.player.view];
    
    [self addNotification];

    [self createDownPanel];
    
    self.boardType = BoardHidden;
    [self addTap];

    
}





#pragma mark - 创建底部控制板

- (void)createDownPanel
{
    self.downPabel = [[UIView alloc] initWithFrame:CGRectZero];
    self.downPabel.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
    [self.downPabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4]];
    [self.player.view addSubview:self.downPabel];
    
    self.playAndPause = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playAndPause.frame = CGRectMake(10, 5, 30, 30);
    self.playAndPause.layer.cornerRadius = 20;
    self.playAndPause.layer.masksToBounds = YES;
    [self.playAndPause setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    [self.playAndPause setImage:[self getPhoto:@"play" type:@"png"] forState:UIControlStateNormal];
    [self.playAndPause addTarget:self action:@selector(playAndPauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playAndPause.tag = 1;
//    self.playAndPause.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);  这个方法可以设定按钮中图片的尺寸
    [self.downPabel addSubview:self.playAndPause];
    
    
    self.progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progress.frame = CGRectMake(58, 20, self.view.frame.size.width - 193, 2);
    self.progress.trackTintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    self.progress.tintColor = [UIColor grayColor];
    [self.downPabel addSubview:self.progress];

    
    
    self.slider = [[UISlider alloc] initWithFrame: CGRectMake(55, 17, self.view.frame.size.width - 190, 8)];
    self.slider.minimumTrackTintColor = [UIColor colorWithHexString:@"33ffcc"];
//    self.slider.minimumValueImage = [self getPhoto:@"1" type:@"png"];  // 上面一条是给走过的设置颜色,因为有白条,所以用这句给设置一个图片,但图片是空,就默认成蓝色
    self.slider.maximumTrackTintColor = [UIColor whiteColor];
    self.slider.backgroundColor = [UIColor blackColor];
//    self.slider.thumbTintColor = [UIColor colorWithRed:0.517 green:0.734 blue:1.000 alpha:1.000];
    [self.slider setThumbImage:[self getPhoto:@"yuan" type:@"png"] forState:UIControlStateNormal];

    self.slider.continuous = NO; // slider拖动结束后触发事件.默认是YES,一直触发.
    [self.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.slider addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    [self.downPabel addSubview:self.slider];

    
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 115,15,100,10)];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.text = @"00/00";
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self.downPabel addSubview:self.timeLabel];
    
    
    self.fullAndBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fullAndBack.frame = CGRectMake(self.view.frame.size.width - 40, 10, 20, 20);
    [self.fullAndBack setImage:[self getPhoto:@"full" type:@"png"] forState:UIControlStateNormal];
    [self.fullAndBack addTarget:self action:@selector(fullAndBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.fullAndBack.tag = 1;
    [self.downPabel addSubview:self.fullAndBack];
    
}

/// 全屏按钮的点击事件
- (void)fullAndBackButtonAction:(UIButton *)fullAndBack
{
    if (self.fullAndBack.tag == 1) {
        self.fullAndBack.tag++;
        [self.fullAndBack setImage:[self getPhoto:@"goback" type:@"png"] forState:UIControlStateNormal];
        [self transToFullScree];
        [self.view.superview bringSubviewToFront:self.view];
    }
    else
    {
        [self.fullAndBack setImage:[self getPhoto:@"full" type:@"png"] forState:UIControlStateNormal];
        [self transToPreviousScree];
        self.fullAndBack.tag--;
    }
}

#pragma mark - 旋转至全屏

- (void)transToFullScree
{
    CGFloat width = self.controller.view.frame.size.width;
    CGFloat height = self.controller.view.frame.size.height;
    self.view.frame = CGRectMake(0, 0, height, width);
    self.view.center = self.controller.view.center;
    [self resetPlayerFrame2];
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);// 旋转π/2 的角度;
    [self createTopPanel];
}

#pragma mark - 旋转退出全屏

- (void)transToPreviousScree
{
    self.view.transform = CGAffineTransformMakeRotation(M_PI * 2);
    self.view.frame = self.previousFrame;
    self.view.center = self.previousCenter;
    self.player.view.frame = self.previousFrame;
    self.player.view.center = self.previousCenter;
    [self resetPlayerFrame];
    [self.topPanel removeFromSuperview];
}


#pragma mark - 旋转之后重新设置坐标

- (void)resetPlayerFrame
{
    self.player.view.frame = self.view.bounds;

    self.downPabel.frame = CGRectMake(0, self.view.frame.size.height / 5 * 4, self.view.frame.size.width, self.view.frame.size.height / 5 );
    
    self.fullAndBack.frame = CGRectMake(self.view.frame.size.width - 30, 10, 20, 20);
    
    self.progress.frame = CGRectMake(40, 19, self.view.frame.size.width - 190, 2);
    
    self.slider.frame = CGRectMake(38, 16, self.view.frame.size.width - 190, 8);
    
    self.timeLabel.frame = CGRectMake(self.view.frame.size.width - 130,15,100,10);
    
    self.playAndPause.frame = CGRectMake(10, 5, 30, 30);
    
}

- (void)resetPlayerFrame2
{
    self.player.view.frame = self.view.bounds;
    
    self.downPabel.frame = CGRectMake(0, self.view.frame.size.height / 7 * 6, self.view.frame.size.width, self.view.frame.size.height / 7);
    
    self.playAndPause.frame = CGRectMake(20, 12, 30, 30);
    
    self.fullAndBack.frame = CGRectMake(self.view.frame.size.width - 50, 12, 20, 20);
    
    self.progress.frame = CGRectMake(70, 26, self.view.frame.size.width - 240, 2);
    
    self.slider.frame = CGRectMake(68, 23, self.view.frame.size.width - 240, 8);
    
    self.timeLabel.frame = CGRectMake(self.view.frame.size.width - 170,22,100,10);
}

#pragma mark - 创建顶部控制板

- (void)createTopPanel
{
    self.topPanel = [[UIView alloc] initWithFrame:CGRectZero];
    self.topPanel.frame = CGRectMake(0, 0, self.view.frame.size.height, 40);
    self.topPanel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    [self.player.view addSubview:self.topPanel];
}




#pragma mark - 初始化后给播放器添加个手势
- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.player.view addGestureRecognizer:tap];
    UIView *sub = (UIView *)[self.player.view.subviews firstObject];
    [sub addGestureRecognizer:tap]; // 播放器有两层视图,一层管播放,一层管控制,所以都得添加手势
}

- (void)tapAction // 手势的动作:控制控制板的显隐
{
    if (self.boardType == BoardHidden) {
        [UIView animateWithDuration:1 animations:^{
            
            self.downPabel.alpha = 0;
            self.downPabel.userInteractionEnabled = NO;
            self.topPanel.alpha = 0;
            self.topPanel.userInteractionEnabled = NO;
            self.boardType = BoardNoHidden;
        }];
    }
    
    else
    {[UIView animateWithDuration:1 animations:^{
        
        self.downPabel.alpha = 1;
        self.downPabel.userInteractionEnabled = YES;
        self.topPanel.alpha = 1;
        self.topPanel.userInteractionEnabled = YES;
        self.boardType = BoardHidden;
        }];
    }
}




- (void)addNotification
{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    
    [notification addObserver:self selector:@selector(mediaPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.player]; //播放状态发生改变
    
    [notification addObserver:self selector:@selector(mdediaplaybackDidfinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player]; // 播放已经完成
    
    
    [notification addObserver:self selector:@selector(mdediaplayLoadStateChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:self.player]; // 加载状态发生改变
    
    
    [notification addObserver:self selector:@selector(mdediaplayDurationAvailable:) name:MPMovieDurationAvailableNotification object:self.player];
    // 获取视频总长度以后,走这个方法
}


- (NSTimer *)time
{
    if (!_time) {
        _time = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self
                                               selector:@selector(timeAction) userInfo:nil repeats:YES];
        [_time setFireDate:[NSDate distantFuture]];
    }
    return _time;
}

#pragma mark - 刷新
- (void)timeAction
{
    NSLog(@"开始刷新");
    if (self.chief > 0) {
        NSString *chief = [self getTimeWithseconds:self.chief];
        NSString *now = [self getTimeWithseconds:self.player.currentPlaybackTime];
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", now, chief];
        [self.progress setProgress:self.player.playableDuration / self.chief animated:YES];
        [self.slider setValue:self.player.currentPlaybackTime / self.chief animated:YES];
    }
}





#pragma mark - 播放状态
- (void)mediaPlaybackStateChange:(NSNotification *)notification
{
    switch (self.player.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放");
            [self.playAndPause setImage:[self getPhoto:@"pause" type:@"png"] forState:UIControlStateNormal];
            break;
            
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放");
            [self.playAndPause setImage:[self getPhoto:@"play" type:@"png"] forState:UIControlStateNormal];

            
            break;
        case MPMoviePlaybackStateInterrupted:
            NSLog(@"中断播放");
            
            
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放");
            
            break;
            
        case MPMoviePlaybackStateSeekingBackward:
            NSLog(@"向后播放");
            
            break;
            
        case MPMoviePlaybackStateSeekingForward:
            NSLog(@"向前播放");
            
            break;
            
        default:
            
            break;
    }
}

#pragma mark - 播放完成
- (void)mdediaplaybackDidfinish:(NSNotification *)notification
{
    
    NSLog(@"播放完成");
    self.rePlayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.rePlayButton setFrame:CGRectMake(170, 80, 30, 30)];
    [self.rePlayButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [self.rePlayButton addTarget:self action:@selector(rePlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.player.view addSubview:self.rePlayButton];
}

- (void)rePlayButton:(UIButton *)sender
{
    [self.player play];
    
    [sender removeFromSuperview];
    
}






#pragma mark - 加载状态
- (void)mdediaplayLoadStateChange:(NSNotification *)notification
{
    switch (self.player.loadState) {
            
        case MPMovieLoadStateUnknown:


            
            break;
        case MPMovieLoadStatePlayable:
            NSLog(@"加载状态:可以播放");
            
            
            break;
        case MPMovieLoadStatePlaythroughOK:
            NSLog(@"加载状态:将自动播放");
            
            
            break;
        case MPMovieLoadStateStalled:
            NSLog(@"加载状态:停滞");
            
            break;
        default:
            
            
            break;
    }
    
}


#pragma mark - 确定了媒体时长时

- (void)mdediaplayDurationAvailable:(NSNotification *)notification
{
    NSLog(@"播放时长%g", self.player.duration);
    self.chief = self.player.duration;
    
    [self.time setFireDate:[NSDate distantPast]];
}



- (void)playAndPauseButtonAction:(UIButton *)button
{
    if (self.playAndPause.tag == 1) {
        [self.player pause];
        self.playAndPause.tag++;
    }
    else
    {
        [self.player play];
        self.playAndPause.tag--;
    }
}



- (void)sliderAction:(UISlider *)slider
{
    [self.rePlayButton removeFromSuperview];
    
    if (self.chief > 0) {

        
        self.player.currentPlaybackTime = self.slider.value * self.chief;
        // 滑动slider后,如果视频总长大于0,就用slider的进度(百分数)乘以播放总长
        [self.player play];
        [self.time setFireDate:[NSDate distantPast]];
    }
    else // chief是视频总时长,在加载完数据,走消息中心时才会产生.所以添加else是说,如果没加载出来总时长的数据,slider拖到任意地方都会回到0;
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.slider.value = 0;
        }];
    }
}

#pragma mark - 监控slider的


// 在slider正在拖动时执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.player pause];
    [self.time setFireDate:[NSDate distantFuture]];// 把计时器暂停掉
    NSString *chief = [self getTimeWithseconds:self.chief];
    NSString *now = [self getTimeWithseconds:self.player.currentPlaybackTime];
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", now, chief];
}




// 时间转换
- (NSString *)getTimeWithseconds:(CGFloat)seconds
{
    // 小时
    NSInteger hour = floor(seconds / 3600);
    
    // 分钟
    NSInteger minutes = floor((seconds - hour * 3600) / 60);
    // seconds
    CGFloat s = seconds - hour * 3600 - minutes * 60;
    NSString *time = [NSString stringWithFormat:@"%ld:%.0f", (long)minutes, s];
    return time;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)getPhoto:(NSString *)name type:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
