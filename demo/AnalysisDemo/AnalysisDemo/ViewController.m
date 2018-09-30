//
//  ViewController.m
//  AnalysisDemo
//
//  Created by 杨上尉 on 2018/9/28.
//  Copyright © 2018年 David. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
#import "CollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *tableButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    [tableButton setTitle:@"TableView" forState:UIControlStateNormal];
    [tableButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tableButton setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:tableButton];
    
    UIButton *collectionButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    [collectionButton setTitle:@"Collection" forState:UIControlStateNormal];
    [collectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [collectionButton setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:collectionButton];
    
    [tableButton addTarget:self action:@selector(gotoTable) forControlEvents:UIControlEventTouchUpInside];
    [collectionButton addTarget:self action:@selector(gotoCollection) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 250, 100, 100)];
    label.userInteractionEnabled = true;
    label.backgroundColor = [UIColor greenColor];
    label.textColor = [UIColor blackColor];
    label.text = @"gesture";
    [self.view addSubview:label];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getsureAnalysis)];
    [label addGestureRecognizer:tapGesture];
}

- (void)gotoTable
{
    TableViewController *tableViewController = [TableViewController new];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (void)gotoCollection
{
    CollectionViewController *collectionViewController = [CollectionViewController new];
    [self.navigationController pushViewController:collectionViewController animated:true];
}

- (void)getsureAnalysis
{
    
}

@end
