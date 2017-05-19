//
//  WEHomeKitchenListViewController.m
//  woeat
//
//  Created by liubin on 16/10/14.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEHomeKitchenListViewController.h"
#import "WEHomeKitchenCellTableViewCell.h"
#import "WEHomeKitchenViewController.h"
#import "WEModelGetList.h"

@interface WEHomeKitchenListViewController ()
{
}
@end

@implementation WEHomeKitchenListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *superView = self.view;
    // Do any additional setup after loading the view.
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[WEHomeKitchenCellTableViewCell class] forCellReuseIdentifier:@"WEHomeKitchenCellTableViewCell"];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.scrollEnabled = NO;
   
    
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.top);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(superView.bottom);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)getModelAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    for(WEModelGetList *model in _dataArray) {
        row -= model.Kitchens.count;
        if (row < 0) {
            return model.Kitchens[row + model.Kitchens.count];
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#if 0
    return 0;
#endif
    
    int row = 0;
    for(WEModelGetList *model in _dataArray) {
        row += model.Kitchens.count;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"WEHomeKitchenCellTableViewCell";
    WEHomeKitchenCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    if (!cell) {
        cell = [[WEHomeKitchenCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden] ;
    }
#if 0
    return cell;
#endif
    
    id model = [self getModelAtIndexPath:indexPath];
    [cell setData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEHomeKitchenViewController *c = [WEHomeKitchenViewController new];
    id model = [self getModelAtIndexPath:indexPath];
    WEModelGetListKitchens *m = (WEModelGetListKitchens *)model;
    c.kitchenId = m.KitchenId;
    [self.navigationController pushViewController:c animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
