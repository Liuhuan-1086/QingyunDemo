//
//  ContactCell.m
//  微社交
//
//  Created by qingyun on 16/9/2.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "ContactCell.h"
#import "ContactModel.h"

@interface ContactCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbName;

@end

@implementation ContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lbName.font = [UIFont systemFontOfSize:22];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *strId = @"ContactCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:strId owner:nil options:nil] lastObject];
    }
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    return cell;
}

- (void)setModel:(ContactModel *)model {
    _model = model;
    self.imgView.image = [UIImage imageWithData:model.imageData];
    if (model.mAttrStrUserName) {
        self.lbName.attributedText = model.mAttrStrUserName;
    }else if (model.strUserName) {
        self.lbName.text = model.strUserName;
    }else {
        
    }
}

@end

