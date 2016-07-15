//
//  ListViewController.m
//  TableViewDemo
//
//  Created by 许德鸿 on 16/7/15.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import "ListViewController.h"
#import "DataModel+CoreDataProperties.h"
#import <CoreData/CoreData.h>

@interface ListViewController ()

@property (strong,nonatomic)DataModel *data;

@end

@implementation ListViewController
{
    NSArray *dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadData];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    NSString *message = [NSString stringWithFormat:@"The data is %@ and %@",_data.titleText,_data.subtitleText];
//    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Text" message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [controller addAction:cancel];
//    
//    [self presentViewController:controller animated:YES completion:nil];
//}

-(void)loadData
{
    // 初始化一个查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // 设置要查询的实体
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DataModel" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // 执行请求
    
    NSError *error;
    dataArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (dataArray == nil) {
        
        //添加处理错误情况的代码
        NSLog(@"Error!");
        return;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)AddData:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    self.data = dataArray[indexPath.row];
    cell.textLabel.text = self.data.titleText;
    cell.detailTextLabel.text = self.data.subtitle;
    // Configure the cell...
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        self.data = dataArray[indexPath.row];
        [self.managedObjectContext deleteObject:self.data];//传入需要删除的数据对象（实体）
        
        NSError *error;
        
        if(![self.managedObjectContext save:&error])
            
        {
            
            //添加处理错误情况的代码
            
            return;
            
        }
        [self loadData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
