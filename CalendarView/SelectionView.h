//
//  OCSelectionView.h
//  Cal-3
//
//  Created by gress on 12/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Types.h"
#import "CalendarViewController.h"

extern NSString *const RAMMouseDownNotification;
extern NSString *const  RAMMouseUpNotification;

@interface SelectionView : NSView  {
    
    BOOL addExtraRow;
    
    BOOL selected;
    int startCellX;
    int startCellY;
    int endCellX;
    int endCellY;
    
    float xOffset;
    float yOffset;
    
    float hDiff;
    float vDiff;
    
    NSPoint point;
    
}

- (void)resetSelection;
-(NSPoint)startPoint;
-(NSPoint)endPoint;

-(void)setStartPoint:(NSPoint)sPoint;
-(void)setEndPoint:(NSPoint)ePoint;
@property(nonatomic, assign) SelectionMode selectionMode;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL addExtraRow;


@end
