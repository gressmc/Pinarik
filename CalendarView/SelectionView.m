//
//  SelectionView.m
//  Cal-3
//
//  Created by gress on 12/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import "SelectionView.h"
#import "GraphicsView.h"

@implementation SelectionView
@synthesize selectionMode = _selectionMode;
@synthesize selected;
@synthesize addExtraRow;

NSString *const RAMMouseDownNotification = @"RAMMouseDownNotification";
NSString *const  RAMMouseUpNotification = @"RAMMouseUpNotification";

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        selected = NO;
        startCellX = -1;
        startCellY = -1;
        endCellX = -1;
        endCellY = -1;
        
        hDiff = 41;
        vDiff = 25;
    }
    return self;
}

- (BOOL) selected {
    return selected;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if (selected) {
        CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
        CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
        
        NSColor* darkColor = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:0.720];
        
        NSColor* color = [NSColor colorWithCalibratedRed:0.820 green:0.600 blue:0.660 alpha:0.4860];
        NSColor* color2 = [NSColor colorWithCalibratedRed:0.000 green:0.900 blue:1.000 alpha:0.880];
        NSArray* gradient3Colors = [NSArray arrayWithObjects:
                                    (id)color.CGColor,
                                    (id)color2.CGColor, nil];
        
        CGFloat gradient3Locations[] = {0, 1};
        CGGradientRef gradient3 = CGGradientCreateWithColors(colorSpace,  (CFArrayRef)gradient3Colors, gradient3Locations);
        
       
          if (addExtraRow) { endCellY++; startCellY++;}
        int tempStart = MIN(startCellY, endCellY);
        int tempEnd = MAX(startCellY, endCellY);
        for(int i = tempStart; i <= tempEnd; i++) {
            
        //     NSLog(@"--------");
        //    NSLog(@"%d - %d", startCellX, startCellY);
        //     NSLog(@"%d - %d", endCellX, endCellY);
        //     NSLog(@"--------");
            
            //// selectedRect Drawing
            int thisRowEndCell =6;
            int thisRowStartCell;
            if(startCellY == i) {
                thisRowStartCell = startCellX;
                if (startCellY > endCellY) {
                    thisRowStartCell = 0; thisRowEndCell = startCellX;
                }
            } else {
                thisRowStartCell = 0;
            }
            
            if(endCellY == i) {
                thisRowEndCell = endCellX;
                
                if (startCellY > endCellY) {
                    thisRowStartCell = endCellX; thisRowEndCell = 6;
                }
            } else if (!(startCellY > endCellY)) {
                thisRowEndCell = 6;
            }
            CGFloat cornerRadius;
            cornerRadius = 10.0;
            
            //// Рисуем-с выделитель
            float width_offset= 25;
            NSBezierPath* selectedRectPath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(MIN(thisRowStartCell, thisRowEndCell)*hDiff+26, 125 - i*vDiff, (ABS(thisRowEndCell-thisRowStartCell))*hDiff+width_offset, 21) xRadius:cornerRadius yRadius:cornerRadius];
            CGContextSaveGState(context);
            [selectedRectPath addClip];
            CGContextDrawLinearGradient(context, gradient3, NSMakePoint((MIN(thisRowStartCell, thisRowEndCell)+.5)*hDiff, 15- (i+1)*vDiff), NSMakePoint((MAX(thisRowStartCell, thisRowEndCell)+.5)*hDiff,325- i*vDiff), 0);
            CGContextRestoreGState(context);
            
            CGContextSaveGState(context);
                        [darkColor setStroke];
            selectedRectPath.lineWidth = .5;
            [selectedRectPath stroke];
            CGContextRestoreGState(context);
        }
        CGGradientRelease(gradient3);
        CGColorSpaceRelease(colorSpace);
    }
}


-(void)mouseDown:(NSEvent *)theEvent{
    NSPoint p = [theEvent locationInWindow];
    point = [self convertPoint:p fromView:nil];
    [self singleSelection:point];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:RAMMouseDownNotification object:self];
}

-(void)mouseDragged:(NSEvent *)theEvent{
    NSPoint p = [theEvent locationInWindow];
    point = [self convertPoint:p fromView:nil];
    if(_selectionMode == SelectionSingleDate) {
        [self singleSelection:point];
    }
    if(CGRectContainsPoint(self.bounds, point)) {
        if ((int)point.x < 59) {
            endCellX = 0;
        } else {
            if (59 < (int)point.x && (int)point.x < 100) {
                endCellX = 1;
            } else {
                if (100 < (int)point.x && (int)point.x < 141) {
                    endCellX = 2;
                } else {
                    if (141 < (int)point.x && (int)point.x < 182) {
                        endCellX = 3;
                    } else {
                        if (182 < (int)point.x && (int)point.x < 224) {
                            endCellX = 4;
                        } else {
                            if (224 < (int)point.x && (int)point.x < 262) {
                                endCellX = 5;
                            } else {
                                if (262 < (int)point.x) {
                                    endCellX = 6;
                                }
                            }
                        }
                    }
                }
            }
        }
        
        //endCellX = MIN((int)(point.x)/47,6);
        if (addExtraRow) {
            endCellY = ABS((int)(point.y)/vDiff-5);
        } else {
            endCellY = ABS((int)(point.y)/vDiff-6);
        }
        
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseUp:(NSEvent *)theEvent{
    NSPoint p = [theEvent locationInWindow];
    point = [self convertPoint:p fromView:nil];
    if(_selectionMode == SelectionSingleDate) {
        [self singleSelection:point];
    }
    if(CGRectContainsPoint(self.bounds, point)) {
        if ((int)point.x < 59) {
            endCellX = 0;
        } else {
            if (59 < (int)point.x && (int)point.x < 100) {
                endCellX = 1;
            } else {
                if (100 < (int)point.x && (int)point.x < 141) {
                    endCellX = 2;
                } else {
                    if (141 < (int)point.x && (int)point.x < 182) {
                        endCellX = 3;
                    } else {
                        if (182 < (int)point.x && (int)point.x < 224) {
                            endCellX = 4;
                        } else {
                            if (224 < (int)point.x && (int)point.x < 262) {
                                endCellX = 5;
                            } else {
                                if (262 < (int)point.x) {
                                    endCellX = 6;
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // endCellX = MIN((int)(point)/47, 6);
        if (addExtraRow) {
            endCellY =ABS((int)(point.y)/vDiff-5);
        } else {
            endCellY =ABS((int)(point.y)/vDiff-6);
        }
        [self setNeedsDisplay:YES];

        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:RAMMouseUpNotification object:self];
    }
}

-(void) singleSelection:(NSPoint )pointX {
 self.selected = YES;
    if ((int)pointX.x < 59) {
        startCellX = 0;
    } else {
        if (59 < (int)pointX.x && (int)pointX.x < 100) {
            startCellX = 1;
        } else {
            if (100 < (int)pointX.x && (int)pointX.x < 141) {
                startCellX = 2;
            } else {
                if (141 < (int)pointX.x && (int)pointX.x < 182) {
                    startCellX = 3;
                } else {
                    if (182 < (int)pointX.x && (int)pointX.x < 224) {
                        startCellX = 4;
                    } else {
                        if (224 < (int)pointX.x && (int)pointX.x < 262) {
                            startCellX = 5;
                        } else {
                            if (262 < (int)pointX.x) {
                                startCellX = 6;
                            }
                        }
                    }
                }
            }
        }
    }
    
 // startCellX = MIN((int)(point.x)/47,6);
    if (addExtraRow) {
        startCellY = abs((int)(pointX.y)/vDiff-5);
    } else {
        startCellY = abs((int)(pointX.y)/vDiff-6);
    }
   // NSLog(@"----%hhd----",addExtraRow);
   // NSLog(@"--------");
    NSLog(@"point.y - %d", (int)(pointX.y));

endCellX = startCellX;
endCellY = startCellY;
    
   // NSLog(@"--------");
   // NSLog(@"%d - %d", startCellX, startCellY);
   // NSLog(@"%d - %d", endCellX, endCellY);
   // NSLog(@"--------");
    [self setNeedsDisplay:YES];
    
}

-(void)resetSelection {
    startCellX = -1;
    startCellY = -1;
    endCellY = -1;
    endCellX = -1;
    selected = NO;
    [self setNeedsDisplay:YES];
}
-(NSPoint)startPoint {
    return NSMakePoint(startCellX, startCellY);
}

-(NSPoint)endPoint {
    return NSMakePoint(endCellX, endCellY);
}

-(void)setStartPoint:(NSPoint)sPoint {
    startCellX = sPoint.x;
    startCellY = sPoint.y;
    selected = YES;
    [self setNeedsDisplay:YES];
}

-(void)setEndPoint:(NSPoint)ePoint {
    endCellX = ePoint.x;
    endCellY = ePoint.y;
    selected = YES;
    [self setNeedsDisplay:YES];
}

@end
