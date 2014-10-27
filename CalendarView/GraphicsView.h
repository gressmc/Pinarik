//
//  GraphicsView.h
//  Cal-3
//
//  Created by gress on 15/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class DicColor;

static float greenP;
static float redP;

@interface GraphicsView : NSView {
    NSInteger currentMonth;
    NSInteger currentYear;
    DicColor *dicColor;
}

@property NSInteger currentMonth, currentYear;

- (void)setMonth:(NSInteger)month;
- (void)setYear:(NSInteger)year;
-(NSInteger)month;
- (void)drawRect1;

@end
