//
//  MsgModel.h
//  微社交
//
//  Created by qingyun on 16/9/14.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgModel : NSObject

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, copy) NSString *strUserName;
@property (nonatomic, copy) NSString *strMessage;
@property (nonatomic, copy) NSString *strTime;

+ (instancetype) modelWithDictionary:(NSDictionary *)dict;
- (instancetype) initWithDictionary:(NSDictionary *)dict;

@end
