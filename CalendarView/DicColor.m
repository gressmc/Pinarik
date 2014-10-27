//
//  DicColor.m
//  Cal-3
//
//  Created by gress on 13/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import "DicColor.h"

@implementation DicColor
@synthesize colorCheck;
NSString *const RAMDateColorGreenKey = @"RAMDateColorGreenKey";
NSString *const RAMDateColorRedKey = @"RAMDateColorRedKey";

+(void)initialize {
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    
    greenDate = [NSMutableArray array];
    [greenDate addObjectsFromArray:[self savedGreen]];
    redDate = [NSMutableArray array];
    [redDate addObjectsFromArray:[self savedRed]];
    
    [defaultValues setObject:greenDate forKey:RAMDateColorGreenKey];
    [defaultValues setObject:redDate forKey:RAMDateColorRedKey];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

+(NSArray *) savedGreen{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *greenDate = [defaults objectForKey:RAMDateColorGreenKey];
    return greenDate;
}

+(void) setSaveGreen:(NSMutableArray*)greenDate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:greenDate forKey:RAMDateColorGreenKey];
}

+(NSArray *) savedRed{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *redDate = [defaults objectForKey:RAMDateColorRedKey];
    return redDate;
}
+(void) setSaveRed:(NSMutableArray*)redDate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:redDate forKey:RAMDateColorRedKey];
}




-(void)dateToGreen:(NSString *)str {
    [greenDate addObject:str];
    NSLog(@"%@ - %lu GREEN Add- %@", str, (unsigned long)[greenDate count], greenDate );
    [DicColor setSaveGreen:greenDate];
}

-(void)dateToRed:(NSString *)str {
    [redDate addObject:str];
    NSLog(@"%@ - %lu RED Add- %@", str, (unsigned long)[redDate count], redDate );
    [DicColor setSaveRed:redDate];
}

-(void)removeFromGreen:(NSString *)str {
    [greenDate removeObject:str];
    NSLog(@"%@ - %lu GREEN Remove- %@", str, (unsigned long)[greenDate count], greenDate );
    [DicColor setSaveGreen:greenDate];
}

-(void)removeFromRed:(NSString *)str {
    [redDate removeObject:str];
    NSLog(@"%@ - %lu RED Remove - %@", str, (unsigned long)[redDate count], redDate );
     [DicColor setSaveRed:redDate];
}

-(BOOL)dateSetInGreen:(NSString *)str{
    if ([greenDate containsObject:str]) {
        return YES;
    } else{
        return NO;
    }
}

-(BOOL)dateSetInRed:(NSString *)str{
    if ([redDate containsObject:str]) {
        return YES;
    } else{
        return NO;
    }
}

- (void)setColorDic:(NSString*)str{
    
    if ([redDate count] == 0 && !([self dateSetInGreen:str])) {
        [self dateToRed:str];
    } else if ([self dateSetInRed:str]) {
        [self dateToGreen:str];
        [self removeFromRed:str];
    } else if ([self dateSetInGreen:str]) {
        
        [self removeFromGreen:str];
    } else {
        [self dateToRed:str];
    }
}

@end
