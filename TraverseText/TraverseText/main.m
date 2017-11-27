//
//  main.m
//  TraverseText
//
//  Created by 许德鸿 on 2017/11/27.
//  Copyright © 2017年 XuDeHong. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSArray *array = @[@"one", @"two", @"three", @"four", @"five"];
        NSDictionary *dict = @{@"key1": @"object-one",
                               @"key2": @"object-two",
                               @"key3": @"object-three",
                               @"key4": @"object-four",
                               @"key5": @"object-five"
                               };
        NSSet *set = [NSSet setWithObjects:@"set1",@"set2",@"set3",@"set4",@"set5", nil];
        
        /***for循环遍历法***/
        NSLog(@"for循环遍历NSArray:");
        for (NSInteger i = 0; i < array.count; i++)
        {
            NSLog(@"%@",array[i]);
        }
        
        NSLog(@"for循环遍历NSDictionary:");
        NSArray *keys = [dict allKeys];
        for (NSInteger i = 0; i < keys.count; i++)
        {
            id key = keys[i];
            id value = dict[key];
            NSLog(@"key:%@  value:%@",key,value);
        }
        
        NSLog(@"for循环遍历NSSet:");
        NSArray *objects = [set allObjects];
        for (NSInteger i = 0; i < objects.count; i++)
        {
            NSLog(@"%@",objects[i]);
        }
        
        NSLog(@"for循环反向遍历NSArray:");
        for (NSInteger i = array.count - 1; i >= 0; i--)
        {
            NSLog(@"%@",array[i]);
        }
        
        /***NSEnumerator遍历法***/
        NSLog(@"NSEnumerator遍历NSArray:");
        NSEnumerator *arrayEnumerator = [array objectEnumerator];
        id arrayObject;
        while ((arrayObject = [arrayEnumerator nextObject]) != nil)
        {
            NSLog(@"%@",arrayObject);
        }
        
        NSLog(@"NSEnumerator遍历NSDictionary:");
        NSEnumerator *dictKeyEnumerator = [dict keyEnumerator];
        id key;
        while ((key = [dictKeyEnumerator nextObject]) != nil)
        {
            id value = dict[key];
            NSLog(@"key:%@  value:%@",key,value);
        }
        
        NSLog(@"NSEnumerator遍历NSSet:");
        NSEnumerator *setEnumerator = [set objectEnumerator];
        id setObject;
        while ((setObject = [setEnumerator nextObject]) != nil)
        {
            NSLog(@"%@",setObject);
        }
        
        NSLog(@"NSEnumerator反向遍历NSArray:");
        NSEnumerator *arrayReverseEnumerator = [array reverseObjectEnumerator];
        id arrayReverseObject;
        while ((arrayReverseObject = [arrayReverseEnumerator nextObject]) != nil)
        {
            NSLog(@"%@",arrayReverseObject);
        }
        
        /***快速遍历法***/
        NSLog(@"快速遍历NSArray:");
        for (id object in array)
        {
            NSLog(@"%@",object);
        }
        
        NSLog(@"快速遍历NSDictionary:");
        for (id key in dict)
        {
            id value = dict[key];
            NSLog(@"key:%@  value:%@",key,value);
        }
        
        NSLog(@"快速遍历NSSet:");
        for (id object in set)
        {
            NSLog(@"%@",object);
        }
        
        NSLog(@"快速反向遍历NSArray:");
        for (id object in [array reverseObjectEnumerator])
        {
            NSLog(@"%@",object);
        }
        
        /***基于Block的遍历法***/
        NSLog(@"基于Block遍历NSArray:");
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@",obj);
        }];
        
        NSLog(@"基于Block遍历NSDictionary:");
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSLog(@"key:%@  value:%@",key,obj);
        }];
        
        NSLog(@"基于Block遍历NSSet:");
        [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSLog(@"%@",obj);
        }];
        
        NSLog(@"基于Block反向遍历NSArray:");
        [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@",obj);
        }];
    }
    return 0;
}
