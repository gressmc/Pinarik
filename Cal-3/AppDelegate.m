//
//  AppDelegate.m
//  Cal-3
//
//  Created by gress on 12/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AXStatusItemPopup.h"
#import "GraphicViewController.h"

@interface AppDelegate () {
    AXStatusItemPopup *_statusItemPopup;
}
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate
@synthesize viewController = _viewController;
@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
   
    ViewController *contentViewController = [[ViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
  
    // init the status item popup
    NSImage *image = [NSImage imageNamed:@"cloud"];
    NSImage *alternateImage = [NSImage imageNamed:@"cloudgrey"];
    
    _statusItemPopup = [[AXStatusItemPopup alloc] initWithViewController:contentViewController image:image alternateImage:alternateImage];
    
   // _statusItemPopup = [[AXStatusItemPopup alloc] initWithViewController:contentViewController2 image:image alternateImage:alternateImage];
    self.viewController2 = [[GraphicViewController alloc] initWithNibName:@"GraphicViewController" bundle:nil];
    self.window.contentViewController = self.viewController2;
    [self.window makeMainWindow];
    [self.window orderOut:self];
    [self.window setHidesOnDeactivate:YES];
    
    // globally set animation state (optional, defaults to YES)
    _statusItemPopup.animated = YES;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(showWin) name:RAMMouseGraphNotification object:nil];
    
   // optionally set the popover to the contentview to e.g. hide it from there
    contentViewController.statusItemPopup = _statusItemPopup;
    [contentViewController.view setHidden:NO];
}

-(void)showWin{
    [NSApp activateIgnoringOtherApps:YES];
    [_window makeKeyAndOrderFront:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
