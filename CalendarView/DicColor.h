//
//  DicColor.h
//  Cal-3
//
//  Created by gress on 13/08/14.
//  Copyright (c) 2014 Roman Radetskiy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const RAMDateColorGreenKey;
extern NSString *const RAMDateColorRedKey;
 NSMutableArray *greenDate;
 NSMutableArray *redDate;


@interface DicColor : NSObject {
    NSInteger *colorCheck;
    
    
}
@property NSInteger *colorCheck;

+(NSArray *) savedGreen;
+(void) setSaveGreen:(NSMutableArray*)greenDate;
+(NSArray *) savedRed;
+(void) setSaveRed:(NSMutableArray*)redDate;

-(void)dateToGreen:(NSString *)str;
-(void)dateToRed:(NSString *)str;
-(void)removeFromGreen:(NSString *)str;
-(void)removeFromRed:(NSString *)str ;
-(BOOL)dateSetInGreen:(NSString *)str;
-(BOOL)dateSetInRed:(NSString *)str;
- (void)setColorDic:(NSString*)str;

@end
