//
//  DaysView.m
//  Cal-3
//
//  Created by gress on 12/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.

#import "DaysView.h"
#import "DicColor.h"
#import "SelectionView.h"
#import "GraphicsView.h"


@implementation DaysView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        startCellX = 3;
        startCellY = 0;
        endCellX = 3;
        endCellY = 0;
        dicColor = [DicColor new];
        graphView = [GraphicsView new];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(greenDay) name:RAMMouseDownNotification object:nil];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    //Получаем-с дату на данный момент времени из системы
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger month = currentMonth;
    NSInteger year = currentYear;
    
    //Устанавливаем первый день месяца в неделе
    NSDateComponents *dateParts = [NSDateComponents new];
    [dateParts setMonth:month];
    [dateParts setYear:year];
    [dateParts setDay:1];
    
    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];
    
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:dateOnFirst];
    
    NSInteger  weekdayOfFirst = [weekdayComponents weekday];
    // День недели от 0 до 6
    // NSLog(@"weekdayOfFirst:%d", weekdayOfFirst);
    
    unsigned long numDaysInMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:dateOnFirst].length;
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    didAddExtraRow = NO;
    
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    NSColor* darkColor = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:0.720];
    
    [[NSColor greenColor] set];
    NSColor* color = [NSColor colorWithCalibratedRed:0.820 green:0.08 blue:0.0 alpha:0.4860];
    NSColor* color2 = [NSColor colorWithCalibratedRed:0.660 green:0.02 blue:0.04 alpha:1.880];
    NSArray* gradient3Colors = [NSArray arrayWithObjects:
                                (id)color.CGColor,
                                (id)color2.CGColor, nil];
    NSColor* colorR = [NSColor colorWithCalibratedRed:0.000 green:0.820 blue:0.071 alpha:0.490];
    NSColor* color2R = [NSColor colorWithCalibratedRed:0.000 green:0.660 blue:0.071 alpha:1.880];
    NSArray* gradient3ColorsR = [NSArray arrayWithObjects:
                                (id)colorR.CGColor,
                                (id)color2R.CGColor, nil];
    
    CGFloat gradient3Locations[] = {0, 1};
    CGGradientRef gradient3 = CGGradientCreateWithColors(colorSpace,  (CFArrayRef)gradient3Colors, gradient3Locations);
    CGGradientRef gradient3R = CGGradientCreateWithColors(colorSpace,  (CFArrayRef)gradient3ColorsR, gradient3Locations);

    //Узнаем сколько дней было в предыдущем месяце
    NSDateComponents *prevDateParts =[NSDateComponents new];
    [prevDateParts setMonth:month-1];
    [prevDateParts setYear:year];
    [prevDateParts setDay:1];
    
    NSDate *prevDateOnFirst = [calendar dateFromComponents:prevDateParts];
    
    unsigned long numDaysInPrevMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:prevDateOnFirst].length;
    
    //NSLog(@"month:%ld, numDaysInMonth:%ld", month-1, numDaysInPrevMonth);
    
    NSDateComponents *today =[[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    //Рисуем текст для каждого дня
    for (int i = 0; i <= weekdayOfFirst-2; i++) {

            unsigned long day = numDaysInPrevMonth - weekdayOfFirst+2+i;
            NSString *str = [NSString stringWithFormat:@"%ld", day];

            CGContextSaveGState(context);
            
            CGRect dayHeader2Frame = CGRectMake((i)*41+28, 150, 21, 14);
            
            NSMutableDictionary *textAttributes = [NSMutableDictionary new];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSCenterTextAlignment;
            
            [textAttributes setObject:[NSColor colorWithCalibratedWhite:0.633 alpha:1.000] forKey:NSForegroundColorAttributeName];
            [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
            
            [str drawInRect:dayHeader2Frame withAttributes:textAttributes];
            CGContextRestoreGState(context);
    }
    
    BOOL endedOnSat = NO;
    int finalRow = 0;
    int day =1;
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            int dayNumber = i * 7 + j;
            
            if(dayNumber >= (weekdayOfFirst-1) && day <= numDaysInMonth) {
                NSString *str = [NSString stringWithFormat:@"%d", day];
                // NSLog(@"i=%d-j=%d - date=%d",i,j,day);
                CGContextSaveGState(context);
                
                NSMutableDictionary *textAttributes = [NSMutableDictionary new];
                
                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle.alignment = NSCenterTextAlignment;
                
                [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
                
                CGRect dayHeader2Frame = CGRectMake(j*41+28, 150-i*25, 21, 14);
                
                if([today day] == day && [today month] == month && [today year] == year) {
                    [textAttributes setObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
                } else {
                    [textAttributes setObject:[NSColor colorWithCalibratedWhite:0.086 alpha:1.000] forKey:NSForegroundColorAttributeName];
                }
                
                NSDateComponents *greenParts = [NSDateComponents new];
                [greenParts setMonth:month];
                [greenParts setYear:year];
                [greenParts setDay:day];
                
                NSDate *dateGreen = [calendar dateFromComponents:greenParts];
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateStyle:NSDateFormatterShortStyle];
                
               // NSLog(@"%@",[df stringFromDate:dateGreen]);
                
                if ([dicColor dateSetInGreen:[df stringFromDate:dateGreen]]) {
                    
                    NSBezierPath* selectedRectPath =[NSBezierPath bezierPathWithRoundedRect:  NSMakeRect(j*41+25, 145-i*25, 27, 23) xRadius:10 yRadius:10];
                    CGContextSaveGState(context);
                    [selectedRectPath addClip];
                    
                    CGContextDrawLinearGradient(context, gradient3R, NSMakePoint((j+.5)*hDiff, 15- (i+1)*vDiff), NSMakePoint((j+.5)*hDiff, 325- i*vDiff), 0);
                   
                    CGContextRestoreGState(context);
                    CGContextSaveGState(context);
                    [darkColor setStroke];
                    selectedRectPath.lineWidth = .5;
                    [selectedRectPath stroke];
                    CGContextRestoreGState(context);
                }
                if ([dicColor dateSetInRed:[df stringFromDate:dateGreen]]) {
                    
                    NSBezierPath* selectedRectPath =[NSBezierPath bezierPathWithRoundedRect:  NSMakeRect(j*41+25, 145-i*25, 27, 23) xRadius:10 yRadius:10];
                    CGContextSaveGState(context);
                    [selectedRectPath addClip];
                    
                    CGContextDrawLinearGradient(context, gradient3, NSMakePoint((j+.5)*hDiff, 15- (i+1)*vDiff), NSMakePoint((j+.5)*hDiff, 325- i*vDiff), 0);
                    
                    CGContextRestoreGState(context);
                    CGContextSaveGState(context);
                    [darkColor setStroke];
                    selectedRectPath.lineWidth = .5;
                    [selectedRectPath stroke];
                    CGContextRestoreGState(context);
                }
                
                [str drawInRect: dayHeader2Frame withAttributes:textAttributes];
                CGContextRestoreGState(context);
                finalRow = i;
                if(day == numDaysInMonth && j == 6) {
                    endedOnSat = YES;
                }
                
                if(i == 5) {
                    didAddExtraRow = YES;
               //     NSLog(@"didAddExtraRow - YES");
                }
                ++day;
            }
        }
    }
    
    //Узнаем сколько дней было в cледующем месяце
    NSDateComponents *nextDayParts = [NSDateComponents new];
    [nextDayParts setMonth:month+1];
    [nextDayParts setYear:year];
    [nextDayParts setDay:1];
    
    NSDate *nextDayOnFirst = [calendar dateFromComponents:nextDayParts];
    
    NSDateComponents *nextWeekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:nextDayOnFirst];
    NSInteger weekdayOfNextFirst = [nextWeekdayComponents weekday];
    
    if(!endedOnSat) {
        //Draw the text for each of those days.
        for(NSInteger i = weekdayOfNextFirst - 1; i < 7; i++) {
            NSInteger day = i - weekdayOfNextFirst + 2;
            
            NSString *str = [NSString stringWithFormat:@"%ld", (long)day];
            
            CGContextSaveGState(context);
            
            NSMutableDictionary *textAttributes = [NSMutableDictionary new];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSCenterTextAlignment;
            
            [textAttributes setObject:[NSColor colorWithCalibratedWhite:0.633 alpha:1.000] forKey:NSForegroundColorAttributeName];
            [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
            
            CGRect dayHeader2Frame = CGRectMake((i)*41+28, 150 - finalRow * 25, 21, 14);
            
            [str drawInRect: dayHeader2Frame withAttributes:textAttributes];
            CGContextRestoreGState(context);
        }
    }
}

- (void)setMonth:(NSInteger)month {
    currentMonth = month;
    [self setNeedsDisplay:YES];
}

- (void)setYear:(NSInteger)year {
    currentYear = year;
    [self setNeedsDisplay:YES];
}

-(void) greenDay {
    [self setNeedsDisplay:YES];
}

- (void)resetRows {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger month = currentMonth;
    NSInteger year = currentYear;
    [graphView setCurrentMonth:month];
    [graphView setCurrentYear:year];
    [graphView drawRect1];
    //Get the first day of the month
    NSDateComponents *dateParts = [NSDateComponents new];
    [dateParts setMonth:month];
    [dateParts setYear:year];
    [dateParts setDay:1];
    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];
    
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:dateOnFirst];
    NSInteger weekdayOfFirst = [weekdayComponents weekday];
    
    NSInteger numDaysInMonth = [calendar rangeOfUnit:NSDayCalendarUnit
                                              inUnit:NSMonthCalendarUnit
                                             forDate:dateOnFirst].length;
    didAddExtraRow = NO;
  //  NSLog(@"didAddExtraRow - NO");
    int day = 1;
    for (int i = 0; i < 6; i++) {
        for(int j = 0; j < 7; j++) {
            int dayNumber = i * 7 + j;
            if(dayNumber >= (weekdayOfFirst - 1) && day <= numDaysInMonth) {
                if(i == 5) {
                    didAddExtraRow = YES;
                   // NSLog(@"didAddExtraRow - yes -2");
                }
                ++day;
            }
        }
    }
}

- (BOOL)addExtraRow {
    return didAddExtraRow;
}
@end
