//
//  DetailViewController.m
//  StoreSearch
//
//  Created by 许德鸿 on 16/7/23.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchResult.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "GradientView.h"
#import "MenuViewController.h"
#import <MessageUI/MessageUI.h>

@interface DetailViewController () <UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic,weak) IBOutlet UIView *popupView;
@property (nonatomic,weak) IBOutlet UIImageView *artworkImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *artistNameLabel;
@property (nonatomic,weak) IBOutlet UILabel *kindLabel;
@property (nonatomic,weak) IBOutlet UILabel *genreLabel;
@property (nonatomic,weak) IBOutlet UIButton *priceButton;
@property (nonatomic,strong) UIPopoverController *masterPopverController;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic,strong) UIPopoverController *menuPopoverController;

@end

@implementation DetailViewController
{
    GradientView *_gradientView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [[UIImage imageNamed:@"PriceButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.priceButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.view.tintColor = [UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:1.0f];
    
    self.popupView.layer.cornerRadius = 10.0f;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LandscapeBackground"]];
        self.popupView.hidden = (self.searchResult == nil);
        self.title = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(menuButtonPressed:)];
    }
    else
    {
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
        gestureRecognizer.cancelsTouchesInView = NO;
        gestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:gestureRecognizer];
        self.view.backgroundColor = [UIColor clearColor];
    }
    if(self.searchResult != nil)
    {
        [self updateUI];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)sendSupportEmail
{
    [self.menuPopoverController dismissPopoverAnimated:YES];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    
    if(controller != nil)
    {
        [controller setSubject:NSLocalizedString(@"Support Request", @"Email subject")];
        [controller setToRecipients:@[@"740665370@qq.com"]];
        controller.mailComposeDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

-(void)menuButtonPressed:(UIBarButtonItem *)sender
{
    if([self.menuPopoverController isPopoverVisible])
    {
        [self.menuPopoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [self.menuPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(UIPopoverController *)menuPopoverController
{
    if(_menuPopoverController == nil)
    {
        MenuViewController *menuViewController = [[MenuViewController alloc] initWithStyle:UITableViewStyleGrouped];
        menuViewController.detailViewController = self;
        _menuPopoverController = [[UIPopoverController alloc] initWithContentViewController:menuViewController];
    }
    return _menuPopoverController;
}

-(void)setSearchResult:(SearchResult *)newSearchResult
{
    if(_searchResult != newSearchResult)
    {
        _searchResult = newSearchResult;
        
        if([self isViewLoaded])
        {
            [self updateUI];
        }
    }
}

-(void)updateUI
{
    self.nameLabel.text = self.searchResult.name;
    NSString *artistName = self.searchResult.artistName;
    if(artistName == nil)
    {
        artistName = NSLocalizedString(@"Unknown",@"Localized kind:Unknown");
    }
    
    self.artistNameLabel.text = artistName;
    self.kindLabel.text = [self.searchResult kindForDisplay];
    self.genreLabel.text = self.searchResult.genre;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencyCode:self.searchResult.currency];
    
    NSString *priceText;
    if([self.searchResult.price floatValue] == 0.0f)
    {
        priceText = NSLocalizedString(@"Free",@"Localized kind:Free");
    }
    else
    {
        priceText = [formatter stringFromNumber:self.searchResult.price];
    }
    [self.priceButton setTitle:priceText forState:UIControlStateNormal];
    
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:self.searchResult.artworkURL100]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        bounceAnimation.duration = 0.4;
        bounceAnimation.delegate = self;
        
        bounceAnimation.values = @[@0.7,@1.2,@0.9,@1.0];
        bounceAnimation.keyTimes = @[@0.0,@0.334,@0.666,@1.0];
        
        bounceAnimation.timingFunctions = @[
                                            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.popupView.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
        self.popupView.hidden = NO;
        [self.masterPopverController dismissPopoverAnimated:YES];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (touch.view == self.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender
{
    [self dismissFromParentViewControllerWithAnimationType:DetailViewControllerAnimationTypeSlide];
}

-(void)dismissFromParentViewControllerWithAnimationType:(DetailViewControllerAnimationType)animationType
{
    [self willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        if(animationType == DetailViewControllerAnimationTypeSlide)
        {
            CGRect rect = self.view.bounds;
            rect.origin.y += rect.size.height;
            self.view.frame = rect;
        }
        else
        {
            self.view.alpha = 0.0f;
        }
        _gradientView.alpha = 0.0f;
    } completion:^(BOOL finished){
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [_gradientView removeFromSuperview];
    }];
}

-(void)presentInParentViewController:(UIViewController *)parentViewController
{
    _gradientView = [[GradientView alloc] initWithFrame:parentViewController.view.bounds];
    [parentViewController.view addSubview:_gradientView];
    
    self.view.frame = parentViewController.view.bounds;
    [parentViewController.view addSubview:self.view];
    [parentViewController addChildViewController:self];

    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.duration = 0.4;
    bounceAnimation.delegate = self;
    
    bounceAnimation.values = @[@0.7,@1.2,@0.9,@1.0];
    bounceAnimation.keyTimes = @[@0.0,@0.334,@0.666,@1.0];
    
    bounceAnimation.timingFunctions = @[
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @0.0f;
    fadeAnimation.toValue = @1.0f;
    fadeAnimation.duration = 0.2;
    [_gradientView.layer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
   [self didMoveToParentViewController:self.parentViewController];
    NSLog(@"animationDidStop");
}

-(IBAction)openInStore:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.searchResult.storeURL]];
}

-(void)dealloc
{
    NSLog(@"dealloc %@",self);
    
    [self.artworkImageView cancelImageRequestOperation];
}

#pragma mark - UISplitViewControllerDelegate

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = NSLocalizedString(@"Search", @"Split-view master button");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopverController = pc;
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopverController = nil;
}

-(void)splitViewController:(UISplitViewController *)splitViewController popoverController:(nonnull UIPopoverController *)pc willPresentViewController:(nonnull UIViewController *)aViewController
{
    if([self.menuPopoverController isPopoverVisible])
    {
        [self.menuPopoverController dismissPopoverAnimated:YES];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
