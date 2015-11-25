//
//  LoadManagerViewController.m
//  CCMV
//
//  Created by zd on 15/4/14.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "LoadManagerViewController.h"

@interface LoadManagerViewController ()

@end

@implementation LoadManagerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];
    myLabel.backgroundColor= [UIColor whiteColor];
    myLabel.text = @"这是下载管理视图";
    
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [navView setBackgroundColor:[UIColor blackColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"抽屉" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTintColor:[UIColor whiteColor]];
    [button setFrame:CGRectMake(20, 20, 30, 30)];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [searchButton setFrame:CGRectMake(325, 20, 30, 30)];
    [searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *searchImage = [UIImage imageNamed:@"search.png"];
    UIImage *rendSearchImage = [searchImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [searchButton setImage:rendSearchImage forState:UIControlStateNormal];
    
    [navView addSubview:searchButton];
    
    [navView addSubview:button];
    
    [self.view addSubview:navView];
    
    [self.view addSubview:myLabel];
}


- (void)leftButtonAction:(id)sender
{
    self.block();
}

- (void)searchAction:(id)sender
{
    self.block2();
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
