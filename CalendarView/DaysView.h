//
//  DaysView.h
//  Cal-3
//
//  Created by gress on 12/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//
#import <Cocoa/Cocoa.h>

@class GraphicsView;
@class DicColor;

@interface DaysView : NSView {
    int startCellX;
    int startCellY;
    int endCellX;
    int endCellY;
    
    float xOffset;
    float yOffset;
    
    float hDiff;
    float vDiff;
    
    NSInteger currentMonth;
    NSInteger currentYear;
    
    BOOL didAddExtraRow;
    
    DicColor *dicColor;
    
@public   GraphicsView *graphView;
}

- (void)setMonth:(NSInteger)month;
- (void)setYear:(NSInteger)year;

- (void)resetRows;

- (BOOL)addExtraRow;
@end
