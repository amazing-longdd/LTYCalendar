//
//  LTYCalendarCell.m
//  LTYCalendar
//
//  Created by 龙通洋 on 16/6/30.
//  Copyright © 2016年 LongTongyang. All rights reserved.
//

#import "LTYCalendarCell.h"

@implementation LTYCalendarCell
- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dayLabel setTextAlignment:NSTextAlignmentCenter];
        [_dayLabel setFont:[UIFont systemFontOfSize:17]];
        [self addSubview:_dayLabel];
    }
    return _dayLabel;
}

-(void)setLabelBackgroundColor:(UIColor*)color{
    //根据不同的状态可以设置不同的color颜色
    //为了保证裁剪出来一定是圆的 collectionViewcell的宽和高一定要一样
    _dayLabel.layer.cornerRadius = self.bounds.size.width/2;
    _dayLabel.layer.masksToBounds = YES;
    _dayLabel.backgroundColor = color;
    
}
@end
