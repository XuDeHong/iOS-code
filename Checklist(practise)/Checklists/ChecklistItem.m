//
//  ChecklistItem.m
//  Checklists
//
//  Created by Matthijs on 30-09-13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "ChecklistItem.h"
#import "DataModel.h"

@implementation ChecklistItem

- (id)init
{
  if (self = [super init]) {
    self.itemId = [DataModel nextChecklistItemId];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super init])) {
    self.text = [aDecoder decodeObjectForKey:@"Text"];
    self.checked = [aDecoder decodeBoolForKey:@"Checked"];
    self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
    self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
    self.itemId = [aDecoder decodeIntegerForKey:@"ItemID"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:self.text forKey:@"Text"];
  [aCoder encodeBool:self.checked forKey:@"Checked"];
  [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
  [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
  [aCoder encodeInteger:self.itemId forKey:@"ItemID"];
}

- (void)toggleChecked
{
  self.checked = !self.checked;
}

- (void)scheduleNotification
{
  UILocalNotification *existingNotification = [self notificationForThisItem];
  if (existingNotification != nil) {
    NSLog(@"Found an existing notification %@", existingNotification);
    [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
  }

  if (self.shouldRemind && [self.dueDate compare:[NSDate date]] != NSOrderedAscending) {

    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = self.dueDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = self.text;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.userInfo = @{ @"ItemID" : @(self.itemId) };

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    NSLog(@"Scheduled notification %@ for itemId %d", localNotification, self.itemId);
  }
}

- (UILocalNotification *)notificationForThisItem
{
  NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
  for (UILocalNotification *notification in allNotifications) {
    NSNumber *number = [notification.userInfo objectForKey:@"ItemID"];
    if (number != nil && [number integerValue] == self.itemId) {
      return notification;
    }
  }
  return nil;
}

- (void)dealloc
{
  UILocalNotification *existingNotification = [self notificationForThisItem];
  if (existingNotification != nil) {
    NSLog(@"Removing existing notification %@", existingNotification);
    [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
  }
}

@end
