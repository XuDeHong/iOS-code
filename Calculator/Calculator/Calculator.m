//
//  Calculator.m
//  Calculator
//
//  Created by 许德鸿 on 16/2/5.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

@synthesize operand1,operand2,resultNum,resultStr;

-(id)init
{
    self=[super init];
    if(self)
    {
        //operand1=[[NSNumber alloc]init];
        //operand2=[[NSNumber alloc]init];
        //resultStr=[[NSString alloc]init];
    }
    return self;
}

-(NSString *)performOperation:(char)op
{
    switch (op) {
        case '+':[self add];
            break;
        case '-':[self subtract];
            break;
        case '*':[self multiply];
            break;
        case '/':[self divide];
            break;
        case 's':[self sin];
            break;
        case 'c':[self cos];
            break;
        case 't':[self tan];
            break;
    }
   if(op=='s'||op=='c'||op=='t')resultStr=[NSString stringWithFormat:@"%.11f",[self.resultNum doubleValue]];
    else
        resultStr=[NSString stringWithFormat:@"%.2f",[self.resultNum doubleValue]];
    return resultStr;
}

-(void) add
{
    double num=[self.operand1 doubleValue]+[self.operand2 doubleValue];
    resultNum=[NSNumber numberWithDouble:num];
}
-(void) subtract
{
    double num=[self.operand1 doubleValue]-[self.operand2 doubleValue];
    resultNum=[NSNumber numberWithDouble:num];
}
-(void) multiply
{
    double num=[self.operand1 doubleValue]*[self.operand2 doubleValue];
    resultNum=[NSNumber numberWithDouble:num];
}
-(void) divide
{
    double num=[self.operand1 doubleValue]/[self.operand2 doubleValue];
    resultNum=[NSNumber numberWithDouble:num];
}
-(void) sin
{
    double num=sin([self.operand1 doubleValue]);
    resultNum=[NSNumber numberWithDouble:num];
}
-(void) cos
{
    double num=cos([self.operand1 doubleValue]);
    resultNum=[NSNumber numberWithDouble:num];
}
-(void) tan
{
    double num=tan([self.operand1 doubleValue]);
    resultNum=[NSNumber numberWithDouble:num];
}
@end
