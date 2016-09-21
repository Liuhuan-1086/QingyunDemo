//
//  MsgCell.m
//  微社交
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "MsgCell.h"
#import "MsgModel.h"

@interface MsgCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbMessage;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@end

@implementation MsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.layer.cornerRadius = self.imgView.bounds.size.width * 0.5;
    self.imgView.layer.masksToBounds = YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NSString *strId = NSStringFromClass([self class]);
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:strId owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(MsgModel *)model {
    _model = model;
    self.lbTime.text = model.strTime;
    self.lbName.text = model.strUserName;
    self.lbMessage.text = model.strMessage;
    self.imgView.image = [UIImage imageWithData:model.imageData];
}

@end
