//
//  ViewController.m
//  TableViewDemo
//
//  Created by 许德鸿 on 16/7/15.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import "ViewController.h"
#import "ListViewController.h"
#import "DataModel+CoreDataProperties.h"
#import <CoreData/CoreData.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *subTitle;
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (strong,nonatomic) DataModel *data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    self.titleText.text = @"";
    self.subTitle.text = @"";
    [self.titleText becomeFirstResponder];
}

- (IBAction)SaveData:(id)sender {
    self.data = [NSEntityDescription insertNewObjectForEntityForName:@"DataModel" inManagedObjectContext:self.managedObjectContext];
    self.data.titleText = self.titleText.text;
    self.data.subtitle = self.subTitle.text;
    //NSLog(@"The data is %@ and %@",self.data.titleText,self.data.subtitle);
    NSError *error;
    if(![self.managedObjectContext save:&error])
        
    {
        
        //添加处理错误情况的代码
        NSLog(@"Error!");
        return;
    }
}
- (IBAction)printList:(id)sender {
    [self performSegueWithIdentifier:@"printlist" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"printlist"])
    {
        UINavigationController *controller = segue.destinationViewController;
        ListViewController *listViewController = (ListViewController *)controller.topViewController;
        listViewController.managedObjectContext = self.managedObjectContext;
    }
}


@end
