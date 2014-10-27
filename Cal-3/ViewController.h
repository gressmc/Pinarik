//
//  ViewController.h
//  Cal-3
//
//  Created by gress on 12/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CalendarViewController.h"
#import "AXStatusItemPopup.h"

@class FliperViews;

@class DicColor;

@interface ViewController : NSViewController <CalendarDelegate> {
    CalendarViewController *calVC;
    NSView *toolTipLabel;
    DicColor *dicColor;
}
@property(weak, nonatomic) AXStatusItemPopup *statusItemPopup;



@end
