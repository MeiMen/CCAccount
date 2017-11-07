//
//  ZKCoreDataManager.h
//  CCAccount
//
//  Created by papa on 2017/11/6.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ZKCoreDataManager : NSObject
@property (nonatomic,strong) NSManagedObjectContext *managerContext;/**< */
@property (nonatomic,strong) NSManagedObjectModel *managerModel;/**< */
@property (nonatomic,strong) NSPersistentStoreCoordinator *managerDinator;/**< */

+ (ZKCoreDataManager *)shareInstance;

- (BOOL)save;

- (NSArray *)query;

@end
