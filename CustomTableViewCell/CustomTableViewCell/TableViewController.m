//
//  TableViewController.m
//  CustomTableViewCell
//
//  Created by 许德鸿 on 16/7/16.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import "TableViewController.h"
#import "DataModel.h"
#import "CustomCell.h"

@interface TableViewController ()

@end

@implementation TableViewController
{
    NSMutableArray *dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)initData //初始化数据
{
    dataArray = [NSMutableArray arrayWithCapacity:20];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:@"1.jpg",@"profileImage", @"XuDeHong",@"userName",@"Hello!",@"talkContent",@"today",@"lastTime",nil];
    DataModel *dataModel = [DataModel dataModelWithDictionary:data];
    
    [dataArray addObject:dataModel];
    
    data = [NSDictionary dictionaryWithObjectsAndKeys:@"2.jpg",@"profileImage", @"XuDeHong",@"userName",@"Hello!",@"talkContent",@"today",@"lastTime",nil];
    dataModel = [DataModel dataModelWithDictionary:data];
    [dataArray addObject:dataModel];
    
    data = [NSDictionary dictionaryWithObjectsAndKeys:@"3.jpg",@"profileImage", @"XuDeHong",@"userName",@"Hello!",@"talkContent",@"today",@"lastTime",nil];
    dataModel = [DataModel dataModelWithDictionary:data];
    [dataArray addObject:dataModel];
    
    data = [NSDictionary dictionaryWithObjectsAndKeys:@"4.jpg",@"profileImage", @"XuDeHong",@"userName",@"Hello!",@"talkContent",@"today",@"lastTime",nil];
    dataModel = [DataModel dataModelWithDictionary:data];
    [dataArray addObject:dataModel];
    
    data = [NSDictionary dictionaryWithObjectsAndKeys:@"5.jpg",@"profileImage", @"XuDeHong",@"userName",@"Hello!",@"talkContent",@"today",@"lastTime",nil];
    dataModel = [DataModel dataModelWithDictionary:data];
    [dataArray addObject:dataModel];
    
    data = [NSDictionary dictionaryWithObjectsAndKeys:@"6.jpg",@"profileImage", @"XuDeHong",@"userName",@"Hello!",@"talkContent",@"today",@"lastTime",nil];
    dataModel = [DataModel dataModelWithDictionary:data];
    [dataArray addObject:dataModel];
    
    data = [NSDictionary dictionaryWithObjectsAndKeys:@"7.jpg",@"profileImage", @"XuDeHong",@"userName",@"Hello!",@"talkContent",@"today",@"lastTime",nil];
    dataModel = [DataModel dataModelWithDictionary:data];
    [dataArray addObject:dataModel];
    
    data = [NSDictionary dictionaryWithObjectsAndKeys:@"8.jpg",@"profileImage", @"XuDeHong",@"userName",@"Hello!",@"talkContent",@"today",@"lastTime",nil];
    dataModel = [DataModel dataModelWithDictionary:data];
    [dataArray addObject:dataModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomCell"; //CustomCell的XIB文件定义的Reuse Identifier
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil]lastObject];    //通过XIB文件加载cell
    }
    DataModel *data = dataArray[indexPath.row];
    
    cell.profileImage.image =[UIImage imageNamed:data.profileImage];
    cell.userName.text = data.userName;
    cell.talkContent.text = data.talkContent;
    cell.lastTime.text = data.lastTime;
    
    
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 54;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
