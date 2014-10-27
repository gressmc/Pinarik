//
//  CalendarViewController.m
//  Cal-3
//
//  Created by gress on 12/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import "CalendarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectionView.h"

@interface CalendarViewController ()
@end

@implementation CalendarViewController
@synthesize delegate, startDate, endDate, selectionMode;

- (id)initAtPoint:(NSPoint)point inView:(NSView *)v arrowPosition:(ArrowPosition)ap selectionMode:(SelectionMode)sm {
    self = [super init];
    if(self) {
        insertPoint = point;
        parentView = v;
        arrowPos = ap;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(removeCalView) name:RAMMouseUpNotification object:nil];
    }
    return self;
}

- (id)initAtPoint:(NSPoint)point inView:(NSView *)v arrowPosition:(ArrowPosition)ap {
    return [self initAtPoint:point inView:v arrowPosition:ap selectionMode:SelectionDateRange];
}

- (id)initAtPoint:(NSPoint)point inView:(NSView *)v {
    return [self initAtPoint:point inView:v arrowPosition:ArrowPositionCentered];
}

- (void)loadView
{
    [super loadView];
    self.view.frame = parentView.frame;
    
    NSView *bgView = [[NSView alloc] initWithFrame:self.view.frame];
    [bgView.window setBackgroundColor:[NSColor redColor]];
    [self.view addSubview:bgView];
    
    int width = 390;
    int height = 300;
    
    calView = [[CalendarView alloc] initAtPoint:insertPoint withFrame:NSMakeRect(insertPoint.x , insertPoint.y , width, height) arrowPosition:arrowPos];

    [calView setSelectionMode:selectionMode];
    if(self.startDate) {
        [calView setStartDate:startDate];
    }
    if(self.endDate) {
        [calView setEndDate:endDate];
    }
    [self.view addSubview:calView];

}

- (void)setStartDate:(NSDate *)sDate {
    if(startDate) {
        startDate = nil;
    }
    startDate = sDate;
    [calView setStartDate:startDate];
}

- (void)setEndDate:(NSDate *)eDate {
    if(endDate) {
        endDate = nil;
    }
    endDate = eDate;
    [calView setEndDate:endDate];
}

- (void)removeCalView {
    startDate = [calView getStartDate];
    endDate = [calView getEndDate];
//    [calView addRow];
    
    // NSLog(@"startDate:%@ endDate:%@", startDate.description, startDate);
    
    // NSLog(@"CalView Selected:%d", [calView selected]);
    
    if([calView selected]) {
        if([startDate compare:endDate] == NSOrderedAscending)
            [self.delegate completedWithStartDate:startDate endDate:endDate];
        else
            [self.delegate completedWithStartDate:endDate endDate:startDate];
    }
}

@end