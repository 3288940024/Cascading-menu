//
//  ViewController.m
//  级联菜单
//
//  Created by 杨英俊 on 18-1-10.
//  Copyright © 2018年 杨英俊. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *leftTable;
@property (nonatomic,strong) UITableView *rightTable;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,assign) BOOL isSelected;

@end

@implementation ViewController

- (NSArray *)array {
    if (_array == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
        _array = [NSArray arrayWithContentsOfFile:path];
    }
    return _array;
}

#pragma mark ~~~~~~~~~~ 页面加载 ~~~~~~~~~~
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSelected = NO;
    // 初始化表格视图
    [self initTableView];
    
}

static NSString *const resueIdleft = @"leftCell";
static NSString *const resueIdright = @"rightCell";
- (void)initTableView {
    self.leftTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width / 4, self.view.frame.size.height - 20) style:UITableViewStylePlain];
    self.leftTable.delegate = self;
    self.leftTable.dataSource = self;
    [self.view addSubview:self.leftTable];
    [self.leftTable registerClass:[UITableViewCell class] forCellReuseIdentifier:resueIdleft];
    [self.leftTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    self.rightTable = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 4, 20, self.view.frame.size.width / 4 * 3, self.view.frame.size.height - 20) style:UITableViewStylePlain];
    self.rightTable.dataSource = self;
    self.rightTable.delegate = self;
    [self.view addSubview:self.rightTable];
    [self.rightTable registerClass:[UITableViewCell class] forCellReuseIdentifier:resueIdright];
}


//#pragma mark - 直接刷新
//#pragma mark ~~~~~~~~~~ TableViewDataSource ~~~~~~~~~~
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (tableView == self.leftTable) {
//        return self.array.count;
//    }
//    // 获取选中leftTable那一行的数组
//    NSArray *arr = [self.array valueForKey:@"content"][self.leftTable.indexPathForSelectedRow.row];
//    return arr.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = nil;
//    if (tableView == self.leftTable) {
//        cell = [tableView dequeueReusableCellWithIdentifier:resueIdleft];
//        cell.textLabel.text = [self.array valueForKey:@"title"][indexPath.row];
//        return cell;
//    } else {
//        cell = [tableView dequeueReusableCellWithIdentifier:resueIdright];
//        // 获取选中leftTable那一行的数组
//        NSArray *arr = [self.array valueForKey:@"content"][self.leftTable.indexPathForSelectedRow.row];
//        cell.textLabel.text = arr[indexPath.row];
//        return cell;
//    }
//}
//
//#pragma mark ~~~~~~~~~~ TableViewDelegate ~~~~~~~~~~
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == self.leftTable) {
//        [self.rightTable reloadData];
//    }
//}


#pragma mark - 滚动刷新
#pragma mark ~~~~~~~~~~ TableViewDataSource ~~~~~~~~~~
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.rightTable) {
        return self.array.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTable) {
        return self.array.count;
    }
    // 获取选中leftTable那一行的数组
    NSArray *arr = [self.array valueForKey:@"content"][section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView == self.leftTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:resueIdleft];
        cell.textLabel.text = [self.array valueForKey:@"title"][indexPath.row];
        return cell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:resueIdright];
        // 获取选中leftTable那一行的数组
        NSArray *arr = [self.array valueForKey:@"content"][indexPath.section];
        cell.textLabel.text = arr[indexPath.row];
        return cell;
    }
}

#pragma mark ~~~~~~~~~~ TableViewDelegate ~~~~~~~~~~
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.rightTable) {
        return [self.array valueForKey:@"title"][section];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTable) {
        [self.rightTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.isSelected = YES;
    }
}

// 头部视图将要显示时调用
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (tableView == self.rightTable) {
        // 判断，如果是左边点击触发的滚动，这不执行下面代码
        if (self.isSelected) {
            return;
        }
        // 获取可见视图的第一个row
        NSInteger currentSection = [[[self.rightTable indexPathsForVisibleRows] firstObject] section];
        NSIndexPath *index = [NSIndexPath indexPathForRow:currentSection inSection:0];
        // 点击左边对应区块
        [self.leftTable selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

// 开始拖动赋值没有点击
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 当右边视图将要开始拖动时，则认为没有被点击了。
    self.isSelected = NO;
}


@end
