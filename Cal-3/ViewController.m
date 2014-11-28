//
//  ViewController.m
//  Cal-3
//
//  Created by gress on 12/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CalendarViewController.h"
#import "DicColor.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        NSView *bgView = [[NSView alloc] initWithFrame:self.view.frame];

        [self.view addSubview:bgView];

        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        calVC = [[CalendarViewController alloc] initAtPoint:NSMakePoint(0, 0) inView:self.view arrowPosition:ArrowPositionCentered];
        calVC.delegate = self;
        calVC.selectionMode = SelectionSingleDate;
        
        dicColor = [DicColor new];
        
        NSDateComponents *dateParts = [[NSDateComponents alloc] init];
        
        [dateParts setMonth:8];
        [dateParts setYear:2014];
        [dateParts setDay:1];
        
        NSDate *sDate = [calendar dateFromComponents:dateParts];
        
        NSDateComponents *today =[[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        dateParts = [[NSDateComponents alloc] init];
        [dateParts setMonth:8];
        [dateParts setYear:2014];
        [dateParts setDay:[today day]];
        
        NSDate *eDate = [calendar dateFromComponents:dateParts];

        [calVC setStartDate:sDate];
        [calVC setEndDate:eDate];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateStyle:NSDateFormatterShortStyle];
        
        // Add to the view.
        [self.view addSubview:calVC.view];
    }
    return self;
}

- (void)completedWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [dicColor setColorDic:[df stringFromDate:startDate]];

    //NSLog(@"startDate:%@, endDate2:%@", [df stringFromDate:startDate], [df stringFromDate:endDate]);
    //[self showToolTip:[NSString stringWithFormat:@"%@ - %@", [df stringFromDate:startDate], [df stringFromDate:endDate]]];
}

- (void)showToolTip:(NSString *)str {
    // NSLog(@"ha-ha-ha- %@", str);
}
@end


