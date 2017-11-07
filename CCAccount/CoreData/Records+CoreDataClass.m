//
//  Records+CoreDataClass.m
//  CCAccount
//
//  Created by mac on 2017/11/6.
//  Copyright © 2017年 ZK. All rights reserved.
//
//

#import "Records+CoreDataClass.h"
#import "ZKCoreDataManager.h"

#define _ZKCoreDataManager [ZKCoreDataManager shareInstance]

@implementation Records
+ (Records *)newRecords{
    return [NSEntityDescription insertNewObjectForEntityForName:@"Records" inManagedObjectContext: [_ZKCoreDataManager managerContext]];
}

- (void)save{
    [[ZKCoreDataManager shareInstance] save];
}
- (void)deleteObj{
    [_ZKCoreDataManager.managerContext deleteObject:self];
    // 保存上下文环境，并做错误处理
    NSError *error = nil;
    if (![_ZKCoreDataManager.managerContext save:&error]) {
        NSLog(@"tableView delete cell error : %@", error);
    }
}

#pragma mark - operation
+ (float)totalAmount{
    
    NSFetchRequest *fetchRequest = [Records fetchRequest];
    //设置返回值为字典类型，这是为了结果可以通过设置的name名取出，这一步是必须的
    fetchRequest.resultType = NSDictionaryResultType;
    
    // 创建描述对象
    NSExpressionDescription *expressionDes = [[NSExpressionDescription alloc] init];
    // 设置描述对象的name，最后结果需要用这个name当做key来取出结果
    expressionDes.name = @"sumOperatin";
    // 设置返回值类型，根据运算结果设置类型
    expressionDes.expressionResultType = NSFloatAttributeType;
    
    // 创建具体描述对象，用来描述对那个属性进行什么运算(可执行的运算类型很多，这里描述的是对height属性，做sum运算)
    NSExpression *expression = [NSExpression expressionForFunction:@"sum:" arguments:@[[NSExpression expressionForKeyPath:@"amount"]]];
    // 只能对应一个具体描述对象
    expressionDes.expression = expression;
    // 给请求对象设置描述对象，这里是一个数组类型，也就是可以设置多个描述对象
    fetchRequest.propertiesToFetch = @[expressionDes];
    
    // 执行请求，返回值还是一个数组，数组中只有一个元素，就是存储计算结果的字典
    NSError *error = nil;
    NSArray *resultArr = [[_ZKCoreDataManager managerContext] executeFetchRequest:fetchRequest error:&error];
    // 通过上面设置的name值，当做请求结果的key取出计算结果
    NSNumber *sum = resultArr.firstObject[@"sumOperatin"];
    NSLog(@"fetch request result is %f", [sum floatValue]);
    
    // 错误处理
    if (error) {
        NSLog(@"fetch request result error : %@", error);
    }
    
    return [sum floatValue];
    
}

@end
