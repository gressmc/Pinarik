//
//  CalendarViewController.h
//  Cal-3
//
//  Created by gress on 12/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CalendarView.h"




@protocol CalendarDelegate <NSObject>

-(void)completedWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end

@interface CalendarViewController : NSViewController {
    
    CalendarView *calView;

    NSPoint insertPoint;
    ArrowPosition arrowPos;
    
    NSView *parentView;
    
    NSDate *startDate;
    NSDate *endDate;
    
    SelectionMode selectionMode;
}

@property (nonatomic, assign) id <CalendarDelegate> delegate;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, assign) SelectionMode selectionMode;

- (id)initAtPoint:(NSPoint)point inView:(NSView *)v;
- (id)initAtPoint:(NSPoint)point inView:(NSView *)v arrowPosition:(ArrowPosition)ap;
- (id)initAtPoint:(NSPoint)point inView:(NSView *)v arrowPosition:(ArrowPosition)ap selectionMode:(SelectionMode)sm;

@end
