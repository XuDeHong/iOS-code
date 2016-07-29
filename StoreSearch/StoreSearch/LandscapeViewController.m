//
//  LanscapeViewController.m
//  StoreSearch
//
//  Created by 许德鸿 on 16/7/24.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import "LandscapeViewController.h"
#import "SearchResult.h"
#import <AFNetworking/UIButton+AFNetworking.h>
#import "Search.h"
#import "DetailViewController.h"

@interface LandscapeViewController () <UIScrollViewDelegate>

@property (nonatomic,weak)IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak)IBOutlet UIPageControl *pageControl;

@end

@implementation LandscapeViewController
{
    BOOL _firstTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LandscapeBackground"]];
    self.pageControl.numberOfPages = 0;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if(_firstTime)
    {
        _firstTime = NO;
        if(self.search != nil)
        {
            if(self.search.isLoading)
            {
                [self showSpinner];
            }
            else if([self.search.searchResults count] == 0)
            {
                [self showNothingFoundLabel];
            }
            else
            {
                [self tileButtons];
            }
        }

    }
}

-(void)showNothingFoundLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = NSLocalizedString(@"Nothing Found",@"Localized kind:Nothing Found");
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    
    [label sizeToFit];
    CGRect rect = label.frame;
    rect.size.width = ceilf(rect.size.width/2.0f) * 2.0f;
    rect.size.height = ceilf(rect.size.height/2.0f) * 2.0f;
    label.frame = rect;
    label.center = CGPointMake(CGRectGetMidX(self.scrollView.bounds), CGRectGetMidY(self.scrollView.bounds));
    [self.view addSubview:label];
    
}

-(void)searchResultsReceived
{
    [self hideSpinner];
    if([self.search.searchResults count] == 0)
    {
        [self showNothingFoundLabel];
    }
    else
    {
        [self tileButtons];
    }

}

-(void)hideSpinner
{
    [[self.view viewWithTag:1000] removeFromSuperview];
}

-(void)showSpinner
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(CGRectGetMidX(self.scrollView.bounds) + 0.5f, CGRectGetMidY(self.scrollView.bounds) + 0.5f);
    spinner.tag = 1000;
    [self.view addSubview:spinner];
    [spinner startAnimating];
}

-(void)tileButtons
{
    int columnsPerPage = 5;
    CGFloat itemWidth = 96.0f;
    CGFloat itemHeight = 88.0f;
    CGFloat x = 0.0f;
    CGFloat extraSpace = 0.0f;
    
    CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    if (scrollViewWidth > 568.0f)
    {
        columnsPerPage = 7;
        itemHeight = 100.0f;
        itemWidth = 94.0f;
        x = 4.5f;
        extraSpace = 9.0f;
    }
    else if(scrollViewWidth > 480.0f)
    {
        columnsPerPage = 6;
        itemWidth = 94.0f;
        x = 2.0f;
        extraSpace = 4.0f;
    }
    
    const CGFloat buttonWidth = 82.0f;
    const CGFloat buttonHeight = 82.0f;
    const CGFloat marginHorz = (itemWidth - buttonWidth) / 2.0f;
    const CGFloat marginVert = (itemHeight - buttonHeight) / 2.0f;
    
    int index = 0;
    int row = 0;
    int column = 0;
    
    for(SearchResult *searchResult in self.search.searchResults)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"LandscapeButton"] forState:UIControlStateNormal];
        button.frame = CGRectMake(x + marginHorz, 20.0f + row*itemHeight + marginVert, buttonWidth, buttonHeight);
        button.tag = 2000 + index;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self downloadImageForSearchResult:searchResult andPlaceOnButton:button];
        [self.scrollView addSubview:button];
        
        index++;
        row++;
        
        if(row == 3)
        {
            row = 0;
            column++;
            x += itemWidth;
            
            if(column == columnsPerPage)
            {
                column = 0;
                x += extraSpace;
            }
        }
    }
    
    int tilesPerPage = columnsPerPage * 3;
    int numPages = ceilf([self.search.searchResults count] / (float)tilesPerPage);
    self.scrollView.contentSize = CGSizeMake(numPages*scrollViewWidth, self.scrollView.bounds.size.height);
    NSLog(@"Number of pages: %d",numPages);
    self.pageControl.numberOfPages = numPages;
    self.pageControl.currentPage = 0;
}

-(void)buttonPressed:(UIButton *)sender
{
    DetailViewController *controller = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    SearchResult *searchResult = self.search.searchResults[sender.tag - 2000];
    controller.searchResult = searchResult;
    [controller presentInParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"dealloc %@",self);
    
//    for(UIButton *button in self.scrollView.subviews)
//    {
//        [button cancelBackgroundImageRequestOperationForState:UIControlStateNormal];
//    }
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        _firstTime = YES;
    }
    return self;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.scrollView.bounds.size.width;
    int currentPage = (self.scrollView.contentOffset.x + width/2.0f) /width;
    self.pageControl.currentPage = currentPage;
}

-(IBAction)pageChanged:(UIPageControl *)sender
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width * sender.currentPage, 0);
    } completion:nil];
}

-(void)downloadImageForSearchResult:(SearchResult *)searchResult andPlaceOnButton:(UIButton *)button
{
    NSURL *url = [NSURL URLWithString:searchResult.artworkURL60];
    
    //1
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    //2
    __weak UIButton *weakButton = button;
    
    //3
    [button setImageForState:UIControlStateNormal withURLRequest:request placeholderImage:nil success:^(NSURLRequest *request,NSHTTPURLResponse *response,UIImage *image){
        
        //4
        UIImage *unscaledImage = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:image.imageOrientation];
        [weakButton setImage:unscaledImage forState:UIControlStateNormal];
    } failure:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
