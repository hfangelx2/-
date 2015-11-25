//
//  ULikeViewController.m
//  CCMV
//
//  Created by zd on 15/4/10.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "ULikeViewController.h"
#import "CustomLabel.h"
#import "UIColor+info.h"
#import "ULikeModel.h"
#import "ULikeViewCell.h"
#import "WebRequest.h"
#import "MJRefresh.h"

#import "VideoPlayController.h"


@interface ULikeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,strong)NSMutableDictionary *urlDic;

@property(nonatomic,assign)NSInteger pageCount;
@property(nonatomic,assign)NSInteger allCount;

@end

@implementation ULikeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.modelArray = [NSMutableArray array];
        self.pageCount = 0;
        self.allCount = 10;
        self.urlDic = [NSMutableDictionary dictionary];
        
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor cyanColor]];
    
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

    
    [self createTableView];
    
    [self beginConnect];
    
    [self startRefresh];
    
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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
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
    
    ULikeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pool];
    
    if(!cell){
        cell = [[ULikeViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:pool];
    }
    
    // 给数组加保护 确保返回的数据条数 大于cell的个数 否则cell娶不到数组中的数据 就越界了
    if(self.modelArray.count > indexPath.row){
    ULikeModel *uLileModel = [_modelArray objectAtIndex:indexPath.row];
    [cell setAllValues:uLileModel];
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
    
    ULikeModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    videoPlayController.idNum = model.albumId;
    
    [videoPlayController startConnect];
    self.videoPlayState = YES;
}








- (void)beginConnect
{
    NSLog(@"猜你喜欢页面的网络请求");
    
    NSString *page_count = [NSString stringWithFormat:@"%ld",(long)self.pageCount];
    NSString *all_count = [NSString stringWithFormat:@"%ld",(long)self.allCount];
    
    [_urlDic setObject:@"0" forKey:@"D-A"];
    [_urlDic setObject:page_count forKey:@"offset"];
    [_urlDic setObject:all_count forKey:@"size"];
    
    
    
    [WebRequest connectWithUrl:GuessYou parmater:_urlDic requestHeader:RequestHeader httpMethod:@"GET" view:self.view block:^(id data) {
        if(data){
            
            [self.modelArray removeAllObjects];
            
            NSArray *array = (NSArray *)data;
            for (NSDictionary *dic in array) {
                ULikeModel *uLikeModel = [[ULikeModel alloc]init];
                [uLikeModel setValuesForKeysWithDictionary:dic];
                [self.modelArray addObject:uLikeModel];
            }
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
        }
        
        
    } refresh:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
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
