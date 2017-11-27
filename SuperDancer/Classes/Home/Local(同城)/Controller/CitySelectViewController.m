//
//  CitySelectViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/26.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "CitySelectViewController.h"
#import "LocalSelectViewController.h"
#define kCityCellIdentifier @"CityCellIdentifier"
@interface CitySelectViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (nonatomic, strong)NSArray *searchResultList;
@property (nonatomic, strong)NSDictionary *cityList;
@property (nonatomic, strong)NSMutableArray *allCityList;
@property (nonatomic, strong)NSArray *abcList;
@end

@implementation CitySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择城市";
    _searchResultList = [NSArray new];
    
    [self initDataSource];

    [self.searchTableView setHidden:YES];
    self.searchTableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCityCellIdentifier];
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCityCellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = kDefaultColor;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        NSString *key = _abcList[section];
        return [_cityList[key] count];
    }else {
        return _searchResultList.count;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return _abcList.count;
    }else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCityCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *key = nil;
    NSDictionary *cityData = nil;
    if (tableView == _tableView) {
        key = _abcList[indexPath.section];
        cityData = _cityList[key][indexPath.row];
    }else {
        cityData = _searchResultList[indexPath.row];
        NSLog(@"%@", cityData);
    }
    cell.textLabel.text = cityData[@"city_name"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = kColorRGB(33, 33, 33);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return 25;
    }else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LocalSelectViewController *localSelect = [[LocalSelectViewController alloc] init];
    if (tableView == _tableView) {
        NSString *key = _abcList[indexPath.section];
        NSDictionary *dic = _cityList[key][indexPath.row];
        localSelect.cityID = dic[@"city_id"];
        localSelect.title = dic[@"city_name"];
    }else {
        NSDictionary *dic = _searchResultList[indexPath.row];
        localSelect.cityID = dic[@"city_id"];
        localSelect.title = dic[@"city_name"];
    }
    [self.navigationController pushViewController:localSelect animated:YES];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
//    view.backgroundColor = kColorRGB(249, 249, 249);
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 25)];
//    label.text = _abcList[section];
//    [view addSubview:label];
//
//    return view;
//}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return _abcList;
    }else {
        return nil;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return _abcList[section];
    }else {
        return nil;
    }
}


#pragma mark -- TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}




- (void)textFieldValueDidChanged:(NSNotification *)noti {
    [self search:_searchTF.text];
}

- (void)search:(NSString *)str {
    NSLog(@"%@", str);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city_name CONTAINS[cd] $KEY"];
    NSPredicate *keyPredicate = [predicate predicateWithSubstitutionVariables:[NSDictionary dictionaryWithObject:str forKey:@"KEY"]];
    
    NSLog(@"%@", [_allCityList filteredArrayUsingPredicate:keyPredicate]);
    _searchResultList = [_allCityList filteredArrayUsingPredicate:keyPredicate];
    if (_searchResultList.count > 0) {
        [_searchTableView setHidden:NO];
    }else {
        [_searchTableView setHidden:YES];
    }
    [_searchTableView reloadData];
    
}









#pragma mark -- 数据请求
- (void)initDataSource {
    [self showLoading];
    _cityList = [NSDictionary new];
    _abcList = [NSArray new];
    _allCityList = [NSMutableArray new];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kAllCityabc) parameters:nil success:^(id responseObject) {
        [self hideLoading];
        
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            _cityList = responseObject[@"data"][@"city_list"];
            _abcList = [_cityList allKeys];
            _abcList = [_abcList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
            NSLog(@"%@", _abcList);
            NSLog(@"%@", [_cityList objectForKey:@""]);
            for (NSString *key in _abcList) {
                NSArray *arr = _cityList[key];
                [_allCityList addObjectsFromArray:arr];
            }
        }else {
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
