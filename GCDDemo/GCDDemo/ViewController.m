//
//  ViewController.m
//  GCDDemo
//
//  Created by 许德鸿 on 16/7/22.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

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
- (IBAction)downloadTask:(id)sender {
    self.displayLabel.text = @"Main Task is doing...";
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSLog(@"Downloading...");
        sleep(5);
        NSLog(@"DONE!");
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Download is done!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [controller addAction:action];
            [self presentViewController:controller animated:YES completion:nil];
        });
    });
}

- (IBAction)mainTask:(id)sender {

    sleep(1);
    self.displayLabel.text = @"DONE";
}


@end
