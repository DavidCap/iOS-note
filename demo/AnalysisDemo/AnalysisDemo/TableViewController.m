//
//  TableViewController.m
//  AnalysisDemo
//
//  Created by 杨上尉 on 2018/9/30.
//  Copyright © 2018年 David. All rights reserved.
//

#import "TableViewController.h"

static NSString *const Identify = @"TableCell";

@interface TableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify];
    cell.textLabel.text = @"test";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identify];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
