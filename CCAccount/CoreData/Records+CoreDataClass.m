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
@implementation Records
+ (Records *)newRecords{
    return [NSEntityDescription insertNewObjectForEntityForName:@"Records" inManagedObjectContext: [[ZKCoreDataManager shareInstance] managerContext]];
}

- (void)save{
    [[ZKCoreDataManager shareInstance] save];
}


@end
