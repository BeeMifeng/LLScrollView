//
//  ViewController.m
//  NewsApp
//
//  Created by 王政 on 2018/9/12.
//  Copyright © 2018年 lijialun. All rights reserved.
//

#import "ViewController.h"
#import "LLScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LLScrollView *llView = [[LLScrollView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 2 /3)];
    llView.imageItemArr = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"]];
    llView.pageAlign = PageAlignmentCenter;
    llView.shuffling = YES;
    llView.shuffling = false;
    [self.view addSubview:llView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
