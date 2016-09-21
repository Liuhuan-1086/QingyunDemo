//
//  NSString+Date.m
//  微社交
//
//  Created by qingyun on 16/9/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

+ (NSString *)stringWithDate:(NSDate *)date {
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = [nowDate timeIntervalSinceDate:date];
    NSDateFormatter *formater1 = [[NSDateFormatter alloc] init];
    NSDateFormatter *formater2 = [[NSDateFormatter alloc] init];
    formater1.dateFormat = @"HH:mm:ss";
    formater2.dateFormat = @"MM-dd";
    if (interval < 60) {
        return @"刚刚";
    }else if (interval > 60 && interval < 60 * 15){
        return [NSString stringWithFormat:@"%ld分钟前", (NSInteger)interval];
    }else if (interval > 60 * 15 && interval < 60 * 30){
        return [NSString stringWithFormat:@"半小时内"];
    }else if (interval > 60 * 30 && interval < 60 * 60){
        return [NSString stringWithFormat:@"1小时内"];
    }else if (interval > 60 * 60){
        return [formater1 stringFromDate:date];
    }else {
        return [formater2 stringFromDate:date];
    }
    return nil;
}

@end
