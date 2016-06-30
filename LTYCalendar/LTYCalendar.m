//
//  LTYCalendar.m
//  LTYCalendar
//
//  Created by 龙通洋 on 16/6/30.
//  Copyright © 2016年 LongTongyang. All rights reserved.
//

#import "LTYCalendar.h"
#import "LTYCalendarCell.h"

NSString *const LTYCalendarCellIdentifier = @"LTYCalendarCell";

@interface LTYCalendar()<UICollectionViewDelegate , UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic , strong) NSArray *weekArray;
@end

@implementation LTYCalendar

+(instancetype)showSelf:(UIView*)view{

    LTYCalendar *calendar = [[[NSBundle mainBundle] loadNibNamed:@"LTYCalendar" owner:self options:nil] firstObject];
    
    [view addSubview:calendar];
    [view addSubview:calendar];
    return calendar;
}

-(void)initCollectionView{

    CGFloat cellWidth = self.collectionView.frame.size.width / 7;
    CGFloat cellHeight = self.collectionView.frame.size.height / 7;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.collectionView setCollectionViewLayout:layout animated:YES];
    
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    [_monthLabel setText:[NSString stringWithFormat:@"%.2ld-%li",(long)[self month:date],(long)[self year:date]]];
    [_collectionView reloadData];
}
- (void)awakeFromNib
{
    self.weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    [self.collectionView registerClass:[LTYCalendarCell class] forCellWithReuseIdentifier:LTYCalendarCellIdentifier];
    
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nexAction:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseAction:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
    
    [self show];
}

#pragma mark - 关于date的处理函数


- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}
/**
 *  @author 龙通洋, 16-06-30
 *
 *  这个月的第一天从几号开始
 *
 */
- (NSInteger)firstWeekdayInMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

/**
 *  @author 龙通洋, 16-06-30
 *
 *  这个月有多少天
 *
 */
- (NSInteger)daysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}
/**
 *  @author 龙通洋, 16-06-30
 *
 *  上个月
 *
 */
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
/**
 *  @author 龙通洋, 16-06-30
 *
 *  下个月
 *
 */
- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma -mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.weekArray.count;
    } else {
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LTYCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LTYCalendarCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell.dayLabel setText:self.weekArray[indexPath.row]];
        [cell.dayLabel setTextColor:[self getColor:@"15cc9c"]];
    } else {
        NSInteger daysInMonth = [self daysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i < firstWeekday) {
            [cell.dayLabel setText:@""];
            
        }else if (i > firstWeekday + daysInMonth - 1){
            [cell.dayLabel setText:@""];
        }else{
            day = i - firstWeekday + 1;
            [cell.dayLabel setText:[NSString stringWithFormat:@"%li",(long)day]];
            [cell.dayLabel setTextColor:[self getColor:@"6f6f6f"]];
            
            if ([_today isEqualToDate:_date]) {
                if (day == [self day:_date]) {
                    [cell.dayLabel setTextColor:[self getColor:@"4898eb"]];
                    [cell setLabelBackgroundColor:[UIColor yellowColor]];
                } else if (day > [self day:_date]) {
                    [cell.dayLabel setTextColor:[self getColor:@"cbcbcb"]];
                }
            } else if ([_today compare:_date] == NSOrderedAscending) {
                [cell.dayLabel setTextColor:[self getColor:@"cbcbcb"]];
            }
        }
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSInteger daysInMonth = [self daysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i >= firstWeekday && i <= firstWeekday + daysInMonth - 1) {
            day = i - firstWeekday + 1;
            
            //this month
            if ([_today isEqualToDate:_date]) {
                if (day <= [self day:_date]) {
                    return YES;
                }
            } else if ([_today compare:_date] == NSOrderedDescending) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
}

- (void)show
{
    self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        [self initCollectionView];
    }];
}
- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);

    } completion:^(BOOL isFinished) {

        [self removeFromSuperview];
    }];
}
#pragma mark -16进制颜色工具函数
- (UIColor *)getColor:(NSString*)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}



@end
