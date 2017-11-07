//
//  ZKCoreDataManager.m
//  CCAccount
//
//  Created by papa on 2017/11/6.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKCoreDataManager.h"
#import "Records+CoreDataClass.h"

@implementation ZKCoreDataManager

#pragma mark - life circle

- (instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}

#pragma public interface

+ (ZKCoreDataManager *)shareInstance{
    static dispatch_once_t onceToken;
    static ZKCoreDataManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[ZKCoreDataManager alloc] init];
    });
    return manager;
}

- (BOOL)save{
    NSError *error = nil;
   
    [self.managerContext save: &error];
    if (error) {
        return NO;
    }
    return YES;
}
- (NSArray *)query{
    //1.创建一个查询请求
    NSFetchRequest *request = [Records fetchRequest];
    //4.查询数据
    NSArray<Records*> *arr = [self.managerContext executeFetchRequest:request error:nil];
    return arr;
}

#pragma private
///获取文件位置
- (NSURL *)getDocumentUrlPath{
    return [[[NSFileManager defaultManager]  URLsForDirectory:
            NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
//懒加载ManagerContext
- (NSManagedObjectContext *)managerContext
{
    if (!_managerContext) {
        _managerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managerContext setPersistentStoreCoordinator:self.managerDinator];
    }
    return _managerContext;
}
//懒加载模型对象
- (NSManagedObjectModel *)managerModel{
    if (!_managerModel) {
        _managerModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managerModel;
}
- (NSPersistentStoreCoordinator *)managerDinator{
    if (!_managerDinator) {
        _managerDinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managerModel];
        NSURL *url = [[self getDocumentUrlPath]  URLByAppendingPathComponent:@"ChanSa.db" isDirectory:YES];
        [_managerDinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    }
    return _managerDinator;
}

@end
