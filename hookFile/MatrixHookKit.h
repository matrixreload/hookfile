//
//  MatrixHookKit.h
//  hookFile
//
//  Created by MatrixReload on 2017/1/5.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
static int const kClose = 0;
static int const kOpen = 1;
static int const kCloseForMyself = 3;

@interface MatrixHookKit : NSObject

+(UIViewController *)HongBaoSettingVC;

+(UIButton *)entryBtn;

@end
