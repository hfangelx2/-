//
//  RecommendViewController.m
//  CCMV
//
//  Created by zd on 15/4/10.
//  Copyright (c) 2015年 zd. All rights reserved.
//


#import "RecommendViewController.h"
#import "CustomLabel.h"
#import "UIColor+info.h"
#import "RecommenViewCell.h"
#import "RecommenModel.h"
#import "WebRequest.h"
#import "MJRefresh.h"

#import "VideoPlayController.h"


@interface RecommendViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,strong)NSMutableDictionary *urlDic;

@end

@implementation RecommendViewController

// 视图初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.modelArray = [NSMutableArray array];
        self.urlDic = [NSMutableDictionary dictionary];
        [_urlDic setObject:@"0" forKey:@"D-A"];
        [_urlDic setObject:@"0" forKey:@"offset"];
        [_urlDic setObject:@"false" forKey:@"play"];
        [_urlDic setObject:@"640*540" forKey:@"rn"];
        [_urlDic setObject:@"10" forKey:@"size"];
        
        }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    

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
    
    //     给导航栏上放自定义label
    CustomLabel *customLabel = [CustomLabel customLabelWithFrame:CGRectMake(0, 6, 100, 44) text:@"首页" fontName:@"HelveticaNeue-UltraLight" fontSize:20];
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


- (void)beginConnect
{
    NSLog(@"我们推荐页面的网络请求");
    
    [WebRequest connectWithUrl:Officicl parmater:_urlDic requestHeader:RequestHeader httpMethod:@"GET" view:self.view block:^(id data) {
        
        if(data){
            [self.modelArray removeAllObjects];
            
            NSArray *array = (NSArray *)data;
            for (NSDictionary *dic in array) {
                RecommenModel *recomentModel = [[RecommenModel alloc]init];
                [recomentModel setValuesForKeysWithDictionary:dic];
                
                if(![recomentModel.type isEqualToString:@"PLAYLIST"] && ![recomentModel.type isEqualToString:@"ACTIVITY"]){
                    [self.modelArray addObject:recomentModel];
                }
            }
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
        }
        //你用的AFNetWorking,解析为,没有问题,我们用model就是为了避开for(NSdictionary *dic in array)这样的语句,但你这样写没有问题,我刚才给你说的是规范的model嵌套,层数多了以后就会循环套循环,在其他页面就不容易取到值,哦了,我走了,和你媳妇好好的!
        
    } refresh:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self beginConnect];
            
        });
    }];
}



- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
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
    
    RecommenViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pool];
    
    if(!cell){
        cell = [[RecommenViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:pool];

    }
    
// 给数组加保护 确保返回的数据条数 大于cell的个数 否则cell娶不到数组中的数据 就越界了
    if(self.modelArray.count > indexPath.row){
    RecommenModel *recommentModel = [_modelArray objectAtIndex:indexPath.row];
    [cell setAllValues:recommentModel];
    
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (tableView.frame.size.height + 64) / 40 * 19;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.videoPlayState) {
        return;
    }
    self.videoPlayerBlock();
    
    VideoPlayController *videoPlayController = self.viewController;
    
    RecommenModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    videoPlayController.idNum = model.albumId;
    
    [videoPlayController startConnect];
    self.videoPlayState = YES;
}






- (void)startRefresh{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    
}

- (void)headerRefresh{
    [self.modelArray removeAllObjects];
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
