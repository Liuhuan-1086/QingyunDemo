//
//  ItemCard.h
//  微社交
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemCardDelegate <NSObject>

- (void)pushToViewController:(UIViewController *)vc;

@end

@interface ItemCard : UIView

@property (nonatomic, weak) id<ItemCardDelegate> delegate;

@end
