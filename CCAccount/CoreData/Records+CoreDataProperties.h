//
//  Records+CoreDataProperties.h
//  CCAccount
//
//  Created by mac on 2017/11/6.
//  Copyright © 2017年 ZK. All rights reserved.
//
//

#import "Records+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Records (CoreDataProperties)

+ (NSFetchRequest<Records *> *)fetchRequest;

@property (nonatomic) float amount;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSString *purpose;
@property (nullable, nonatomic, copy) NSString *month;
@property (nullable, nonatomic, copy) NSString *year;
@property (nullable, nonatomic, copy) NSString *day;

@end

NS_ASSUME_NONNULL_END
