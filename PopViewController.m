//
//  PopViewController.m
//  CCMV
//
//  Created by zd on 15/4/10.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "PopViewController.h"
#import "CustomLabel.h"
#import "UIColor+info.h"
#import "PopModel.h"
#import "PopViewCell.h"
#import "WebRequest.h"
#import "MJRefresh.h"
#import "CustomView.h" // 这是一个点穿的视图,可以给scrollView两边添加点透方法,也可以给tableView上面盖的黑色视图添加点穿
#import "VideoPlayController.h"




@interface PopViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)NSMutableDictionary *modelDic;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,strong)NSMutableDictionary *urlDic;

@property(nonatomic,assign)NSInteger pageCount;
@property(nonatomic,assign)NSInteger allCount;

@property(nonatomic,strong)NSArray *scrollArray;

@property(nonatomic,assign)NSInteger nowPage;

@property(nonatomic,assign)NSInteger frontPage;

@property(nonatomic,strong)NSArray *areaArray;


@end

@implementation PopViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.modelDic = [NSMutableDictionary dictionary]; // 数据外层字典
        self.modelArray = [NSMutableArray array];          // 数据里层数组
        self.urlDic =[NSMutableDictionary dictionary];      // 拼接网址的字典
        [_urlDic setObject:@"DAYVIEW_ALL" forKey:@"area"];  // 这条属性在初始化中添加,因为当我改变偏移量时要修改这个属性. 如果放在网络请求中,就每次不管添加什么,只开开始网路请求,就变成了默认的 ALL
        
        self.pageCount = 0;  // 从第几个数据开始请求
        
        self.allCount = 10;  // 总共请求多少条数据
        
        self.scrollArray = [NSArray arrayWithObjects:@"欧美",@"韩国",@"日本",@"全部",@"内地",@"港台",@"欧美",@"韩国",@"日本",@"全部",@"内地",@"港台",nil];
        
        self.nowPage = 4;
        
        self.frontPage = 4;
        
        self.areaArray = [NSArray arrayWithObjects:@"POP_ALL",@"POP_ML",@"POP_HT", @"POP_US",@"POP_KR",@"POP_JP",nil]; // 放地区参数的数组
        
    }
    return self;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO]; // 这个属性 设置scrollView禁止上下滚动
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //设置左上按钮
    UIImage *menuImage = [UIImage imageNamed:@"menu.png"];
    UIImage *rendMenuImage = [menuImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:rendMenuImage style:UIBarButtonItemStyleDone target:self action:@selector(leftAction:)];
    
    // 设置右上按钮
    UIImage *searchImage = [UIImage imageNamed:@"search.png"];
    UIImage *rendSearchImage = [searchImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:rendSearchImage style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonAction:)];
    
    
    // 设置导航栏
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"首页";
    
    
    //     给导航栏上放自定义label
    CustomLabel *customLabel = [CustomLabel customLabelWithFrame:CGRectMake(0, 0, 100, 44) text:@"首页" fontName:@"HelveticaNeue-UltraLight" fontSize:20];
    self.navigationItem.titleView = customLabel;
    [customLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
    [customLabel sizeToFit];
    
    [self createDownImageView];
    
    [self createScrollView];
    
    [self createTableView];
    
    [self beginConnect];
    
    [self startRefresh];
    
}



- (void)createDownImageView
{
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zd2.png"]];
    [imageView2 setFrame:CGRectMake(0, 34, self.view.frame.size.width, 6)];
    [self.view addSubview:imageView2];
    
}



- (void)createScrollView
{
    self.scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 8 * 3, 0, self.view.frame.size.width /4, 40)];
    
    //    NSLog(@"%@",NSStringFromCGRect(self.scrollView.frame));
    // 这种方式可以输出结构体
    
    self.scrollView.contentSize= CGSizeMake(self.scrollView.frame.size.width * self.scrollArray.count, 0); // 幕布大小
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor= [UIColor clearColor];
    self.scrollView.clipsToBounds = NO; // 让scroll以外,contentSize以内的都显示
    self.scrollView.showsHorizontalScrollIndicator = NO;// 取消水平滑动提示条
    self.scrollView.delegate = self;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 3 + 1, 0) animated:NO];
    
    
    for (int i = 0; i < self.scrollArray.count; i ++) {
        
        // for循环中不能用属性
        UIButton *scrollButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [scrollButton setFrame:CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areaButtonAction:)];
        
        [scrollButton addGestureRecognizer:tapGesture];
        [scrollButton setTitleColor:[UIColor colorWithHexString:@"33ffcc"] forState:UIControlStateNormal];
        [scrollButton setTitle:[self.scrollArray objectAtIndex:i] forState:UIControlStateNormal];
        
        [self.scrollView addSubview:scrollButton];
    }
    
    
    // scroll下面放一层点透视图. 这样,点scroll以外的就也能滑动了
    CustomView *customView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [customView addSubview:self.scrollView];
    [self.view addSubview:customView];
    
}

// scrollView的协议--做两件事
// 1.当滚动停止时,找到框中Button,改变颜色.
// 2.循环滚动


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    
    if (scrollView == self.scrollView) {
        
        CGPoint offSetPoint = self.scrollView.contentOffset;// 偏移量
        CGFloat width = self.scrollView.frame.size.width; // scroll大小
        
        self.nowPage = offSetPoint.x / width + 1;
        
        
        if (offSetPoint.x < width *2.5 &&offSetPoint.x > width * 1.5)
        {
            [scrollView setContentOffset:CGPointMake(width * 8, 0) animated:NO];
            self.nowPage = 9;
            
        }
        else if (offSetPoint.x < width *1.5 && offSetPoint.x > width * 0.5){
            [scrollView setContentOffset:CGPointMake(width * 7, 0) animated:NO];
            self.nowPage = 8;
        }
        
        
        if (offSetPoint.x < width * 9.5 && offSetPoint.x > width * 8.5)
        {
            [scrollView setContentOffset:CGPointMake(width * 3, 0) animated:NO];
            self.nowPage = 4;
        }
        else if (offSetPoint.x < width * 10.5 && offSetPoint.x > width * 9.5){
            [scrollView setContentOffset:CGPointMake(width * 4, 0) animated:NO];
            self.nowPage = 5;
        }
        
        
        if(self.nowPage == 10){
            [self setNowPage:4];
        }
        if(self.nowPage == 3){
            [self setNowPage:9];
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



// scrollView上按钮的点击事件
- (void)areaButtonAction:(id)sender
{
    
}

- (void)leftAction:(id)sender
{
    self.block();
}

- (void)rightButtonAction:(id)sender
{
    self.block2();
}





- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 64  - 40) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *pool = @"name1";
    
    PopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pool];
    
    if(!cell){
        cell = [[PopViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:pool];
    }

    
    // 给数组加保护 确保返回的数据条数 大于cell的个数 否则cell娶不到数组中的数据 就越界了
    if(self.modelArray.count > indexPath.row){
        PopModel *popModel = [_modelArray objectAtIndex:indexPath.row];
        [cell setAllValues:popModel];
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
    
    PopModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    videoPlayController.idNum = model.albumId;
    
    [videoPlayController startConnect];
    self.videoPlayState = YES;
}









- (void)beginConnect
{
    NSLog(@"正在流行页面的网络请求");
    
    // 把视图添加到block层,下面的移除才好用.否则下面的移除,移除的只是这个view的赋值品.不会真正移除这个视图
    // 加这个视图是为在网络请求期间(也就是风火轮在转的期间),scrollView不能滑动.
    __block UIView *clearView = [[UIView alloc]initWithFrame:CGRectMake(0, -40, self.tableView.frame.size.width, self.tableView.frame.size.height + 40)];
    [self.view addSubview:clearView];
    
    
    NSString *page_count = [NSString stringWithFormat:@"%ld",(long)self.pageCount];
    NSString *all_count = [NSString stringWithFormat:@"%ld",(long)self.allCount];
    [_urlDic setObject:@"0" forKey:@"D-A"];
    [_urlDic setObject:@"true" forKey:@"date"];
    [_urlDic setObject:page_count forKey:@"offset"];
    [_urlDic setObject:all_count forKey:@"size"];
    
    
    [WebRequest connectWithUrl:Today parmater:_urlDic requestHeader:RequestHeader httpMethod:@"GET" view:self.view block:^(id data) {
        
        if(data){
            
            [self.modelArray removeAllObjects];
            
            NSDictionary *bigDic = (NSDictionary *)data;
            for (NSDictionary *dic in [bigDic objectForKey:@"videos"]) {
                PopModel *popModel = [[PopModel alloc]init];
                [popModel setValuesForKeysWithDictionary:dic];
                [self.modelArray addObject:popModel];
            }
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            
            // 请求完(也就是风火轮转完)移除阻止点击全屏的视图
            [clearView removeFromSuperview];
        }
        
        
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
