//
//  ViewController.m
//  Nav
//
//  Created by Howe on 16/3/4.
//  Copyright © 2016年 Howe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UIImageView *imageView;
/*是否顶级设置透明度*/
@property (nonatomic, assign) BOOL isStopSetClear;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _setup];

}

#pragma mark Private Method

- (void)_setup
{
    self.isStopSetClear = NO;
    [self _setNavBGIsClearWithAlpha:0.0f];
    
    self.title = @"Nav";
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, -64.0f, self.view.bounds.size.width, self.view.bounds.size.height + 64.0f) style:UITableViewStyleGrouped];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image"]];
    tableView.tableHeaderView = imageView;
    self.imageView = imageView;
}

//------------------------------------------------------------
//   返回透明背景图片
//
//------------------------------------------------------------


- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
//------------------------------------------------------------
//   设置导航栏背景为透明
//
//------------------------------------------------------------
- (void)_setNavBGIsClearWithAlpha:(CGFloat)aplha
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:aplha] size:CGSizeMake(self.navigationController.navigationBar.bounds.size.width, 64.0f)] forBarMetrics:UIBarMetricsDefault];
}

//------------------------------------------------------------
//   设置导航栏背景为图片
//
//------------------------------------------------------------
- (void)_setNavBGIsImage
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"image"] forBarMetrics:UIBarMetricsDefault];

}

#pragma mark UIScrollView Delegate
//------------------------------------------------------------
//  也可以使用KVO做
//  根据滚动的OffSet 设置对应的透明度
//  根据偏移量计算出一个透明度，当刚好把表头视图隐藏式偏移量刚好是1.0f
//  此时我们将导航栏的背景图设置为表头视图里面的图片  ，也可以到透明度到某一个值是，
//  设置为这个值，后面的偏移量大于这个数 也设置为这个值
//------------------------------------------------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat contentOffSetY = scrollView.contentOffset.y;
    CGFloat  offsetY = 64 + contentOffSetY;
    CGFloat aplha= offsetY/(CGRectGetHeight(self.imageView.frame)- 64.0f);
    if (aplha >= 1.0f )
    {
        if (!self.isStopSetClear)
        {
            self.isStopSetClear = YES;
            [self _setNavBGIsImage];
        }
    }else
    {
        self.isStopSetClear = NO;
        [self _setNavBGIsClearWithAlpha:aplha];
    }
}

#pragma mark UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    return cell;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
