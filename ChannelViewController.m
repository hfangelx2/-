//
//  ChannelViewController.m
//  CCMV
//
//  Created by zd on 15/4/13.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "ChannelViewController.h"
#import "RACollectionViewReorderableTripletLayout.h" // 布局的文件
#import "CustomLabel.h"

#import "ChannelModel.h"
#import "ChannelViewCell.h"
#import "WebRequest.h"

#import "ChannelDetailController.h"



@interface ChannelViewController ()

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,strong)NSMutableArray *photosArray;


@end

@implementation ChannelViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.modelArray = [NSMutableArray array];
        self.photosArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
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
    
    CustomLabel *customLabel = [CustomLabel customLabelWithFrame:CGRectMake(self.view.frame.size.width/2 - 20, 35, 40, 40) text:@"频道" fontName:@"HelveticaNeue-UltraLight" fontSize:20];
    [navView addSubview:customLabel];
    [customLabel setTextColor:[UIColor whiteColor]];
    [customLabel sizeToFit];

    
    
    [self beginConnect];

}


- (void)beginConnect
{
    NSLog(@"这是频道页面的网络请求");
    
    [WebRequest connectWithUrl:ChannelPage parmater:nil requestHeader:RequestHeader httpMethod:@"GET" view:self.view block:^(id data) {
        
        if(data){
            [self.modelArray removeAllObjects];
            [self.photosArray removeAllObjects];
            
            NSDictionary *dict =(NSDictionary *)data;
            NSArray *array = [dict objectForKey:@"data"];
            for (NSDictionary *dic in array) {
                ChannelModel *channelModel = [[ChannelModel alloc]init];
                [channelModel setValuesForKeysWithDictionary:dic];
                [self.modelArray addObject:channelModel];
                [self.photosArray addObject:channelModel.img];
                
            }
            [self createCollectionView];
            [self.collectionView reloadData];
        }
        
        
    } refresh:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self beginConnect];
        });
    }];
}




- (void)leftButtonAction:(id)sender
{
    self.block();
}

- (void)searchAction:(id)sender
{
    self.block2();
}



- (void)createCollectionView
{
    RACollectionViewReorderableTripletLayout *layout = [[RACollectionViewReorderableTripletLayout alloc]init];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:layout];
    
    [self.collectionView registerClass:[ChannelViewCell class] forCellWithReuseIdentifier:@"test"];
    
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    self.block3Detail();
    
    ChannelDetailController *channelDetail = self.viewController;
    
    ChannelModel *model = [self.modelArray objectAtIndex:indexPath.item];
    
    channelDetail.idNum = model.albumId;
    
    channelDetail.titleLabel.text = model.title;
    
    [channelDetail startConnect];
    
}




// 返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// 返回每块section中cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

// section间距
- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

//item间距
- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

//  线间距
- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

// inset(插图?)距离集合视图
- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(5.f, 0, 5.f, 0);
}

// items在section中的大小?
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section
{
    return RACollectionViewTripletLayoutStyleSquare; //same as default !
}
// 自动滚动边缘?
- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0); //Sorry, horizontal scroll is not supported now.
}
// 自动滚动触发填补
- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(64.f, 0, 0, 0);
}
// 重新排序item的alpha
- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionview
{
    return .3f;
}

// 结束拖拽
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadData];
}

// item从什么位置移动到什么位置
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    ChannelModel *channelModel = [self.modelArray objectAtIndex:fromIndexPath.item];
    [self.modelArray removeObjectAtIndex:fromIndexPath.item];
    [self.modelArray insertObject:channelModel atIndex:toIndexPath.item];
}

// item能从什么位置移动到什么位置,返回是否可以移动
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return YES;
}

// item是否可以移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// 系统的返回CELL
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellID = @"test";
    
    ChannelViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    
    // 给数组加保护
    if(self.modelArray.count > indexPath.item){
    ChannelModel *channelModel = [_modelArray objectAtIndex:indexPath.item];
        [cell setAllValues:channelModel];
    }

    return cell;
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
