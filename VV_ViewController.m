//
//  VV_ViewController.m
//  CCMV
//
//  Created by zd on 15/4/14.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "VV_ViewController.h"
#import "CustomLabel.h"
#import "UIColor+info.h"
#import "VV_Model.h"
#import "VVVV_Model.h"
#import "VVViewCell.h"
#import "WebRequest.h"
#import "MJRefresh.h"
#import "CustomView.h"

#import "VideoPlayController.h"




@interface VV_ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)NSMutableDictionary *modelDic;//数据外层字典
@property(nonatomic,strong)NSMutableArray *modelArray;// 数据里层数组
@property(nonatomic,strong)NSMutableDictionary *urlDic;// 拼接网址的字典
@property(nonatomic,strong)NSArray *scrollArray; // 装scrollView名头的数组
@property(nonatomic,strong)NSArray *areaArray; // 拼接地区的数组

@property(nonatomic,assign)NSInteger pageCount; // 从第几个数据开始请求
@property(nonatomic,assign)NSInteger allCount;// 总共多少条数据

@property(nonatomic,assign)NSInteger nowPage;
@property(nonatomic,assign)NSInteger frontPage;

@property (nonatomic, strong)VV_Model *vv_Model;

@end

@implementation VV_ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
        self.modelDic = [NSMutableDictionary dictionary]; // 数据外层字典
        self.modelArray = [NSMutableArray array];          // 数据里层数组
        self.urlDic =[NSMutableDictionary dictionary];      // 拼接网址的字典
        [_urlDic setObject:@"ML" forKey:@"area"];  // 这条属性在初始化中添加,因为当我改变偏移量时要修改这个属性. 如果放在网络请求中,就每次不管添加什么,只开开始网路请求,就变成了默认的 ALL
        
        self.pageCount = 0;  // 从第几个数据开始请求
        
        self.allCount = 20;  // 总共请求多少条数据
        
        self.scrollArray = [NSArray arrayWithObjects:@"欧美篇",@"韩国篇",@"日本篇",@"内地篇",@"港台篇",@"欧美篇",@"韩国篇",@"日本篇",@"内地篇",@"港台篇",@"欧美篇",nil];
        
        self.nowPage = 4;
        
        self.frontPage = 4;
        
        self.areaArray = [NSArray arrayWithObjects:@"ML",@"HT", @"US",@"KR",@"JP",nil]; // 放地区参数的数组
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    // 这个属性,scrollView禁止上下滚动
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    [navView setBackgroundColor:[UIColor blackColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *menuImage = [UIImage imageNamed:@"menu.png"];
    UIImage *rendMenuImage = [menuImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [button addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:rendMenuImage forState:UIControlStateNormal];
    [button setFrame:CGRectMake(15, 30, 30, 30)];
    
    
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [searchButton setFrame:CGRectMake(self.view.frame.size.width - 45, 30, 30, 30)];
    [searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *searchImage = [UIImage imageNamed:@"search.png"];
    UIImage *rendSearchImage2 = [searchImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [searchButton setImage:rendSearchImage2 forState:UIControlStateNormal];
    
    [navView addSubview:searchButton];
    
    [navView addSubview:button];
    
    [self.view addSubview:navView];
    
    self.view.clipsToBounds = YES;
    
    CustomLabel *customLabel = [CustomLabel customLabelWithFrame:CGRectMake(self.view.frame.size.width/2 - 20, 35, 40, 40) text:@"打榜" fontName:@"HelveticaNeue-UltraLight" fontSize:20];
    [navView addSubview:customLabel];
    [customLabel setTextColor:[UIColor whiteColor]];
    [customLabel sizeToFit];
    
    [self createDownImageView];
    
    [self createScrollView];
    
    [self createTableView];
    
//    [self beginConnect];
    
    [self startRefresh];
    
}



- (void)createDownImageView
{
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zd2.png"]];
    [imageView2 setFrame:CGRectMake(0, 94, self.view.frame.size.width, 6)];
    [self.view addSubview:imageView2];
    
}




- (void)createScrollView
{
    CustomView *customView = [[CustomView alloc]init];
    [customView setFrame:CGRectMake(0, 60, self.view.frame.size.width, 40)];
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(customView.frame.size.width / 8 * 3, 0, customView.frame.size.width / 4, 40)];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.scrollArray.count, 0);//幕布大小
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.clipsToBounds = NO; // 原先超出部分不显示--设为NO
    
    self.scrollView.showsHorizontalScrollIndicator = NO;//取消水平滑动提示
    self.scrollView.delegate = self;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 3 + 1, 0)];
    
    
    for(int i = 0; i < self.scrollArray.count; i ++){
        
        // for循环中不能用属性
        UIButton *scrollButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [scrollButton setFrame:CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(areaButtonAction:)];
        
        [scrollButton addGestureRecognizer:tapGesture];
        
        [scrollButton setTitleColor:[UIColor colorWithHexString:@"33ffcc"] forState:UIControlStateNormal];
        
        [scrollButton setTitle:[self.scrollArray objectAtIndex:i] forState:UIControlStateNormal];
    
        [self.scrollView addSubview:scrollButton];
    
    }
    
    [customView addSubview:self.scrollView];
    [self.view addSubview:customView];
    
}



// scrollView上按钮的点击事件
- (void)areaButtonAction:(id)sender
{
    
}

- (void)leftButtonAction:(id)sender
{
    self.block();
}

- (void)searchAction:(id)sender
{
    self.block2();
}




// scrollView的协议-- 做两件事
// 1.当停止滚动时,找到框中Button,改变颜色
// 2.循环滚动

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 判断是哪个scrollView,因为tableView也继承与ScrollVIew,如果不加判断会导致tableView和ScrollView都执行这个协议方法
    if(scrollView == self.scrollView){
        
        CGPoint offSetPoint = self.scrollView.contentOffset;// 偏移量
        CGFloat width = self.scrollView.frame.size.width;//scrollView大小
        
        self.nowPage = offSetPoint.x / width + 1;
        

        
        if (offSetPoint.x < width *2.5 &&offSetPoint.x > width * 1.5)
        {
            [scrollView setContentOffset:CGPointMake(width * 7, 0) animated:NO];
            self.nowPage = 8;
            
        }
        else if (offSetPoint.x < width *1.5 && offSetPoint.x > width * 0.5){
            [scrollView setContentOffset:CGPointMake(width * 6, 0) animated:NO];
            self.nowPage = 7;
        }
        
        
        if (offSetPoint.x < width * 8.5 && offSetPoint.x > width * 7.5)
        {
            [scrollView setContentOffset:CGPointMake(width * 3, 0) animated:NO];
            self.nowPage = 4;
        }
        else if (offSetPoint.x < width * 9.5 && offSetPoint.x > width * 8.5){
            [scrollView setContentOffset:CGPointMake(width * 4, 0) animated:NO];
            self.nowPage = 5;
        }
        
        
        if(self.nowPage == 9){
            [self setNowPage:4];
        }
        if(self.nowPage == 3){
            [self setNowPage:8];
        }
        [_urlDic setObject:[_areaArray objectAtIndex:self.nowPage-4] forKey:@"area"];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == self.scrollView) {
        
        if (self.nowPage != self.frontPage) {
            
            [self beginConnect];
        }
        self.frontPage = _nowPage;
    }
}




- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 106, self.view.frame.size.width, self.view.frame.size.height - 64 - 40) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vv_Model.videos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *pool = @"name1";
    
    VVViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pool];
    
    if(!cell){
        cell = [[VVViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:pool];
    }
    
    if(self.vv_Model.videos.count > indexPath.row){
        
        VVVV_Model *vvvvModel = self.vv_Model.videos[indexPath.row];
        
        NSInteger Nummm = indexPath.row + 1;
        
        NSString *Numm = [NSString stringWithFormat:@"%ld",(long)Nummm];
        
        vvvvModel.num = Numm;
        
        [cell setAllValues:vvvvModel];
        
        
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (tableView.frame.size.height + 64) / 13 * 3;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.videoPlayState) {
        return;
    }
    self.videoPlayerBlock();
    
    VideoPlayController *videoPlayController = self.viewController;
    
    
    
    VVVV_Model *model = [self.vv_Model.videos objectAtIndex:indexPath.row];
    
    videoPlayController.idNum = model.albumId;
    
    [videoPlayController startConnect];
    self.videoPlayState = YES;
}









- (void)beginConnect
{
    
    NSLog(@"这是V榜页面的网络请求");
    // 把视图添加到block层,下面的移除才好用.否则下面的移除,移除的只是这个view的赋值品.不会真正移除这个视图. 这个视图是在网络请求的时候防止我们继续拖动scrollVIew或继续进行网络请求的.
    __block UIView *clearView = [[UIView alloc]initWithFrame:CGRectMake(0, -40, self.tableView.frame.size.width, self.tableView.frame.size.height + 40)];
    [self.view addSubview:clearView];
    
    //http://mapi.yinyuetai.com/vchart/trend.json?D-A=0&area=KR&date=true&offset=0&size=2
    
    
    NSString *page_count = [NSString stringWithFormat:@"%ld",(long)self.pageCount];
    NSString *all_count = [NSString stringWithFormat:@"%ld",(long)self.allCount];
    [_urlDic setObject:@"0" forKey:@"D-A"];
    [_urlDic setObject:@"true" forKey:@"date"];
    [_urlDic setObject:page_count forKey:@"offset"];
    [_urlDic setObject:all_count forKey:@"size"];
    
    [WebRequest connectWithUrl:VBang parmater:_urlDic requestHeader:RequestHeader httpMethod:@"GET" view:self.view block:^(id data) {
        
        if(data){
            
            [self.modelArray removeAllObjects];
        
            NSDictionary *bigDic = (NSDictionary *)data;
            
            self.vv_Model = [[VV_Model alloc]initWithDictionary:bigDic];
            }
            
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            
            [clearView removeFromSuperview];
        
    } refresh:^{
        
        [clearView removeFromSuperview];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self beginConnect];
        });
    }];
}



- (void)startRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
}


- (void)headerRefresh
{
    [self.modelArray removeAllObjects];
    [self beginConnect];
}

- (void)footerRefresh
{
    [self.modelArray removeAllObjects];
    self.allCount += 10;
    [self beginConnect];
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
