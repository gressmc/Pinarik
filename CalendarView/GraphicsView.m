//
//  GraphicsView.m
//  Cal-3
//
//  Created by gress on 15/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import "GraphicsView.h"
#import "DicColor.h"


@implementation GraphicsView
@synthesize currentMonth, currentYear;


- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawRect1];
       dicColor = [DicColor new];
    }
    return self;
}

- (void)drawRect1
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger day = 1;
    NSInteger month = currentMonth;
    NSInteger year = currentYear;
    
    //NSLog(@"startCurrentMonth:%d", currentMonth);
    
    NSDateComponents *dateParts = [NSDateComponents new];
    [dateParts setMonth:month];
    [dateParts setYear:year];
    [dateParts setDay:day];
    
    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];
    
    NSUInteger numDaysInMonth = [calendar rangeOfUnit:NSDayCalendarUnit
                                                  inUnit:NSMonthCalendarUnit
                                                 forDate:dateOnFirst].length;
    
    int greenDay = 0;
    int redDay = 0;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    for (int i=0; i<numDaysInMonth; i++) {
        
        [comps setDay:day];
        [comps setMonth:month];
        [comps setYear:year];
        NSDate *retDate = [calendar dateFromComponents:comps];
        
        if ([dicColor dateSetInGreen:[df stringFromDate:retDate]]) {
            greenDay++;
        }
        if ([dicColor dateSetInRed:[df stringFromDate:retDate]]) {
            redDay++;
        }
        day++;
       // NSLog(@"%@",[df stringFromDate:retDate]);
    }
    
    greenP = (float)greenDay*100/(float)numDaysInMonth;
    redP = (float)redDay*100/(float)numDaysInMonth;
  //  NSLog(@"green-%d, red-%d", greenDay, redDay);
    NSLog(@"greenP-%.f, redP-%.f", greenP, redP);
}

- (void)setMonth:(NSInteger)month {
    currentMonth = month;
    [self setNeedsDisplay:YES];
}

- (void)setYear:(NSInteger)year {
    currentYear = year;
    [self setNeedsDisplay:YES];
}

-(NSInteger)month{
    return currentMonth;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSLog(@"greenP2-%.f, redP2-%.f", greenP, redP);
    
    NSBezierPath *arcPath = [NSBezierPath bezierPath];
    [arcPath moveToPoint: NSMakePoint(25,26)];
    [arcPath appendBezierPathWithArcWithCenter:NSMakePoint(25, 26) radius:23 startAngle:0 endAngle:greenP*3.6];
    
    [arcPath closePath];
    
    [[NSColor greenColor] setFill];
    [arcPath fill];
    
    NSBezierPath *arcPath2 = [NSBezierPath bezierPath];
    [arcPath2 moveToPoint: NSMakePoint(25,25)];
    [arcPath2 appendBezierPathWithArcWithCenter:NSMakePoint(25, 26) radius:23 startAngle:greenP*3.6 endAngle:(greenP+redP)*3.6];
    [arcPath2 closePath];
    
    [[NSColor redColor] setFill];
    [arcPath2 fill];
    
    NSBezierPath *arcPath3 = [NSBezierPath bezierPath];
    [arcPath3 moveToPoint: NSMakePoint(25,25)];
    [arcPath3 appendBezierPathWithArcWithCenter:NSMakePoint(25, 26) radius:23 startAngle:(greenP+redP)*3.6 endAngle:360];
    [arcPath3 closePath];
    
    [[NSColor whiteColor] setFill];
    [arcPath3 fill];
    
    NSString *redTitle = [NSString stringWithFormat:@"Потерянных дней :%.f процентов", redP];
    NSString *greenTitle = [NSString stringWithFormat:@"Успешных дней :%.f процентов", greenP];
    NSString *whiteTitle = [NSString stringWithFormat:@"Неопределился с :%.f процентами", 100-redP-greenP];
    
    NSMutableDictionary *textAttributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSCenterTextAlignment;
    
    [textAttributes setObject:[NSColor colorWithCalibratedWhite:0.086 alpha:1.000] forKey:NSForegroundColorAttributeName];
    [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    NSRect textFrame1 = CGRectMake(45, 30, 220, 18);
    NSRect textFrame2 = CGRectMake(45, 15, 220, 18);
    NSRect textFrame3 = CGRectMake(45, 0, 220, 18);
    
    [redTitle drawInRect:textFrame1 withAttributes:textAttributes];
    [greenTitle drawInRect:textFrame2 withAttributes:textAttributes];
    [whiteTitle drawInRect:textFrame3 withAttributes:textAttributes];
    
}

@end
