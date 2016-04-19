//
//  ViewController.m
//  Calculator
//
//  Created by 许德鸿 on 16/2/5.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    BOOL firstOperand,isNegative,isDecimal;
    char theOp;
    double currentNum;
    double tag;
    NSMutableString *displayString;
    Calculator *myCalculator;
}

@synthesize display;

- (void)viewDidLoad {
    [super viewDidLoad];
    firstOperand=YES;
    theOp=0;
    tag=1;
    displayString=[NSMutableString stringWithCapacity:40];
    myCalculator=[[Calculator alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pressOp:(char)op
{
    NSString *opStr;
    switch (op)
    {
        case '+':opStr=@" + ";
            break;
        case '-':if(currentNum==0&&isNegative==NO)
                 {
                     isNegative=YES;
                     opStr=@"-";
                     [displayString appendString:opStr];
                     [self displayResult];
                     return;
                 }
                 else
                    opStr=@" - ";
            break;
        case '*':opStr=@" × ";
            break;
        case '/':opStr=@" ÷ ";
            break;
    }
    [displayString appendString:opStr];
    [self displayResult];
    theOp=op;
    [self storeNum];
    if(isDecimal==YES)
    {
        isDecimal=NO;
        tag=1;
    }
    firstOperand=NO;
}

-(void)displayResult
{
    self.display.text=displayString;
}

-(void)storeNum
{
    if(firstOperand)
    {
        if(isNegative!=YES)myCalculator.operand1=[NSNumber numberWithDouble:currentNum];
        else
        {
            myCalculator.operand1=[NSNumber numberWithDouble:currentNum*(-1)];
            isNegative=NO;
        }

    }
    else
    {
        if(isNegative!=YES)myCalculator.operand2=[NSNumber numberWithDouble:currentNum];
        else
        {
            myCalculator.operand2=[NSNumber numberWithDouble:currentNum*(-1)];
            isNegative=NO;
        }
        
    }
    currentNum=0;
}

-(IBAction)pressDigit:(UIButton *)sender
{
    int digit=(int)sender.tag;
//    if((currentNum!=0||digit!=0||theOp!=0)&&isDecimal==NO)
//    {
//        currentNum=currentNum*10+digit;
//    }
//    else if(isDecimal==YES)
//    {
//        tag*=10;
//        currentNum=currentNum+digit/tag;
//    }
    [displayString appendString:[NSString stringWithFormat:@"%i",digit]];
    [self displayResult];
}

-(IBAction)pressEqual:(id)sender
{
    if(theOp!=0)
    {
        [self storeNum];
        [displayString setString:[myCalculator performOperation:theOp]];
        [self displayResult];
    }
}

- (IBAction)clickPlus:(id)sender {
    if(currentNum!=0)   [self pressOp:'+'];
}

- (IBAction)clickMins:(id)sender {
    [self pressOp:'-'];
}

- (IBAction)clickMultiply:(id)sender {
    if(currentNum!=0)   [self pressOp:'*'];
}

- (IBAction)clickDivide:(id)sender {
    if(currentNum!=0)   [self pressOp:'/'];
}

- (IBAction)pressClear:(id)sender {
    firstOperand=YES;
    isDecimal=NO;
    currentNum=0;
    theOp=0;
    tag=1;
    myCalculator.operand1=[NSNumber numberWithDouble:0];
    myCalculator.operand1=[NSNumber numberWithDouble:0];
    [displayString setString:@"0"];
    [self displayResult];
}

- (IBAction)sincal:(id)sender {
    if(currentNum!=0&&theOp==0)
    {
        myCalculator.operand1=[NSNumber numberWithDouble:currentNum/180.0*3.14159];
        display.text=[myCalculator performOperation:'s'];
    }
}

- (IBAction)coscal:(id)sender {
    if(currentNum!=0&&theOp==0)
    {
        myCalculator.operand1=[NSNumber numberWithDouble:currentNum/180.0*3.14159];
        display.text=[myCalculator performOperation:'c'];
    }
}

- (IBAction)tancal:(id)sender {
    if(currentNum!=0&&theOp==0)
    {
        myCalculator.operand1=[NSNumber numberWithDouble:currentNum/180.0*3.14159];
        display.text=[myCalculator performOperation:'t'];
    }
}

- (IBAction)pressDecimal:(id)sender {
    if(isDecimal==NO)
    {
        isDecimal=YES;
        [displayString appendString:@"."];
        [self displayResult];
    }
}

@end
