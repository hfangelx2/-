//
//  SearchViewController.m
//  CCMV
//
//  Created by zd on 15/4/14.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "SearchViewController.h"
#import "WebRequest.h"
#import "UIColor+info.h"
#import "UIImageView+WebCache.h"
#import "SearchViewCell.h"
#import "SearchModel.h"
#import "MJRefresh.h"

#import "VideoPlayController.h"


@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@end




@implementation SearchViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.urlDic = [NSMutableDictionary dictionary];
        self.modelArray = [NSMutableArray array];
        self.pageCount = 0;
        self.allCount = 20;

        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [navView setBackgroundColor:[UIColor blackColor]];
 
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnButton setFrame:CGRectMake(15, 30, 30, 30)];
    [returnButton setImage:[UIImage imageNamed:@"returnButton.png"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:returnButton];
    [self.view addSubview:navView];
    
    self.titleLabel = [[UILabel alloc]init];
    [self.titleLabel setFrame:CGRectMake(0, 0, 100, 40)];
    self.titleLabel.center = CGPointMake(navView.center.x+ 30 , navView.center.y + 15);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"搜索";
    [navView addSubview:self.titleLabel];

    
    
    [self createSearchBar];
    
    [self createButtonView];
    
    [self createTableView];
    self.tableView.alpha = 0;
    self.tableView.userInteractionEnabled = NO;
    
    [self startRefresh];


}

- (void)returnAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(returnFromSearchViewController)]){
        [self.delegate returnFromSearchViewController];
    }
}



- (void)createSearchBar
{
    // 创建搜索条背景
    self.searchBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 60)];
    [self.searchBarView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.searchBarView];
    
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 10, self.searchBarView.frame.size.width - 20, 40)];
    self.searchBar.delegate = self;
    [self.searchBar setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar setPlaceholder:@"喜欢看什么"];
    [self.searchBar setBarStyle:UIBarStyleDefault];
    [self.searchBar.layer setMasksToBounds:YES];
    self.searchBar.layer.cornerRadius = 5;
    
    [self.searchBarView addSubview:self.searchBar];
}


- (void)createButtonView
{
    self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 124, self.view.frame.size.width, self.view.frame.size.height - 124)];
    [self.buttonView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.buttonView];
    
    UILabel *hotSearchLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 40)];
    [hotSearchLabel setText:@"热门搜索"];
    [hotSearchLabel setBackgroundColor:[UIColor clearColor]];
    hotSearchLabel.textColor = [UIColor blackColor];
    [self.buttonView addSubview:hotSearchLabel];
    
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width,self.view.frame.size.height - 80)];
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
    
    SearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pool];
    if(!cell){
        cell = [[SearchViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:pool];
    }
    
    if(self.modelArray.count > indexPath.row){
        SearchModel *searchModel = [_modelArray objectAtIndex:indexPath.row];
        [cell setAllValues:searchModel];
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.frame.size.height / 6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.searchBar resignFirstResponder];
    
    if (self.videoPlayState) {
        return;
    }
    self.videoPlayerBlock();
    
    VideoPlayController *videoPlayController = self.viewController;
    
    SearchModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    videoPlayController.idNum = model.albumId;
    
    [videoPlayController startConnect];
    self.videoPlayState = YES;
}






- (void)startConnect
{
    NSLog(@"这是搜索页面的1号网络请求");
    
    [_urlDic removeAllObjects];
    
    [WebRequest connectWithUrl:SearchTop parmater:_urlDic requestHeader:RequestHeader httpMethod:@"GET" view:self.view block:^(id data) {
        if(data){
                
                NSArray *array = (NSArray *)data;
                
                for(int i = 0; i < array.count; i ++){
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                    [button setBackgroundColor:[UIColor colorWithHexString:@"ffff99"]];
                    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(recommendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    button.layer.masksToBounds = YES;
                    button.layer.cornerRadius = 10;
                    
                    NSDictionary *strAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
                    NSString *value = [array objectAtIndex:i];
                    CGFloat height = 40;
                    CGRect strRect = [value boundingRectWithSize:CGSizeMake(10000, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:strAtt context:nil];
                    
                    CGFloat allHeight;
                    if(i == 0 || i == 4 || i == 8 || i == 12 || i == 16){
                        allHeight = 0;
                        
                        [button setFrame:CGRectMake( allHeight + 20, (i / 4) * 50 + 40, strRect.size.width+5,30 )];
                        
                        allHeight += strRect.size.width;
                        
                    }else{
                        
                        [button setFrame:CGRectMake( allHeight + ((i+3)%4+2)* 20, (i / 4) * 50 + 40, strRect.size.width+5,30 )];
                        
                        allHeight = strRect.size.width + allHeight ;
                    }
                    button.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 3);
                    [self.buttonView addSubview:button];
                }
        }
        
    } refresh:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self startConnect];
        });
        
    }];
}



- (void)recommendButtonAction:(UIButton *)sender
{
    
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self.searchBarView setFrame:CGRectMake(0, 20, self.view.frame.size.width, 60)];
    [self.searchBarView.superview bringSubviewToFront:self.searchBarView];
    
    self.tableView.alpha = 1;
    self.tableView.userInteractionEnabled = YES;
    self.buttonView.alpha = 0;
    self.buttonView.userInteractionEnabled = NO;
    
    [self.tableView.superview bringSubviewToFront:self.tableView];

    [self.searchBar setShowsCancelButton:YES animated:NO];
    
    
    NSString *keyWord = sender.titleLabel.text;
    // 把汉字转为可搜索编码
    keyWord = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)keyWord, NULL, NULL, kCFStringEncodingUTF8));
    
    [_urlDic setObject:keyWord forKey:@"keyword"];
    
    self.searchBar.text = sender.titleLabel.text;
    
    [self startConnect2];

}



- (void)startConnect2
{
    NSLog(@"这是搜索页面的2号网络请求");
    
    // http://mapi.yinyuetai.com/search/video.json?D-A=0&keyword=%E4%BD%A0&offset=0&size=20
    
    
    NSString *page_count = [NSString stringWithFormat:@"%ld",(long)self.pageCount];
    NSString *all_count = [NSString stringWithFormat:@"%ld",(long)self.allCount];
    [_urlDic setObject:@"0" forKey:@"D-A"];
    [_urlDic setObject:page_count forKey:@"offset"];
    [_urlDic setObject:all_count forKey:@"size"];
    
    [WebRequest connectWithUrl:SearchTable parmater:_urlDic requestHeader:RequestHeader httpMethod:@"GET" view:self.view block:^(id data) {
        
        if(data){
            
            [self.modelArray removeAllObjects];
            
            NSDictionary *bigDic = (NSDictionary *)data;
            NSArray *bigArray = [bigDic objectForKey:@"videos"];
            for (NSDictionary *dic in bigArray) {
                
                SearchModel *searchModel = [[SearchModel alloc]init];
                
                [searchModel setValuesForKeysWithDictionary:dic];
                
                [self.modelArray addObject:searchModel];
            }
            
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];

        }
        
    } refresh:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startConnect2];
        });
        
    }];

}








// 搜索栏处于被编辑状态 执行的方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
        [self.searchBar setShowsCancelButton:YES animated:YES];
        [self.searchBarView setFrame:CGRectMake(0, 20, self.view.frame.size.width, 60)];
        [self.searchBarView.superview bringSubviewToFront:self.searchBarView];
        self.searchBar.text = @"";
    
        self.buttonView.alpha = 0;
        self.buttonView.userInteractionEnabled = NO;
    
        [self startConnect2];
    self.tableView.alpha = 1;
    self.tableView.userInteractionEnabled = YES;
    self.buttonView.alpha = 0;
    self.buttonView.userInteractionEnabled = NO;
    
        [self.tableView.superview bringSubviewToFront:self.tableView];
    
    return YES;
}

// 取消按钮被按下 执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

    [self.searchBarView setFrame:CGRectMake(0, 64, self.view.frame.size.width, 60)];
        [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    self.tableView.alpha = 0;
    self.tableView.userInteractionEnabled = NO;
    self.buttonView.alpha = 1;
    self.buttonView.userInteractionEnabled = YES;
    
}

// 修改搜索框的返回钮字体
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    for(id cc in [self.searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"返回" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //http://mapi.yinyuetai.com/search/video.json?D-A=0&keyword=super&offset=0&size=20
    
    [self.modelArray removeAllObjects];
    
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:YES animated:NO];
    
    
    NSString *keyWord = self.searchBar.text;
    // 把汉字转为可搜索编码
    keyWord = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)keyWord, NULL, NULL, kCFStringEncodingUTF8));
    
    [_urlDic setObject:keyWord forKey:@"keyword"];
    
    [self startConnect2];
    
    
}

// 搜索栏汉字改变时执行的方法
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    [self.modelArray removeAllObjects];
    
    NSString *keyWord = searchText;
    // 把汉字转为可搜索编码
    keyWord = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)keyWord, NULL, NULL, kCFStringEncodingUTF8));
    
    [_urlDic setObject:keyWord forKey:@"keyword"];
    
    [self startConnect2];
    
}



- (void)startRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
}
- (void)footerRefresh
{
    [self.modelArray removeAllObjects];
    self.allCount += 10;
    [self startConnect2];
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
