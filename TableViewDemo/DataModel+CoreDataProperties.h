//
//  DataModel+CoreDataProperties.h
//  TableViewDemo
//
//  Created by 许德鸿 on 16/7/15.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *titleText;
@property (nullable, nonatomic, retain) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
