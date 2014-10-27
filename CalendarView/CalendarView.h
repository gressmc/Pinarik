//
//  CalendarView.h
//  Cal-3
//
//  Created by gress on 12/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Types.h"


@class GraphicsView;


extern NSString *const  RAMMouseGraphNotification;

typedef enum {
    ArrowPositionLeft = -1,
    ArrowPositionCentered = 0,
    ArrowPositionRight = 1,
    ArrowPositionNone = 99
} ArrowPosition;

@class SelectionView;
@class DaysView;
@class FliperViews;

@interface CalendarView : NSView  {
    NSCalendar *calendar;
    
    NSInteger currentMonth;
    NSInteger currentYear;
    
    int startCellX;
    int startCellY;
    int endCellX;
    int endCellY;
    
    float hDiff;
    float vDiff;
    SelectionView *selectionView;
    DaysView *daysView;
    GraphicsView *graphView;
    int arrowPosition;
    NSPoint downPoint;
}

@property SelectionMode selectionMode;

//-(void)addRow;
- (id)initAtPoint:(CGPoint)p withFrame:(CGRect)frame;
- (id)initAtPoint:(CGPoint)p withFrame:(CGRect)frame arrowPosition:(ArrowPosition)arrowPos;
- (void)setArrowPosition:(ArrowPosition)pos;
- (NSDate *)getStartDate;
- (NSDate *)getEndDate;
- (BOOL)selected;
- (void)setStartDate:(NSDate *)sDate;
- (void)setEndDate:(NSDate *)eDate;

@end
