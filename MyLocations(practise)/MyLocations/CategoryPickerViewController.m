//
//  CategoryPickerViewController.m
//  MyLocations
//
//  Created by Matthijs on 11-10-13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "CategoryPickerViewController.h"

@implementation CategoryPickerViewController
{
  NSArray *_categories;
  NSIndexPath *_selectedIndexPath;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  _categories = @[
    @"No Category",
    @"Apple Store",
    @"Bar",
    @"Bookstore",
    @"Club",
    @"Grocery Store",
    @"Historic Building",
    @"House",
    @"Icecream Vendor",
    @"Landmark",
    @"Park"];

  self.tableView.backgroundColor = [UIColor blackColor];
  self.tableView.separatorColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"PickedCategory"]) {
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.selectedCategoryName = _categories[indexPath.row];
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

  NSString *categoryName = _categories[indexPath.row];
  cell.textLabel.text = categoryName;

  if ([categoryName isEqualToString:self.selectedCategoryName]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectedIndexPath = indexPath;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.backgroundColor = [UIColor blackColor];

  cell.textLabel.textColor = [UIColor whiteColor];
  cell.textLabel.highlightedTextColor = cell.textLabel.textColor;

  UIView *selectionView = [[UIView alloc] initWithFrame:CGRectZero];
  selectionView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
  cell.selectedBackgroundView = selectionView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row != _selectedIndexPath.row) {
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;

    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
    oldCell.accessoryType = UITableViewCellAccessoryNone;

    _selectedIndexPath = indexPath;
  }
}

@end
