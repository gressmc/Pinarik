//
//  AppDelegate.h
//  Cal-3
//
//  Created by gress on 12/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class ViewController;
@class GraphicViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) GraphicViewController *viewController2;

@end

