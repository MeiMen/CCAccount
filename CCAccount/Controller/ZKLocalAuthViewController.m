//
//  ZKLocalAuthViewController.m
//  CCAccount
//
//  Created by papa on 2017/11/9.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKLocalAuthViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "ZKCoreDataManager.h"
#import "Records+CoreDataClass.h"
#define _ZKCoreDataManager [ZKCoreDataManager shareInstance]
@interface ZKLocalAuthViewController ()

@end

@implementation ZKLocalAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self canEvaluateLA];
    [self searchDayCcount];
}

- (void)searchDayCcount {
    
    NSMutableArray *expressionDescs = [NSMutableArray array];
    [expressionDescs addObject:@"day"];
    NSExpressionDescription *expressDesc1 = [[NSExpressionDescription alloc] init];
    expressDesc1.name = @"AmountAccount";
    expressDesc1.expression = [NSExpression expressionForFunction:@"sum:" arguments:@[[NSExpression expressionForKeyPath:@"amount"]]];
    [expressionDescs addObject:expressDesc1];
    NSFetchRequest *fetchRequest = [Records fetchRequest];
    fetchRequest.propertiesToGroupBy = @[@"day"];
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    fetchRequest.propertiesToFetch = expressionDescs;
    NSArray * results = [_ZKCoreDataManager.managerContext executeFetchRequest:fetchRequest error:nil];
    [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",[ self replaceUnicode:obj[@"AmountAccount"]]);
    }];
    
}


- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)canEvaluateLA{
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    BOOL canEvaluateLA = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (canEvaluateLA) {
        [self showAskLAAlert];
    }
}
- (void)showAskLAAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"验证成功" message:@"是否开启指纹验证？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *openAu = [UIAlertAction actionWithTitle:@"开启~" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:openAu];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)loadLocalAuthentication{
    
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
