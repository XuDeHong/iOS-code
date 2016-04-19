//
//  Calculator.h
//  Calculator
//
//  Created by 许德鸿 on 16/2/5.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h>

@interface Calculator : NSObject

@property(strong,nonatomic) NSNumber *operand1;
@property(strong,nonatomic) NSNumber *operand2;
@property(strong,nonatomic) NSNumber *resultNum;
@property(strong,nonatomic) NSString *resultStr;

-(NSString *)performOperation:(char)op;
-(void) add;
-(void) subtract;
-(void) multiply;
-(void) divide;
-(void) sin;
-(void) cos;
-(void) tan;
@end
