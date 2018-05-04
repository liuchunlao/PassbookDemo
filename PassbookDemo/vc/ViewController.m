//
//  ViewController.m
//  PassbookDemo
//
//  Created by liuchunlao on 2018/5/4.
//  Copyright © 2018年 liuchunlao. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>

@interface ViewController ()

@end

@implementation ViewController {
    NSArray *_dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadPasses];
}


/**
 从bundle中加载passes文件！
 */
- (void)loadPasses {
    
    // 1.获取bundle中的所有文件
    NSArray<NSString *> *resourceFile = [[NSFileManager defaultManager] subpathsAtPath:[[NSBundle mainBundle] resourcePath]];
    
    // 2.找出pass文件
    NSLog(@"%@", resourceFile);
    NSMutableArray<NSString *> *tempArrM = [NSMutableArray array];
    [resourceFile enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj hasSuffix:@".pkpass"]) {
            
            NSString *str = [obj lastPathComponent];
            [tempArrM addObject:str];
        }
    }];
    NSLog(@"%@", tempArrM);
    _dataList = tempArrM.copy;
    [self.tableView reloadData];
    
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 1.获取pass文件的全部路径
    NSString *passName = _dataList[indexPath.row];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:passName];
    
    // 2.转为NSData数据
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    // 3.创建pass
    NSError *error;
    PKPass *pass = [[PKPass alloc] initWithData:data error:&error];
    
    if (error) {
        NSLog(@"无法添加至Wallet! %@", error);
        return;
    }
    
    // 4.创建并显示passVc
    PKAddPassesViewController *vc = [[PKAddPassesViewController alloc] initWithPass:pass];
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"xmg";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.textLabel.text = _dataList[indexPath.row];
    
    return cell;
}

@end
