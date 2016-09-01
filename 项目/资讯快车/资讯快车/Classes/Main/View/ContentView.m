//
//  TableView.m
//  资讯快车
//
//  Created by qingyun on 16/8/10.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ContentView.h"
#import "HttpRequestManager.h"
#import "Model.h"
#import "SecondCell.h"
#import "FirstCell.h"
#import "WebViewController.h"
#import "MJRefresh.h"

@interface  ContentView ()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL _isRefresh;
}
@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, strong) NSMutableArray *mArrModels;

@end

@implementation ContentView

- (NSMutableArray *)mArrModels {
    if (!_mArrModels) {
        _mArrModels = [NSMutableArray array];
    }
    return _mArrModels;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        self.tableView = tableView;
        tableView.estimatedRowHeight = 100;
        self.pageNum = 0;
        __weak typeof(self) weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (_isRefresh) {
                weakSelf.pageNum = 0;
                NSInteger index = weakSelf.tag - 100;
                NSLog(@"%ld",(long)index);
                [weakSelf base_url_title_id:weakSelf.arr_title_id[index]];
                [weakSelf.tableView.mj_header endRefreshing];
                _isRefresh = NO;
            } else {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.pageNum+=20;
            
            NSInteger index = weakSelf.tag - 100;
            [weakSelf base_url_title_id:weakSelf.arr_title_id[index]];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }
    return self;
}

- (void)base_url_title_id:(NSString *)title_id {
    [[HttpRequestManager shareHttpRequestManager] request_list_data_title_id:title_id
                                                                        page:_pageNum
                                                                     success:^(id responseData) {
                                                                         [self.mArrModels addObjectsFromArray:responseData];
                                                                         [self.tableView reloadData];
    }
                                                                     failure:^(NSError *error) {
        
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mArrModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *_cell = nil;
    Model *model = self.mArrModels[indexPath.row];
    if ([model.strSkipType isEqualToString: @"photoset"]) {
        SecondCell *cell = [SecondCell cellWithTableView:tableView];
        cell.model = model;
        _cell = cell;
    } else {
        FirstCell *cell = [FirstCell cellWithTableView:tableView];
        cell.model = model;
        _cell = cell;
    }
    [_cell setSeparatorInset:UIEdgeInsetsZero];
    [_cell setLayoutMargins:UIEdgeInsetsZero];
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//http://c.m.163.com/news/a/BU4RCC4M00031H2L.html?spss=newsapp&spsw=1
//http://ent.163.com/photoview/00AJ0003/606983.html
    
    WebViewController *vcWeb = [[WebViewController alloc] init];
    Model *model = self.mArrModels[indexPath.row];
    NSString *strUrl = nil;
    NSInteger index = self.tag - 100;
    if ([model.strSkipType isEqualToString: @"photoset"]) {
        NSArray *arrSkipId = [model.strSkipId componentsSeparatedByString:@"|"];
        if (index == 0 || index == 3) {
            strUrl = [NSString stringWithFormat:@"http://news.163.com/photoview/%@/%@.html",arrSkipId[0],arrSkipId[1]];
        } else {
            strUrl = [NSString stringWithFormat:@"http://ent.163.com/photoview/%@/%@.html",arrSkipId[0],arrSkipId[1]];
        }
    } else {
        strUrl = [NSString stringWithFormat:@"http://c.m.163.com/news/a/%@.html?spss=newsapp&spsw=1",model.strDocId];
    }
    vcWeb.url = strUrl;
    _callBack(vcWeb);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if ( scrollView.contentOffset.y > scrollView.contentSize.height - screen_height +10) {
//        self.pageNum+=20;
//        NSInteger index = self.tag - 100;
//        [self base_url:self.arr_base_url[index] title_id:self.arr_title_id[index]];
//    }
//    if ([self.tableView.mj_header isRefreshing] || [self.tableView.mj_footer isRefreshing]) {
//        return;
//    }
//    if ( scrollView.contentOffset.y > scrollView.contentSize.height - screen_height +20) {
//        [self.tableView.mj_footer beginRefreshing];
//    }
//    if (scrollView.contentOffset.y < -20) {
////        [self.tableView.mj_header beginRefreshing];
//    }
}

@end
