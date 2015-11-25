//
//  ChannelDetailController.m
//  CCMV
//
//  Created by zd on 15/4/19.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "ChannelDetailController.h"
#import "UIImageView+WebCache.h"
#import "ChannelDetailViewCell.h"
#import "ChannelDetailModel.h"
#import "MJRefresh.h"
#import "WebRequest.h"

#import "VideoPlayController.h"

@interface ChannelDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,strong)NSMutableDictionary *urlDic;
@property(nonatomic,assign)NSInteger pageCount;
@property(nonatomic,assign)NSInteger allCount;




@property(nonatomic,strong)UITableView *tableView;


@end

@implementation ChannelDetailController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.modelArray = [NSMutableArray array];
        self.urlDic = [NSMutableDictionary dictionary];
        self.pageCount = 0;
        self.allCount = 20;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor blackColor]];
    

    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [navView setBackgroundColor:[UIColor blackColor]];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnButton setFrame:CGRectMake(15, 25, 30, 30)];
    [returnButton setImage:[UIImage imageNamed:@"returnButton.png"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:returnButton];
    [self.view addSubview:navView];
    
    self.titleLabel = [[UILabel alloc]init];
    [self.titleLabel setFrame:CGRectMake(0, 0, 100, 40)];
    self.titleLabel.center = CGPointMake(navView.center.x+ 10, navView.center.y + 10);
    self.titleLabel.textColor = [UIColor whiteColor];
    [navView addSubview:self.titleLabel];
    
    [self createTableView];
    
    [self startRefresh];

}

- (void)returnAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(returnFromChannelDetailViewController)]){
        [self.delegate returnFromChannelDetailViewController];
    }
}


- (void)startConnect
{
    
    
    NSLog(@"这是频道详情页面的网络请求");
//    http://mapi.yinyuetai.com/channel/videos.json?D-A=0&channelId=82&detail=true&offset=0&order=VideoPubDate&size=20
    
    NSString *page_count = [NSString stringWithFormat:@"%ld",(long)self.pageCount];
    NSString *all_count = [NSString stringWithFormat:@"%ld",(long)self.allCount];
    [_urlDic setObject:@"0" forKey:@"D-A"];
    [_urlDic setObject:self.idNum forKey:@"channelId"];
    [_urlDic setObject:@"true" forKey:@"detail"];
    [_urlDic setObject:page_count forKey:@"offset"];
    [_urlDic setObject:all_count forKey:@"size"];
    [_urlDic setObject:@"VideoPubDate" forKey:@"order"];
    
    [WebRequest connectWithUrl:ChannelDetail parmater:_urlDic requestHeader:RequestHeader httpMethod:@"GET" view:self.tableView block:^(id data) {
        
        if(data){
            
            [self.modelArray removeAllObjects];
            
            NSDictionary *bigDic = (NSDictionary *)data;
            NSArray *bigArray = [bigDic objectForKey:@"videos"];
            for (NSDictionary *dic in bigArray) {
               
                ChannelDetailModel *channelDetailModel = [[ChannelDetailModel alloc]init];
                
                [channelDetailModel setValuesForKeysWithDictionary:dic];
                
                [self.modelArray addObject:channelDetailModel];
            }

            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
        }
        
    } refresh:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startConnect];
        });

    }];
    
}




- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor grayColor];
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
    
    ChannelDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pool];
    if(!cell){
        cell = [[ChannelDetailViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:pool];
    }
    
    if(self.modelArray.count > indexPath.row){
        ChannelDetailModel *channelDetailModel = [_modelArray objectAtIndex:indexPath.row];
        [cell setAllValues:channelDetailModel];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.frame.size.height / 7;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.videoPlayState) {
        return;
    }
    self.videoPlayerBlock();
    
    VideoPlayController *videoPlayController = self.viewController;
    
    ChannelDetailModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    videoPlayController.idNum = model.albumId;
    
    [videoPlayController startConnect];
    self.videoPlayState = YES;
}











- (void)startRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
}


- (void)headerRefresh
{
    [self.modelArray removeAllObjects];
    [self startConnect];
}

- (void)footerRefresh
{
    [self.modelArray removeAllObjects];
    self.allCount += 10;
    [self startConnect];
    
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
