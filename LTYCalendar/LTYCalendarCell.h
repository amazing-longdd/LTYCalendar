//
//  LTYCalendarCell.h
//  LTYCalendar
//
//  Created by 龙通洋 on 16/6/30.
//  Copyright © 2016年 LongTongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTYCalendarCell : UICollectionViewCell
@property (nonatomic , strong) UILabel *dayLabel;

-(void)setLabelBackgroundColor:(UIColor*)color;
@end
