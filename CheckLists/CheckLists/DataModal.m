//
//  DataModal.m
//  CheckLists
//
//  Created by 许德鸿 on 16/1/29.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import "DataModal.h"
#import "Checklist.h"

@implementation DataModal
@synthesize lists;

-(void)registerDefaults
{
    NSDictionary *dictionary=@{@"ChecklistIndex":@-1,@"FirstTime":@YES,@"ChecklistItemId":@0};
    [[NSUserDefaults standardUserDefaults]registerDefaults:dictionary];
}
-(id)init
{
    if((self=[super init]))
    {
        [self loadChecklists];
        [self registerDefaults];
        [self handleFirstTime];
    }
    return self;
}

-(NSString *)documentsDriectory
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths firstObject];
    return documentsDirectory;
}

-(NSString *)dataFilePath
{
    return [[self documentsDriectory]stringByAppendingPathComponent:@"Checklists.plist"];
}

-(void)saveChecklists
{
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.lists forKey:@"Checklists"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
    //NSLog(@"数据文件的最终路径是：%@",[self dataFilePath]);
}

-(void)loadChecklists
{
    NSString *path=[self dataFilePath];
    if([[NSFileManager defaultManager]fileExistsAtPath:path])
    {
        NSData *data=[[NSData alloc]initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        self.lists=[unarchiver decodeObjectForKey:@"Checklists"];
        [unarchiver finishDecoding];
    }
    else
    {
        self.lists=[[NSMutableArray alloc]initWithCapacity:20];
    }
}

-(NSInteger)indexOfSelectedChecklist
{
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"ChecklistIndex"];
}

-(void)setIndexOfSelectedChecklist:(NSInteger)index
{
    [[NSUserDefaults standardUserDefaults]setInteger:index forKey:@"ChecklistIndex"];
}

-(void)handleFirstTime
{
    BOOL firstTime=[[NSUserDefaults standardUserDefaults]boolForKey:@"FirstTime"];
    if(firstTime)
    {
        Checklist *checklist=[[Checklist alloc]init];
        checklist.name=@"List";
        [self.lists addObject:checklist];
        [self setIndexOfSelectedChecklist:0];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FirstTime"];
    }
}

-(void)sortChecklists
{
    [self.lists sortUsingSelector:@selector(compare:)];
}

+(NSInteger)nextChecklistItemId
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSInteger itemId=[userDefaults integerForKey:@"ChecklistItemId"];
    [userDefaults setInteger:itemId+1 forKey:@"ChecklistItemId"];
    [userDefaults synchronize];
    return itemId;
}
@end
