//
//  ContactModel.h
//  微社交
//
//  Created by qingyun on 16/9/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactModel : NSObject

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, copy) NSString *strUserName;
@property (nonatomic, strong) NSMutableAttributedString *mAttrStrUserName;

+ (instancetype) modelWithDictionary:(NSDictionary *)dict;
- (instancetype) initWithDictionary:(NSDictionary *)dict;

@end
