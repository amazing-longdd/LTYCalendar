//
//  LTYCalendar.h
//  LTYCalendar
//
//  Created by 龙通洋 on 16/6/30.
//  Copyright © 2016年 LongTongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTYCalendar : UIView

@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSDate* today;

+(instancetype)showSelf:(UIView*)view;

@end
