//
//  ViewController.h
//  Calculator
//
//  Created by 许德鸿 on 16/2/5.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calculator.h"


@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;

-(void)pressOp:(char)op;
-(void)displayResult;
-(void)storeNum;


-(IBAction)pressDigit:(UIButton *)sender;
-(IBAction)pressEqual:(id)sender;
- (IBAction)clickPlus:(id)sender;
- (IBAction)clickMins:(id)sender;
- (IBAction)clickMultiply:(id)sender;
- (IBAction)clickDivide:(id)sender;
- (IBAction)pressClear:(id)sender;
- (IBAction)sincal:(id)sender;
- (IBAction)coscal:(id)sender;
- (IBAction)tancal:(id)sender;
- (IBAction)pressDecimal:(id)sender;

@end

