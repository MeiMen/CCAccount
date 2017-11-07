//
//  Records+CoreDataProperties.m
//  CCAccount
//
//  Created by mac on 2017/11/6.
//  Copyright © 2017年 ZK. All rights reserved.
//
//

#import "Records+CoreDataProperties.h"

@implementation Records (CoreDataProperties)

+ (NSFetchRequest<Records *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Records"];
}

@dynamic amount;
@dynamic date;
@dynamic desc;
@dynamic purpose;
@dynamic month;
@dynamic year;
@dynamic day;

@end
