//
//  SetUpViewController.m
//  CCMV
//
//  Created by zd on 15/4/13.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "SetUpViewController.h"
#import "CustomLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "RNSampleCell.h"

@interface SetUpViewController ()

@property(nonatomic,strong)NSArray *cellArray;

@property(nonatomic,strong)RNRippleTableView *rippleView;


@end

@implementation SetUpViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.cellArray = [NSArray arrayWithObjects:@"清理缓存",@"关于我们" ,nil ];
    }
    return self;
}






- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 74)];
    [navView setBackgroundColor:[UIColor blackColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *menuImage = [UIImage imageNamed:@"returnButton.png"];
    UIImage *rendMenuImage = [menuImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [button addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:rendMenuImage forState:UIControlStateNormal];
    [button setFrame:CGRectMake(15, 30, 30, 30)];
    
    [navView addSubview:button];
    
    [self.view addSubview:navView];
    
//    self.view.clipsToBounds = YES;
    
    CustomLabel *customLabel = [CustomLabel customLabelWithFrame:CGRectMake(self.view.frame.size.width/2 - 20, 35, 40, 40) text:@"设置" fontName:@"HelveticaNeue-UltraLight" fontSize:20];
    [navView addSubview:customLabel];
    [customLabel setTextColor:[UIColor whiteColor]];
    [customLabel sizeToFit];

    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:117/255.f green:184/255.f blue:174/255.f alpha:1]];
    
    self.rippleView = [[RNRippleTableView alloc]initWithFrame:CGRectMake(-50, 74, self.view.frame.size.width /2, self.view.frame.size.height)];
    self.rippleView.ripplesOnShake = YES;
    [self.rippleView registerContentViewClass:[RNSampleCell class]];
    self.rippleView.delegate = self;
    self.rippleView.dataSource = self;
    [self.view addSubview:self.rippleView];

}

// 这个页面上按钮的点击事件
- (void)buttonDidPress:(id)sender {
 [self dismissViewControllerAnimated:YES completion:^{
     
 }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.rippleView becomeFirstResponder];
}

- (NSInteger)numberOfItemsInTableView:(RNRippleTableView *)tableView
{
    return self.cellArray.count;
}

- (UIView *)viewForTableView:(RNRippleTableView *)tableView atIndex:(NSInteger)index withReuseView:(RNSampleCell *)reuseView
{
    reuseView.backgroundColor = [UIColor colorWithRed:117/255.f green:184/255.f blue:174/255.f alpha:1];
    [reuseView.titleLabel setText:[self.cellArray objectAtIndex:index]];
    reuseView.titleLabel.textColor = [UIColor whiteColor];
    reuseView.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    reuseView.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.1f];
    reuseView.titleLabel.shadowOffset = CGSizeMake(0, -1);
    reuseView.dividerLayer.backgroundColor = [UIColor whiteColor].CGColor;
    return reuseView;
}

- (CGFloat)heightForViewInTableView:(RNRippleTableView *)tableView atIndex:(NSInteger)index
{
    return 40;
}


- (void)tableView:(RNRippleTableView *)tableView didSelectView:(UIView *)view atIndex:(NSInteger)index
{
    if(index == 0){
      
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
