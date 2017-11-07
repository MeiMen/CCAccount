//
//  Records+CoreDataClass.h
//  CCAccount
//
//  Created by mac on 2017/11/6.
//  Copyright © 2017年 ZK. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Records : NSManagedObject
+ (Records *)newRecords;
- (void)save;
@end

NS_ASSUME_NONNULL_END

#import "Records+CoreDataProperties.h"
