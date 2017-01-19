//
//  MatrixHookKit.m
//  hookFile
//
//  Created by MatrixReload on 2017/1/5.
//
//

#import "MatrixHookKit.h"
#import "SettingViewController.h"

@implementation MatrixHookKit

+(UIViewController *)HongBaoSettingVC
{
    SettingViewController *vc = [[SettingViewController alloc] init];
    vc.title = @"抢红包设置";
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.hidesBottomBarWhenPushed = YES;
    
    return vc;
}

+(UIButton *)entryBtn
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(SCREENW-110, SCREENH-100, 110, 40);
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"抢红包零号机" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 2.0;
    return btn;
}


@end
