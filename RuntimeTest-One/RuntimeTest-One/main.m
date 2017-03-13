//
//  main.m
//  RuntimeTest-One
//
//  Created by 许德鸿 on 2017/3/13.
//  Copyright © 2017年 XuDeHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_IPHONE_SIMULATOR
    #import <objc/objc-runtime.h>
#else
    #import <objc/runtime.h>
    #import <objc/message.h>
#endif

void oneFun(id self,SEL _cmd)
{
    NSLog(@"这是一个%@的方法，实例变量值为%@",[self class],object_getIvar(self,class_getInstanceVariable([self class], "_name")));
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        //动态创建一个类
        Class People = objc_allocateClassPair([NSObject class], "Person", 0);
        //给上面的类添加一个实例变量
        class_addIvar(People, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
        //注册一个方法名
        SEL fun = sel_registerName("say");
        //给类添加一个方法，方法名为say，方法实现为oneFun
        class_addMethod(People, fun, (IMP)oneFun,"v@:");
        //注册该类
        objc_registerClassPair(People);
        
        //创建一个类的实例
        id peopleInstance = [[People alloc] init];
        //获取类中的变量
        Ivar nameIvar = class_getInstanceVariable(People, "_name");
        //设置对象中的变量
        object_setIvar(peopleInstance, nameIvar, @"XuDeHong");
        //调用方法
        ((void(*)(id,SEL))objc_msgSend)(peopleInstance,fun);
        peopleInstance = nil;
        //销毁类
        objc_disposeClassPair(People);
        
    }
    return 0;
}
