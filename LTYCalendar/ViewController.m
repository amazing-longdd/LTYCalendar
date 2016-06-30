//
//  ViewController.m
//  LTYCalendar
//
//  Created by 龙通洋 on 16/6/30.
//  Copyright © 2016年 LongTongyang. All rights reserved.
//

#import "ViewController.h"
#import "LTYCalendar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LTYCalendar *calendar = [LTYCalendar showSelf:self.view];
    calendar.today = [NSDate date];
    calendar.date = calendar.today;
    calendar.frame = CGRectMake(0, 100, self.view.frame.size.width, 352);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
