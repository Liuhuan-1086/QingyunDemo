//
//  Common.h
//  微社交
//
//  Created by qingyun on 16/9/4.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define kUserNameRegex @"^[A-Za-z0-9]{6,20}+$"
#define kPassWordRegex @"^[a-zA-Z0-9]{6,20}+$"
#define kPhoneRegex @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
#define kEmailRegex @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

#define kScreenbounds [UIScreen mainScreen].bounds
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

#endif /* Common_h */
