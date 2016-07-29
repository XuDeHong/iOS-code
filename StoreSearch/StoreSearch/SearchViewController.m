//
//  SearchViewController.m
//  StoreSearch
//
//  Created by 许德鸿 on 16/7/20.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResult.h"
#import "SearchResultCell.h"
#import <AFNetworking/AFNetworking.h>
#import "DetailViewController.h"
#import "LandscapeViewController.h"
#import "Search.h"

static NSString * const SearchResultCellIdentifier = @"SearchResultCell";
static NSString * const NothingFoundCellIdentifier = @"NothingFoundCell";
static NSString * const LoadingCellIdentifier = @"LoadingCell";

@interface SearchViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation SearchViewController
{
    LandscapeViewController *_landscapeViewController;
    UIStatusBarStyle _statusBarStyle;
    __weak DetailViewController *_detailViewController;
    Search *_search;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(108, 0, 0, 0);
    
    UINib *cellNib = [UINib nibWithNibName:SearchResultCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SearchResultCellIdentifier];
    
    cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    
    cellNib = [UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:LoadingCellIdentifier];
    
    self.tableView.rowHeight = 80;
    [self.searchBar becomeFirstResponder];
    _statusBarStyle = UIStatusBarStyleDefault;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        [self hideLandscapeViewWithDuration:duration];
    }
    else
    {
        [self showLandscapeViewWithDuration:duration];
    }
}

-(void)showLandscapeViewWithDuration:(NSTimeInterval)duration
{
    if(_landscapeViewController == nil)
    {
        _landscapeViewController = [[LandscapeViewController alloc] initWithNibName:@"LandscapeViewController" bundle:nil];
        _landscapeViewController.search = _search;
        _landscapeViewController.view.frame = self.view.bounds;
        _landscapeViewController.view.alpha = 0.0f;
        
        [self.view addSubview:_landscapeViewController.view];
        [self addChildViewController:_landscapeViewController];
        
        [UIView animateWithDuration:duration animations:^{
            _landscapeViewController.view.alpha = 1.0f;
            _statusBarStyle = UIStatusBarStyleLightContent;
            [self setNeedsStatusBarAppearanceUpdate];
        } completion:^(BOOL finished){
            [_landscapeViewController didMoveToParentViewController:self];
        }];
        
        [self.searchBar resignFirstResponder];
        [_detailViewController dismissFromParentViewControllerWithAnimationType:DetailViewControllerAnimationTypeFade];

    }
}

-(void)hideLandscapeViewWithDuration:(NSTimeInterval)duration
{
    if(_landscapeViewController != nil)
    {
        [_landscapeViewController willMoveToParentViewController:nil];
        
        [UIView animateWithDuration:duration animations:^{
            _landscapeViewController.view.alpha = 0.0f;
            
            _statusBarStyle = UIStatusBarStyleDefault;
            [self setNeedsStatusBarAppearanceUpdate];
        } completion:^(BOOL finished){
            [_landscapeViewController.view removeFromSuperview];
            [_landscapeViewController removeFromParentViewController];
            _landscapeViewController = nil;
        }];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return _statusBarStyle;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_search.isLoading)
    {
        return 1;
    }
    else if(_search == nil)
    {
        return 0;
    }
    else if([_search.searchResults count] == 0)
    {
        return 1;
    }
    else
    {
        return [_search.searchResults count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if(_search.isLoading)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier forIndexPath:indexPath];
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[cell viewWithTag:100];
        [spinner startAnimating];
        return cell;
    }
    if([_search.searchResults count] == 0)
    {
        return [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier forIndexPath:indexPath];
    }
    else
    {
        SearchResultCell *cell = (SearchResultCell *)[tableView dequeueReusableCellWithIdentifier:SearchResultCellIdentifier forIndexPath:indexPath];
        SearchResult *searchResult = _search.searchResults[indexPath.row];
        [cell configureForSearchResult:searchResult];
        return cell;
    }
}



#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *controller = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    SearchResult *searchResult = _search.searchResults[indexPath.row];
    controller.searchResult = searchResult;
    
    [controller presentInParentViewController:self];
    _detailViewController = controller;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_search.searchResults count] == 0 || _search.isLoading)
    {
        return nil;
    }
    else
    {
        return indexPath;
    }
}

#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSearch];
}

-(void)performSearch
{
    _search = [[Search alloc] init];
    NSLog(@"allocated %@",_search);
    
    [_search performSelectorForText:self.searchBar.text category:self.segmentedControl.selectedSegmentIndex completion:^(BOOL success)
     {
         if(!success)
         {
             [self showNetworkError];
         }
         [_landscapeViewController searchResultsReceived];
         [self.tableView reloadData];
     }];
    
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}

-(void)showNetworkError
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Whoops...",@"Error alert:title") message:NSLocalizedString(@"There was an error reading from the iTunes Store.Please try again.",@"Localized kind:There was an error reading from the iTunes Store.Please try again.") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"Localized kind:OK") otherButtonTitles:nil];
    [alertView show];
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

-(IBAction)segmentChanged:(UISegmentedControl *)sender
{
    if(_search != nil)
    {
        [self performSearch];
    }
}

@end
