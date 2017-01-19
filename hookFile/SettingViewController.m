//
//  SettingViewController.m
//  hookFile
//
//  Created by MatrixReload on 2017/1/8.
//
//

#import "SettingViewController.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *switchAuto;
@property (nonatomic, strong) UISwitch *switchNoSelf;
@property (nonatomic, strong) UISwitch *switchDelay;

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"自动抢红包";
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchview.tag = 0;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"HBTYPE"] integerValue] == 0) {
            [switchview setOn:NO];
        } else {
            [switchview setOn:YES];
        }
        [switchview addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
        self.switchAuto = switchview;
        cell.accessoryView = switchview;
    } else if(indexPath.row == 1) {
        cell.textLabel.text = @"不抢自己红包";
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchview.tag = 1;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"HBTYPE"] integerValue] == 3) {
            [switchview setOn:YES];
        } else {
            [switchview setOn:NO];
        }
        [switchview addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
        self.switchDelay = switchview;
        cell.accessoryView = switchview;
    } else if(indexPath.row == 2) {
        cell.textLabel.text = @"随机延迟0.1～0.5秒";
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchview.tag = 2;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDelay"] integerValue] == 0) {
            [switchview setOn:NO];
        } else {
            [switchview setOn:YES];
        }
        [switchview addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
        self.switchDelay = switchview;
        cell.accessoryView = switchview;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"微信在必须在前台运行才能抢红包";
        cell.textLabel.font = [UIFont systemFontOfSize:11];
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"本程序仅供学习与交流，作者永久放弃一切权利，且不承担任何。";
        cell.textLabel.font = [UIFont systemFontOfSize:11];
    }
    
    return cell;
}

- (void)switchClick:(id)sender
{
    UISwitch *sw = sender;
    if (sw.tag == 0) {
        if (sw.isOn) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",1]
                                                      forKey:@"HBTYPE"];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0]
                                                      forKey:@"HBTYPE"];
            [self.switchNoSelf setOn:NO];
        }
    } else if (sw.tag == 1) {
        if (sw.isOn) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",3]
                                                      forKey:@"HBTYPE"];
            [self.switchAuto setOn:YES];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",1]
                                                      forKey:@"HBTYPE"];
        }
    } else if (sw.tag == 2) {
        if (sw.isOn) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",1]
                                                      forKey:@"isDelay"];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0]
                                                      forKey:@"isDelay"];
        }
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

@end
