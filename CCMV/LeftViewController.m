//
//  LeftViewController.m
//  CCMV
//
//  Created by zd on 15/4/10.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "LeftViewController.h"
#import "UIColor+info.h"
#import "SetUpViewController.h"
#import "ChannelViewController.h"



@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *customTableView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIView *footView;
@property(nonatomic,strong)NSArray *array;



@end

@implementation LeftViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
//        self.array = [NSArray arrayWithObjects:@"首页",@"频道",@"v榜",@"下载管理",@"播放历史", nil];
        self.array = [NSArray arrayWithObjects:@"首页",@"频道",@"打榜", nil];
;
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    
    [self createTableView];

}



- (void)createTableView
{
    self.customTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 100) style:UITableViewStyleGrouped];
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    
    self.customTableView.backgroundColor = [UIColor clearColor];
    self.customTableView.separatorStyle = UITableViewCellSelectionStyleDefault;
    self.customTableView.scrollEnabled = NO;

    
    [self createHeadView];
    [self createFootView];
    
    [self.customTableView setTableHeaderView:self.headView];
//    [self.customTableView setTableFooterView:self.footView];
    
    [self.view addSubview:self.customTableView];
}


- (void)createHeadView
{
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 5)];
    self.headView.backgroundColor = [UIColor grayColor];
    self.headView.alpha = 0.4;
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.headView.frame.size.width / 19, self.headView.frame.size.height / 4, self.headView.frame.size.height / 2, self.headView.frame.size.height / 2)];
    
    [_headView addSubview:headImageView];
}


- (void)createFootView
{
    self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [self.footView setBackgroundColor:[UIColor grayColor]];
    self.footView.alpha = 0.4;
    
    UIButton *setupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setupButton setFrame:CGRectMake(10, 10, 30, 30)];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"setup11" ofType:@"png"];
    UIImage *setupImage = [UIImage imageNamed:path];
    UIImage *setupImage2 = [setupImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [setupButton setImage:setupImage2 forState:UIControlStateNormal];

    [setupButton addTarget:self action:@selector(setupButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [self.footView addSubview:setupButton];
    [self.view addSubview:self.footView];
}
// 点击设置按钮的 点击事件
- (void)setupButtonAction:(id)sender
{
//    SetUpViewController *setUpViewController = [[SetUpViewController alloc] init];
//    
//    [self presentViewController:setUpViewController animated:YES completion:^{
//        
//    }];
//    
//    if ([self.delegate respondsToSelector:@selector(setButtonDidPress)]) {
//        [self.delegate setButtonDidPress];
//    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 2;
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(section == 0){
//        return 3;
//    }else{
//        return 2;
//    };
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *pool = @"name1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pool];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pool];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor colorWithHexString:@"33ffcc"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
//    if(indexPath.section == 0){
//        cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
//    }else if(indexPath.section == 1){
//        cell.textLabel.text = [self.array objectAtIndex:indexPath.row + 3];
//    }
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    
    NSString *tabName = [NSString stringWithFormat:@"left%d.png", indexPath.row + 1];
    [cell.imageView setImage:[UIImage imageNamed:tabName]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height /12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [self.delegate setButtonDidPress];
        }
        else if (indexPath.row == 1){
            [self.delegate pushToChannelController];
        }
        else if (indexPath.row == 2){
            [self.delegate pushToVVController];
        }

//    }else if(indexPath.section == 1){
//        if(indexPath.row == 0){
//            [self.delegate pushToLoadManagerController];
//        }else if(indexPath.row == 1){
//            [self.delegate pushToPlayRecordController];
//        }
    }
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
