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
    NSMutableArray *_searchResults;
    BOOL _isLoading;
    NSOperationQueue *_queue;
    LandscapeViewController *_landscapeViewController;
    UIStatusBarStyle _statusBarStyle;
    __weak DetailViewController *_detailViewController;
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

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
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
        _landscapeViewController.searchResults = _searchResults;
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
    if(_isLoading)
    {
        return 1;
    }
    else if(_searchResults == nil)
    {
        return 0;
    }
    else if([_searchResults count] == 0)
    {
        return 1;
    }
    else
    {
        return [_searchResults count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if(_isLoading)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier forIndexPath:indexPath];
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[cell viewWithTag:100];
        [spinner startAnimating];
        return cell;
    }
    if([_searchResults count] == 0)
    {
        return [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier forIndexPath:indexPath];
    }
    else
    {
        SearchResultCell *cell = (SearchResultCell *)[tableView dequeueReusableCellWithIdentifier:SearchResultCellIdentifier forIndexPath:indexPath];
        SearchResult *searchResult = _searchResults[indexPath.row];
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
    SearchResult *searchResult = _searchResults[indexPath.row];
    controller.searchResult = searchResult;
    
    [controller presentInParentViewController:self];
    _detailViewController = controller;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_searchResults count] == 0 || _isLoading)
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
    if([self.searchBar.text length] > 0)
    {
        [self.searchBar resignFirstResponder];
        [_queue cancelAllOperations];
        
        _isLoading = YES;
        [self.tableView reloadData];
        _searchResults = [NSMutableArray arrayWithCapacity:10];
        NSURL *url = [self urlWithSearchText:self.searchBar.text category:self.segmentedControl.selectedSegmentIndex];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
            [self parseDictionary:responseObject];
            [_searchResults sortUsingSelector:@selector(compareName:)];
            _isLoading = NO;
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            if(operation.isCancelled)
            {
                return;
            }
            [self showNetworkError];
            _isLoading = NO;
            [self.tableView reloadData];
        }];
        [_queue addOperation:operation];
    }
}

-(void)parseDictionary:(NSDictionary *)dictionary
{
    NSArray *array = dictionary[@"results"];
    if(array == nil)
    {
        NSLog(@"Expected 'results' array");
        return;
    }
    
    for(NSDictionary *resultDict in array)
    {
        SearchResult *searchResult;
        
        NSString *wrapperType = resultDict[@"wrapperType"];
        NSString *kind = resultDict[@"kind"];
        
        if([wrapperType isEqualToString:@"track"])
        {
            searchResult = [self parseTrack:resultDict];
        }
        else if([wrapperType isEqualToString:@"audiobook"])
        {
            searchResult = [self parseAudioBook:resultDict];
        }
        else if([wrapperType isEqualToString:@"software"])
        {
            searchResult = [self parseSoftware:resultDict];
        }
        else if([kind isEqualToString:@"ebook"])
        {
            searchResult = [self parseEBook:resultDict];
        }
        
        if(searchResult != nil)
        {
            [_searchResults addObject:searchResult];
        }
    }
}

-(SearchResult *)parseTrack:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkURL60"];
    searchResult.artworkURL100 = dictionary[@"artworkURL100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"price"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    return searchResult;
}

- (SearchResult *)parseAudioBook:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dictionary[@"collectionName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"collectionViewUrl"];
    searchResult.kind = @"audiobook";
    searchResult.price = dictionary[@"collectionPrice"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    return searchResult;
}

- (SearchResult *)parseSoftware:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"price"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    return searchResult;
}

- (SearchResult *)parseEBook:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"price"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = [(NSArray *)dictionary[@"genres"] componentsJoinedByString:@", "];
    return searchResult;
}


-(NSURL *)urlWithSearchText:(NSString *)searchText category:(NSInteger)category
{
    NSString *categoryName;
    switch (category) {
        case 0: categoryName = @""; break;
        case 1: categoryName = @"musicTrack"; break;
        case 2: categoryName = @"software"; break;
        case 3: categoryName = @"ebook"; break;
    }
    
    NSString *escapedSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&limit=100&entity=%@",escapedSearchText,categoryName];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

-(void)showNetworkError
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops..." message:@"There was an error reading from the iTunes Store.Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

-(IBAction)segmentChanged:(UISegmentedControl *)sender
{
    if(_searchResults != nil)
    {
        [self performSearch];
    }
}

@end
