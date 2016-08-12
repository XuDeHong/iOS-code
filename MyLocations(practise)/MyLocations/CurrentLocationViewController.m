//
//  FirstViewController.m
//  MyLocations
//
//  Created by Matthijs on 08-10-13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import "CurrentLocationViewController.h"
#import "LocationDetailsViewController.h"
#import "NSMutableString+AddText.h"

@interface CurrentLocationViewController () <UITabBarControllerDelegate>

@end

@implementation CurrentLocationViewController
{
  CLLocationManager *_locationManager;
  CLLocation *_location;
  
  BOOL _updatingLocation;
  NSError *_lastLocationError;
  
  CLGeocoder *_geocoder;
  CLPlacemark *_placemark;
  BOOL _performingReverseGeocoding;
  NSError *_lastGeocodingError;

  UIButton *_logoButton;
  BOOL _logoVisible;
  UIActivityIndicatorView *_spinner;
  SystemSoundID _soundID;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super initWithCoder:aDecoder])) {
    _locationManager = [[CLLocationManager alloc] init];
    _geocoder = [[CLGeocoder alloc] init];

    // For testing. Uncomment this line to use any location you want,
    // without having to use the Simulator's Location menu.
    _location = [[CLLocation alloc] initWithLatitude:37.785834 longitude:-122.406417];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tabBarController.delegate = self;
  self.tabBarController.tabBar.translucent = NO;
  [self loadSoundEffect];
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  [self updateLabels];
  [self configureGetButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getLocation:(id)sender
{
  if (_logoVisible) {
    [self hideLogoView];
  }

  if (_updatingLocation) {
    [self stopLocationManager];
  } else {
    _location = nil;
    _lastLocationError = nil;
    _placemark = nil;
    _lastGeocodingError = nil;

    [self startLocationManager];
  }

  [self updateLabels];
  [self configureGetButton];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"TagLocation"]) {
    UINavigationController *navigationController = segue.destinationViewController;
    LocationDetailsViewController *controller = (LocationDetailsViewController *)navigationController.topViewController;
    controller.coordinate = _location.coordinate;
    controller.placemark = _placemark;
    controller.managedObjectContext = self.managedObjectContext;
  }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  NSLog(@"didFailWithError %@", error);

  // The kCLErrorLocationUnknown error means the location manager was unable
  // to obtain a location right now. We will keep trying until we do find a
  // location or receive a more serious error.
  if (error.code == kCLErrorLocationUnknown) {
    return;
  }

  [self stopLocationManager];
  _lastLocationError = error;

  [self updateLabels];
  [self configureGetButton];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  CLLocation *newLocation = [locations lastObject];

  NSLog(@"didUpdateLocations %@", newLocation);

  // If the time at which the new location object was determined is too long
  // ago (5 seconds in this case), then this is a cached result. We'll ignore
  // these cached locations because they may be out of date.
  if ([newLocation.timestamp timeIntervalSinceNow] < -5.0) {
    return;
  }

  // Ignore invalid measurements.
  if (newLocation.horizontalAccuracy < 0) {
    return;
  }

  // Calculate the distance between the new reading and the old one. If this
  // is the first reading then there is no previous location to compare to
  // and we set the distance to a very large number (MAXFLOAT).
  CLLocationDistance distance = MAXFLOAT;
  if (_location != nil) {
    distance = [newLocation distanceFromLocation:_location];
  }

  // Only perform the following code if the new location provides a more
  // precise reading than the previous one, or if it's the very first.
  if (_location == nil || _location.horizontalAccuracy > newLocation.horizontalAccuracy) {

    // Put the new coordinates on the screen.
    _lastLocationError = nil;
    _location = newLocation;
    [self updateLabels];

    // We're done if the new location is accurate enough.
    if (newLocation.horizontalAccuracy <= _locationManager.desiredAccuracy) {
      NSLog(@"*** We're done!");
      [self stopLocationManager];
      [self configureGetButton];

      // We'll force a reverse geocoding for this final result if we
      // haven't already done this location.
      if (distance > 0) {
        _performingReverseGeocoding = NO;
      }
    }

    // We're not supposed to perform more than one reverse geocoding
    // request at once, so only continue if we're not already busy.
    if (!_performingReverseGeocoding) {
      NSLog(@"*** Going to geocode");

      // Start a new reverse geocoding request and update the screen
      // with the results (a new placemark or error message).
      _performingReverseGeocoding = YES;
      [_geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"*** Found placemarks: %@, error: %@", placemarks, error);

        _lastGeocodingError = error;
        if (error == nil && [placemarks count] > 0) {
          if (_placemark == nil) {
            NSLog(@"FIRST TIME!");
            [self playSoundEffect];
          }
          _placemark = [placemarks lastObject];
        } else {
          _placemark = nil;
        }

        _performingReverseGeocoding = NO;
        [self updateLabels];
      }];
    }

  // If the distance did not change significantly since last time and it has
  // been a while since we've received the previous reading (10 seconds) then
  // assume this is the best it's going to be and stop fetching the location.
  } else if (distance < 1.0) {
    NSTimeInterval timeInterval = [newLocation.timestamp timeIntervalSinceDate:_location.timestamp];
    if (timeInterval > 10) {
      NSLog(@"*** Force done!");
      [self stopLocationManager];
      [self updateLabels];
      [self configureGetButton];
    }
  }
}

- (NSString *)stringFromPlacemark:(CLPlacemark *)thePlacemark
{
  NSMutableString *line1 = [NSMutableString stringWithCapacity:100];
  [line1 addText:thePlacemark.subThoroughfare withSeparator:@""];
  [line1 addText:thePlacemark.thoroughfare withSeparator:@" "];

  NSMutableString *line2 = [NSMutableString stringWithCapacity:100];
  [line2 addText:thePlacemark.locality withSeparator:@""];
  [line2 addText:thePlacemark.administrativeArea withSeparator:@" "];
  [line2 addText:thePlacemark.postalCode withSeparator:@" "];

  if ([line1 length] == 0) {
    [line2 appendString:@"\n "];
    return line2;
  } else {
    [line1 appendString:@"\n"];
    [line1 appendString:line2];
    return line1;
  }
}

- (void)updateLabels
{
  // If we have a location object then we will always show its coordinates,
  // even if we're still fetching a more accurate location at the same time.
  if (_location != nil) {
    self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", _location.coordinate.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", _location.coordinate.longitude];
    self.tagButton.hidden = NO;
    self.messageLabel.text = @"";

    // Once we have a location, we try to reverse geocode it and show the
    // results in the address label.
    if (_placemark != nil) {
      self.addressLabel.text = [self stringFromPlacemark:_placemark];
    } else if (_performingReverseGeocoding) {
      self.addressLabel.text = @"Searching for Address...";
    } else if (_lastGeocodingError != nil) {
      self.addressLabel.text = @"Error Finding Address";
    } else {
      self.addressLabel.text = @"No Address Found";
    }

    self.latitudeTextLabel.hidden = NO;
    self.longitudeTextLabel.hidden = NO;

  // If we have no location yet, then we're either waiting for the user to
  // press the button to start, still get our first location fix, or we ran
  // into an error situation.
  } else {
    self.latitudeLabel.text = @"";
    self.longitudeLabel.text = @"";
    self.addressLabel.text = @"";
    self.tagButton.hidden = YES;

    NSString *statusMessage;
    if (_lastLocationError != nil) {
      if ([_lastLocationError.domain isEqualToString:kCLErrorDomain] && _lastLocationError.code == kCLErrorDenied) {
        statusMessage = @"Location Services Disabled";
      } else {
        statusMessage = @"Error Getting Location";
      }
    } else if (![CLLocationManager locationServicesEnabled]) {
      statusMessage = @"Location Services Disabled";
    } else if (_updatingLocation) {
      statusMessage = @"Searching...";
    } else {
      statusMessage = @"";
      [self showLogoView];
    }

    self.messageLabel.text = statusMessage;

    self.latitudeTextLabel.hidden = YES;
    self.longitudeTextLabel.hidden = YES;
  }
}

- (void)configureGetButton
{
  if (_updatingLocation) {
    [self.getButton setTitle:@"Stop" forState:UIControlStateNormal];

    if (_spinner == nil) {
      _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
      _spinner.center = CGPointMake(self.messageLabel.center.x, self.messageLabel.center.y + _spinner.bounds.size.height/2.0f + 15.0f);
      [_spinner startAnimating];
      [self.containerView addSubview:_spinner];
    }

  } else {
    [self.getButton setTitle:@"Get My Location" forState:UIControlStateNormal];

    [_spinner removeFromSuperview];
    _spinner = nil;
  }
}

- (void)startLocationManager
{
  if ([CLLocationManager locationServicesEnabled]) {

    // Tell the location manager to start fetching the location.
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_locationManager startUpdatingLocation];
    _updatingLocation = YES;

    // Schedule the method didTimeOut: to be called one 1 minute from now.
    // If we haven't obtained a location by then, it's unlikely we ever
    // will and we'll show an error message to the user.
    [self performSelector:@selector(didTimeOut:) withObject:nil afterDelay:60];
  }
}

- (void)stopLocationManager
{
  if (_updatingLocation) {

    // Make sure the didTimeOut: method won't be called anymore.
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didTimeOut:) object:nil];

    // Tell the location manager we no longer want to receive updates.
    [_locationManager stopUpdatingLocation];
    _locationManager.delegate = nil;
    _updatingLocation = NO;
  }
}

- (void)didTimeOut:(id)obj
{
  NSLog(@"*** Time out");

  // We get here whether we've obtained a location or not. If there no
  // location was obtained by this time, then we stop the location manager
  // from giving us updates and we'll show an error message to the user.
  if (_location == nil) {
    [self stopLocationManager];

	// Create an NSError object so that the UI shows an error message.
    _lastLocationError = [NSError errorWithDomain:@"MyLocationsErrorDomain" code:1 userInfo:nil];

    [self updateLabels];
    [self configureGetButton];
  }
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
  tabBarController.tabBar.translucent = (viewController != self);
  return YES;
}

#pragma mark - Logo View

- (void)showLogoView
{
  if (_logoVisible) {
    return;
  }

  _logoVisible = YES;
  self.containerView.hidden = YES;

  _logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_logoButton setBackgroundImage:[UIImage imageNamed:@"Logo"] forState:UIControlStateNormal];
  [_logoButton sizeToFit];
  [_logoButton addTarget:self action:@selector(getLocation:) forControlEvents:UIControlEventTouchUpInside];
  _logoButton.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.view.bounds.size.height / 2.0f);

  [self.view addSubview:_logoButton];
}

- (void)hideLogoView
{
  if (!_logoVisible) {
    return;
  }

  _logoVisible = NO;
  self.containerView.hidden = NO;

  self.containerView.center = CGPointMake(self.view.bounds.size.width * 2.0f, 40.0f + self.containerView.bounds.size.height / 2.0f);

  CABasicAnimation *panelMover = [CABasicAnimation animationWithKeyPath:@"position"];
  panelMover.removedOnCompletion = NO;
  panelMover.fillMode = kCAFillModeForwards;
  panelMover.duration = 0.6;
  panelMover.fromValue = [NSValue valueWithCGPoint:self.containerView.center];
  panelMover.toValue = [NSValue valueWithCGPoint:CGPointMake(160.0f, self.containerView.center.y)];
  panelMover.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  panelMover.delegate = self;
  [self.containerView.layer addAnimation:panelMover forKey:@"panelMover"];

  CABasicAnimation *logoMover = [CABasicAnimation animationWithKeyPath:@"position"];
  logoMover.removedOnCompletion = NO;
  logoMover.fillMode = kCAFillModeForwards;
  logoMover.duration = 0.5;
  logoMover.fromValue = [NSValue valueWithCGPoint:_logoButton.center];
  logoMover.toValue = [NSValue valueWithCGPoint:CGPointMake(-160.0f, _logoButton.center.y)];
  logoMover.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
  [_logoButton.layer addAnimation:logoMover forKey:@"logoMover"];

  CABasicAnimation *logoRotator = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  logoRotator.removedOnCompletion = NO;
  logoRotator.fillMode = kCAFillModeForwards;
  logoRotator.duration = 0.5;
  logoRotator.fromValue = @0.0f;
  logoRotator.toValue = @(-2.0f * M_PI);
  logoRotator.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
  [_logoButton.layer addAnimation:logoRotator forKey:@"logoRotator"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  [self.containerView.layer removeAllAnimations];
  self.containerView.center = CGPointMake(self.view.bounds.size.width / 2.0f, 40.0f + self.containerView.bounds.size.height / 2.0f);

  [_logoButton.layer removeAllAnimations];
  [_logoButton removeFromSuperview];
  _logoButton = nil;
}

#pragma mark - Sound Effect

- (void)loadSoundEffect
{
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Sound.caf" ofType:nil];

  NSURL *fileURL = [NSURL fileURLWithPath:path isDirectory:NO];
  if (fileURL == nil) {
    NSLog(@"NSURL is nil for path: %@", path);
    return;
  }

  OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &_soundID);
  if (error != kAudioServicesNoError) {
    NSLog(@"Error code %ld loading sound at path: %@", error, path);
    return;
  }
}

- (void)unloadSoundEffect
{
  AudioServicesDisposeSystemSoundID(_soundID);
  _soundID = 0;
}

- (void)playSoundEffect
{
  AudioServicesPlaySystemSound(_soundID);
}

@end
