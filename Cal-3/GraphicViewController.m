//
//  GraphicViewController.m
//  Cal-3
//
//  Created by gress on 15/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import "GraphicViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CalendarViewController.h"
#import "DicColor.h"


@interface GraphicViewController ()

@end

@implementation GraphicViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSView *bgView = [[NSView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:bgView];
    }
    return self;
}






@end


