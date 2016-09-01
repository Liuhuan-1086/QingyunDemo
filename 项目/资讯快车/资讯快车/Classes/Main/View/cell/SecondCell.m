//
//  SecondCell.m
//  资讯快车
//
//  Created by qingyun on 16/8/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "SecondCell.h"
#import "Model.h"
#import "UIImageView+WebCache.h"

@interface SecondCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UIImageView *firstImgView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImgView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdimgView;

@end

@implementation SecondCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *strId = @"SecondCell";
    SecondCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:strId owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(Model *)model {
    _model = model;
    self.lbTitle.text = _model.strTitle;
    [self.firstImgView sd_setImageWithURL:[NSURL URLWithString:_model.strImageUrl]];
    if (_model.arrImageUrls) {
        NSArray *arrImgUrls =@[_model.arrImageUrls[0][@"imgsrc"],_model.arrImageUrls[1][@"imgsrc"]];
        NSMutableArray *arrUrl = [NSMutableArray array];
        for (NSString *strUrl in arrImgUrls) {
            NSURL *url = [NSURL URLWithString:strUrl];
            [arrUrl addObject:url];
        }
        [self.secondImgView sd_setImageWithURL:arrUrl[0]];
        [self.thirdimgView sd_setImageWithURL:arrUrl[1]];
    }
}

@end
