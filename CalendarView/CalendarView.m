//
//  CalendarView.m
//  Cal-3
//
//  Created by gress on 12/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//


#import "CalendarView.h"
#import "SelectionView.h"
#import "DaysView.h"
#import <QuartzCore/QuartzCore.h>
#import "GraphicsView.h"


@interface CalendarView () {
    SelectionMode _selectionMode;
}
@end

@implementation CalendarView
NSString *const  RAMMouseGraphNotification = @"RAMMouseGraphNotification";

-(SelectionMode) selectionMode {
    return _selectionMode;
}

-(void) setSelectionMode:(SelectionMode)selectionMode {
    _selectionMode = selectionMode;
    selectionView.selectionMode = _selectionMode;
}

-(id)initAtPoint:(NSPoint)p withFrame:(NSRect)frame {
    return [self initAtPoint:p withFrame:frame arrowPosition:ArrowPositionCentered];
}

-(id)initAtPoint:(NSPoint)p withFrame:(NSRect)frame arrowPosition:(ArrowPosition)arrowPos {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self.window setBackgroundColor:[NSColor clearColor]];

        calendar = [NSCalendar currentCalendar];
        
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *dateParts = [calendar components:unitFlags fromDate:[NSDate date]];
        currentMonth = [dateParts month];
        currentYear = [dateParts year];
        
        arrowPosition = arrowPos;
        startCellX = -1;
        startCellY = -1;
        endCellX = -1;
        endCellY = -1;
        
        hDiff = 41;
        vDiff = 25;

        selectionView = [[SelectionView alloc] initWithFrame:NSMakeRect(0, ([daysView addExtraRow] ? 26 : 51), 320, ([daysView addExtraRow] ? 6 : 5)*vDiff)];
        [self addSubview:selectionView];
        
        daysView = [[DaysView alloc] initWithFrame:NSMakeRect(0, 5, 320, vDiff*7)];
        [daysView setYear:currentYear];
        [daysView setMonth:currentMonth];
        [daysView resetRows];
        [self addSubview:daysView];
        
        graphView = [[GraphicsView alloc] initWithFrame:NSMakeRect(25, 222, 320,60)];
        [self addSubview:graphView];

        selectionView.frame = NSMakeRect(0, ([daysView addExtraRow] ? 26 : 51), 320, ([daysView addExtraRow] ? 6 : 5)*vDiff);
    }
    return self;
}

-(void) setFrame:(NSRect)frame{
    [super setFrame:frame];
}

-(void) mouseDown:(NSEvent *)theEvent{
    NSPoint p = [theEvent locationInWindow];
    downPoint = [self convertPoint:p fromView:nil];
        if (CGRectContainsPoint(NSMakeRect(20, 190, 30, 35), downPoint)) {
            if(currentMonth == 1) {
                currentMonth = 12;
                currentYear--;
            } else {
                currentMonth--;
            }
           [self performSelector:@selector(resetViews) withObject:nil afterDelay:0.01f];
        } else if (CGRectContainsPoint(NSMakeRect(290, 190, 30, 35), downPoint)){
            if(currentMonth == 12) {
                currentMonth = 1;
                currentYear++;
            } else {
                currentMonth++;
            }
          [self performSelector:@selector(resetViews) withObject:nil afterDelay:0.01f];
        }
    if (CGRectContainsPoint(NSMakeRect(90, 270, 30, 35), downPoint)){
       
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:RAMMouseGraphNotification object:self];
        
     NSLog(@"point.y - %d", (int)(downPoint.y));
     NSLog(@"point.x - %d", (int)(downPoint.x));
    }
}

- (void)resetViews {
    [selectionView resetSelection];
    [daysView setMonth:currentMonth];
    [daysView setYear:currentYear];
    [daysView resetRows];
    [daysView setNeedsDisplay:YES];
    [self setNeedsDisplay:YES];
    if ([daysView addExtraRow]) {
        selectionView.addExtraRow = NO;
    } else {
        selectionView.addExtraRow = YES;
    }
    selectionView.frame = NSMakeRect(0, ([daysView addExtraRow] ? 26 : 51), 320, ([daysView addExtraRow] ? 6 : 5)*vDiff);
}


- (BOOL)selected {
   // NSLog(@"Selected:%d", [selectionView selected]);
    return [selectionView selected];
}

- (void)setArrowPosition:(ArrowPosition)pos {
    arrowPosition = pos;
}

- (NSDate *)getStartDate {
    CGPoint startPoint = [selectionView startPoint];
    
    unsigned long day = 1;
    unsigned long month = currentMonth;
    unsigned long year = currentYear;
    
    //NSLog(@"startCurrentMonth:%d", currentMonth);
    
    //Get the first day of the month
    NSDateComponents *dateParts = [[NSDateComponents alloc] init];
    [dateParts setMonth:month];
    [dateParts setYear:year];
    [dateParts setDay:1];
    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];

    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:dateOnFirst];
    unsigned long weekdayOfFirst = [weekdayComponents weekday];
    
    unsigned long numDaysInMonth = [calendar rangeOfUnit:NSDayCalendarUnit
                                        inUnit:NSMonthCalendarUnit
                                       forDate:dateOnFirst].length;
   // NSLog(@"weekdayOfFirst:%lu", weekdayOfFirst);
    if(startPoint.y == 0 && startPoint.x+1 < weekdayOfFirst) {
        day = startPoint.x - weekdayOfFirst + 2;
    } else {
        int countDays = 1;
        for (int i = 0; i < 6; i++) {
            for(int j = 0; j < 7; j++) {
                int dayNumber = i * 7 + j;
                if(dayNumber >= (weekdayOfFirst - 1)) {
                    if(i == startPoint.y && j == startPoint.x) {
                        day = countDays;
                    }
                    ++countDays;
                } else if(countDays > numDaysInMonth) {
                    if(i == startPoint.y && j == startPoint.x) {
                        day = (countDays - numDaysInMonth);
                        month = currentMonth + 1;
                    }
                    countDays++;
                }
            }
        }
    }
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    NSDate *retDate = [calendar dateFromComponents:comps];
    
    return retDate;
}

- (NSDate *)getEndDate {
    CGPoint endPoint = [selectionView endPoint];
    
    // NSLog(@"endPoint:(%f,%f)", endPoint.x, endPoint.y);
    
    unsigned long day = 1;
    unsigned long month = currentMonth;
    unsigned long year = currentYear;
    
    //NSLog(@"endCurrentMonth:%d", currentMonth);
    
    //Get the first day of the month
    NSDateComponents *dateParts = [[NSDateComponents alloc] init];
    [dateParts setMonth:month];
    [dateParts setYear:year];
    [dateParts setDay:1];
    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];

    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:dateOnFirst];
    unsigned long weekdayOfFirst = [weekdayComponents weekday];
    
    unsigned long numDaysInMonth = [calendar rangeOfUnit:NSDayCalendarUnit
                                        inUnit:NSMonthCalendarUnit
                                       forDate:dateOnFirst].length;
    if(endPoint.y == 0 && endPoint.x+1 < weekdayOfFirst) {
        day = endPoint.x - weekdayOfFirst + 2;
    } else {
        int countDays = 1;
        for (int i = 0; i < 6; i++) {
            for(int j = 0; j < 7; j++) {
                int dayNumber = i * 7 + j;
                if(dayNumber >= (weekdayOfFirst - 1) && countDays <= numDaysInMonth) {
                    if(i == endPoint.y && j == endPoint.x) {
                        day = countDays;
                        
                        // NSLog(@"endDay:%lu", day);
                    }
                    ++countDays;
                } else if(countDays > numDaysInMonth) {
                    if(i == endPoint.y && j == endPoint.x) {
                        day = (countDays - numDaysInMonth);
                        month = currentMonth + 1;
                    }
                    countDays++;
                }
            }
        }
    }
    
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    NSDate *retDate = [calendar dateFromComponents:comps];
    
    return retDate;
}

- (void)setStartDate:(NSDate *)sDate {
   // NSLog(@"setStartDate");
    
    NSDateComponents *sComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:sDate];
    
    if([sComponents month] != currentMonth) {
        currentMonth = [sComponents month];
    }
    if([sComponents year] != currentYear) {
        currentYear = [sComponents year];
    }
    int day = 1;
    unsigned long month = currentMonth;
    unsigned long year = currentYear;
    
    //Get the first day of the month
    NSDateComponents *dateParts = [[NSDateComponents alloc] init];
    [dateParts setMonth:month];
    [dateParts setYear:year];
    [dateParts setDay:1];
    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];

    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:dateOnFirst];
    unsigned long weekdayOfFirst = [weekdayComponents weekday];
    
    unsigned long numDaysInMonth = [calendar rangeOfUnit:NSDayCalendarUnit
                                        inUnit:NSMonthCalendarUnit
                                       forDate:dateOnFirst].length;
    
    BOOL breakLoop = NO;
    int countDays = 1;
    for (int i = 0; i < 6; i++) {
        if(breakLoop) {
            break;
        }
        for(int j = 0; j < 7; j++) {
            int dayNumber = i * 7 + j;
            if(dayNumber >= (weekdayOfFirst - 1) && day <= numDaysInMonth) {
                if(countDays == [sComponents day]) {
                    CGPoint thePoint = CGPointMake(j, i);
                    [selectionView setStartPoint:thePoint];
                    breakLoop = YES;
                    break;
                }
                ++countDays;
            }
        }
    }
    
    [daysView setMonth:currentMonth];
    [daysView setYear:currentYear];
    [daysView resetRows];
    [daysView setNeedsDisplay:YES];


}

- (void)setEndDate:(NSDate *)eDate {
    //NSLog(@"setEndDate");
    NSDateComponents *eComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:eDate];
    
    if([eComponents month] != currentMonth) {
        currentMonth = [eComponents month];
    }
    if([eComponents year] != currentYear) {
        currentYear = [eComponents year];
    }
    int day = 1;
    unsigned long month = currentMonth;
    unsigned long year = currentYear;
    
    //Get the first day of the month
    NSDateComponents *dateParts = [[NSDateComponents alloc] init];
    [dateParts setMonth:month];
    [dateParts setYear:year];
    [dateParts setDay:1];
    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];

    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:dateOnFirst];
    unsigned long weekdayOfFirst = [weekdayComponents weekday];
    
    unsigned long numDaysInMonth = [calendar rangeOfUnit:NSDayCalendarUnit
                                        inUnit:NSMonthCalendarUnit
                                       forDate:dateOnFirst].length;
    
    BOOL breakLoop = NO;
    int countDays = 1;
    for (int i = 0; i < 6; i++) {
        if(breakLoop) {
            break;
        }
        for(int j = 0; j < 7; j++) {
            int dayNumber = i * 7 + j;
            if(dayNumber >= (weekdayOfFirst - 1) && day <= numDaysInMonth) {
                if(countDays == [eComponents day]) {
                    CGPoint thePoint = CGPointMake(j, i);
                    [selectionView setEndPoint:thePoint];
                    breakLoop = YES;
                    break;
                }
                ++countDays;
            }
        }
    }
    [daysView setMonth:currentMonth];
    [daysView setYear:currentYear];
    [daysView resetRows];
    [daysView setNeedsDisplay:YES];
    if(_selectionMode == SelectionSingleDate) {
        [self setStartDate:[self getEndDate]];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    //Вичисляем имена дней в неделе и имена месяцев в году
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSArray *dayTitles = [dateFormatter shortStandaloneWeekdaySymbols];
    NSArray *monthTitles = [dateFormatter shortStandaloneMonthSymbols];
    
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    // CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    // NSColor* bigBoxInnerShadowColor = [NSColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.56];
    NSColor* backgroundLightColor = [NSColor clearColor];
    NSColor* lineLightColor = [NSColor colorWithCalibratedWhite:0.384 alpha:1.000];
    // NSColor* lightColor = [NSColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.15];
    // NSColor* darkColor = [NSColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.72];
    NSColor* boxStroke =  [NSColor colorWithCalibratedWhite:0.563 alpha:1.000];
    
    NSBezierPath *closeUp = [NSBezierPath bezierPath];
    
    [closeUp moveToPoint: CGPointMake(90, 280)];
    
    //bottom right corner
    [closeUp lineToPoint: CGPointMake(115, 280)];
    
    
    //top right corner
    [closeUp lineToPoint: CGPointMake(115, 295)];
    
    
    [closeUp lineToPoint: CGPointMake(90, 295)];
    
    [closeUp lineToPoint: CGPointMake(90, 280)];
    
    //NSLog(@"did not add extra row");
    [closeUp closePath];
    
    [backgroundLightColor setFill];
    [closeUp fill];
    
    [boxStroke setStroke];
    closeUp.lineWidth = 1.5;
    
    [closeUp stroke];
    
    NSBezierPath *roundedRectanglePathUp = [NSBezierPath bezierPath];
    //float arrowPosX = 208;
    //bottom left corner
    [roundedRectanglePathUp moveToPoint: CGPointMake(2,265.4)];
    [roundedRectanglePathUp curveToPoint: CGPointMake(12, 275.4) controlPoint1: CGPointMake(2, 270.92) controlPoint2: CGPointMake(6.48, 275.4)];
    /*
     if(arrowPosition != ArrowPositionNone)
     {
     [roundedRectanglePath lineToPoint: CGPointMake(arrowPosX-53.5, 216.4)];
     [roundedRectanglePath lineToPoint: CGPointMake(arrowPosX-40, 231.4)];
     [roundedRectanglePath lineToPoint: CGPointMake(arrowPosX+13.5-40, 216.4)];
     }
     */
    
    //bottom right corner
    [roundedRectanglePathUp lineToPoint: CGPointMake(308.5, 275.4)];
    [roundedRectanglePathUp curveToPoint: CGPointMake(318.5, 265.4) controlPoint1: CGPointMake(314.02, 275.4) controlPoint2: CGPointMake(318.5, 270.92)];
    
    //top right corner
    [roundedRectanglePathUp lineToPoint: CGPointMake(318.5, 225.9)];
    [roundedRectanglePathUp curveToPoint: CGPointMake(308.5, 220.9) controlPoint1: CGPointMake(318.5, 225.38) controlPoint2: CGPointMake(314.5, 220.9)];
    
    [roundedRectanglePathUp lineToPoint: CGPointMake(12, 220.9)];
    [roundedRectanglePathUp curveToPoint: CGPointMake(02, 230.9) controlPoint1: CGPointMake(06.48, 220.9) controlPoint2: CGPointMake(02, 225.38)];
    [roundedRectanglePathUp lineToPoint: CGPointMake(02, 265.4)];
    
    //NSLog(@"did not add extra row");
    [roundedRectanglePathUp closePath];
    
    [backgroundLightColor setFill];
    [roundedRectanglePathUp fill];
    
    [boxStroke setStroke];
    roundedRectanglePathUp.lineWidth = 1.5;
    
    [roundedRectanglePathUp stroke];
   
    //Рисуем красивую рамочку-форму
    NSBezierPath *roundedRectanglePath = [NSBezierPath bezierPath];
    
    //float arrowPosX = 208;
    //bottom left corner
    [roundedRectanglePath moveToPoint: CGPointMake(2, 206.4)];
    [roundedRectanglePath curveToPoint: CGPointMake(12, 216.4) controlPoint1: CGPointMake(2, 211.92) controlPoint2: CGPointMake(6.48, 216.4)];
    /*
    if(arrowPosition != ArrowPositionNone)
    {
        [roundedRectanglePath lineToPoint: CGPointMake(arrowPosX-53.5, 216.4)];
        [roundedRectanglePath lineToPoint: CGPointMake(arrowPosX-40, 231.4)];
        [roundedRectanglePath lineToPoint: CGPointMake(arrowPosX+13.5-40, 216.4)];
    }
     */
     
    //bottom right corner
    [roundedRectanglePath lineToPoint: CGPointMake(308.5, 216.4)];
    [roundedRectanglePath curveToPoint: CGPointMake(318.5, 206.4) controlPoint1: CGPointMake(314.02, 216.4) controlPoint2: CGPointMake(318.5, 211.92)];
    
    //top right corner
    [roundedRectanglePath lineToPoint: CGPointMake(318.5, 13.9)];
    [roundedRectanglePath curveToPoint: CGPointMake(308.5, 3.9) controlPoint1: CGPointMake(318.5, 8.38) controlPoint2: CGPointMake(314.5, 3.9)];
    
    [roundedRectanglePath lineToPoint: CGPointMake(12, 3.9)];
    [roundedRectanglePath curveToPoint: CGPointMake(02, 13.9) controlPoint1: CGPointMake(06.48, 3.9) controlPoint2: CGPointMake(02, 8.38)];
    [roundedRectanglePath lineToPoint: CGPointMake(02, 206.4)];
    //NSLog(@"did not add extra row");
    
    [roundedRectanglePath closePath];
    
    [backgroundLightColor setFill];
    [roundedRectanglePath fill];
    
    [boxStroke setStroke];
    roundedRectanglePath.lineWidth = 1.5;
    [roundedRectanglePath stroke];
    
    //Разделители
    float addedHeight = ([daysView addExtraRow] ? 24:0);
    for (int i=0; i < 6; i++) {
        float xpos = 59;
        NSBezierPath *deviderPath = [NSBezierPath bezierPathWithRect:CGRectMake(xpos+i*41, 23.5, 0.5, 138+addedHeight)];
        [lineLightColor setFill];
        [deviderPath fill];
    }
    NSBezierPath *roundedRectangle2Path = [NSBezierPath bezierPath];

    //bottom left corner
    [roundedRectangle2Path moveToPoint: CGPointMake(2, 206.4)];
    [roundedRectangle2Path curveToPoint: CGPointMake(12, 216.4) controlPoint1: CGPointMake(2, 211.92) controlPoint2: CGPointMake(6.48, 216.4)];
    /*
    if(arrowPosition != ArrowPositionNone)
    {
        [roundedRectangle2Path lineToPoint: CGPointMake(arrowPosX-13.5, 216.4)];
        [roundedRectangle2Path lineToPoint: CGPointMake(arrowPosX, 231.4)];
        [roundedRectangle2Path lineToPoint: CGPointMake(arrowPosX+13.5, 216.4)];
    }
     */
     
    //bottom right corner
    [roundedRectangle2Path lineToPoint: CGPointMake(308.5, 216.4)];
    [roundedRectangle2Path curveToPoint: CGPointMake(358.5, 206.4) controlPoint1: CGPointMake(314.02, 216.4) controlPoint2: CGPointMake(318.5, 211.92)];
    
    //top right corner
    [roundedRectangle2Path lineToPoint: CGPointMake(318.5, 13.9)];
    [roundedRectangle2Path curveToPoint: CGPointMake(308.5, 3.9) controlPoint1: CGPointMake(318.5, 8.38) controlPoint2: CGPointMake(314.5, 3.9)];
    
    [roundedRectangle2Path lineToPoint: CGPointMake(12, 3.9)];
    [roundedRectangle2Path curveToPoint: CGPointMake(2, 13.9) controlPoint1: CGPointMake(6.48, 3.9) controlPoint2: CGPointMake(2, 8.38)];
    [roundedRectangle2Path lineToPoint: CGPointMake(2, 206.4)];
    
    [backgroundLightColor setFill];
    [roundedRectanglePath fill];
    
    [roundedRectangle2Path closePath];
    [roundedRectangle2Path addClip];
    
    //Пишем названия дней недели
    for (int i=0; i < dayTitles.count; i++) {
        NSRect dayHeaderFrame = NSMakeRect(23+i*41, 175, 30, 14);
        
        NSMutableDictionary *textAttributes = [NSMutableDictionary new];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSCenterTextAlignment;
        
        [textAttributes setObject:[NSColor colorWithCalibratedWhite:0.086 alpha:1.000] forKey:NSForegroundColorAttributeName];
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        
        [((NSString*)[dayTitles objectAtIndex:i]) drawInRect:dayHeaderFrame withAttributes:textAttributes];
    }

    //Пишем название месяца-год
    NSInteger month = currentMonth;
    NSInteger year =  currentYear;
    
    NSString *monthTitle = [NSString stringWithFormat:@"%@ %ld", [monthTitles objectAtIndex:(month - 1)], year];
    
    NSRect textFrame = CGRectMake(54, 190, 220, 18);
    
    NSMutableDictionary *textAttributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSCenterTextAlignment;
    
    [textAttributes setObject:[NSColor colorWithCalibratedWhite:0.086 alpha:1.000] forKey:NSForegroundColorAttributeName];
    [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    [monthTitle drawInRect:textFrame withAttributes:textAttributes];
    
    //Рисуем стрелочки вперед-назад
    NSBezierPath *backArrowPath = [NSBezierPath bezierPath];
    [backArrowPath moveToPoint: CGPointMake(26, 193.5)];
    [backArrowPath lineToPoint: CGPointMake(20, 198.5)];
    [backArrowPath curveToPoint: CGPointMake(26, 201.5) controlPoint1: CGPointMake(20, 198.5) controlPoint2: CGPointMake(26, 201.43)];
    [backArrowPath curveToPoint: CGPointMake(26, 194.5) controlPoint1: CGPointMake(26, 201.5) controlPoint2: CGPointMake(26, 194.5)];
    [backArrowPath closePath];
    [[NSColor colorWithCalibratedWhite:0.086 alpha:1.000] setFill];
    [backArrowPath fill];
    
    NSBezierPath* forwardArrowPath = [NSBezierPath bezierPath];
    [forwardArrowPath moveToPoint: CGPointMake(296.5, 193.5)];
    [forwardArrowPath lineToPoint: CGPointMake(302.5, 198)];
    [forwardArrowPath curveToPoint: CGPointMake(296.5, 201.5) controlPoint1: CGPointMake(302.5, 198) controlPoint2: CGPointMake(296.5, 201.43)];
    [forwardArrowPath curveToPoint: CGPointMake(296.5, 194.5) controlPoint1: CGPointMake(296.5, 201.5) controlPoint2: CGPointMake(296.5, 194.5)];
    [forwardArrowPath closePath];
    [[NSColor colorWithCalibratedWhite:0.086 alpha:1.000] setFill];
    [forwardArrowPath fill];
    
    CGColorSpaceRelease(colorSpace);
}

@end