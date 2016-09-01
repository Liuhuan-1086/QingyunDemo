//
//  FirstCell.m
//  资讯快车
//
//  Created by qingyun on 16/8/7.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "FirstCell.h"
#import "Model.h"
#import "UIImageView+WebCache.h"

@interface FirstCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbSource;
@property (weak, nonatomic) IBOutlet UILabel *lbCount;

@end

@implementation FirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *strId = @"FirstCell";
    FirstCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:strId owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(Model *)model {
    _model = model;
    self.lbCount.text = [NSString stringWithFormat:@"%@浏览",_model.strCount];
    self.lbTitle.text = _model.strTitle;
    self.lbSource.text = [NSString stringWithFormat:@"来源: %@",_model.strSource];
    NSURL *url = [NSURL URLWithString:_model.strImageUrl];
    [self.imgView sd_setImageWithURL:url];
}

@end
