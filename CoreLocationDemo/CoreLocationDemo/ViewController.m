//
//  ViewController.m
//  CoreLocationDemo
//
//  Created by 许德鸿 on 16/7/17.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;    //显示纬度
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;   //显示经度
@property (weak, nonatomic) IBOutlet UILabel *hAccuracyLabel;   //显示水平精准度
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;    //显示海拔高度
@property (weak, nonatomic) IBOutlet UILabel *vAccuracyLabel;   //显示垂直精准度

@end

@implementation ViewController
{
    CLLocationManager *_locationManager;
    CLLocation *_location;
    SystemSoundID _soundID;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; //设置精准度
    _locationManager.delegate = self;   //设置代理
    _location = [[CLLocation alloc] init];
    [_locationManager requestWhenInUseAuthorization];   //请求获取位置
    [self loadSoundEffect];     //加载声音文件
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getLocation:(id)sender {

    [_locationManager startUpdatingLocation];   //开始获取位置
    NSLog(@"Search...");
    [self playSoundEffect];     //播放声音
}
- (IBAction)stop:(id)sender {
    [_locationManager stopUpdatingLocation];    //停止获取位置
    NSLog(@"Stop!");
    [self playSoundEffect];     //播放声音
}

#pragma mark - CLLocationManager Delegate Method

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    _location = [locations lastObject];     //获取最新位置对象
    //根据位置对象更新标签
    if(_location != nil)
    {
        self.latitudeLabel.text = [NSString stringWithFormat:@"%g\u00B0",_location.coordinate.latitude];
        self.longitudeLabel.text = [NSString stringWithFormat:@"%g\u00B0",_location.coordinate.longitude];
        self.hAccuracyLabel.text = [NSString stringWithFormat:@"%f",_location.horizontalAccuracy];
        self.altitudeLabel.text = [NSString stringWithFormat:@"%f",_location.altitude];
        self.vAccuracyLabel.text = [NSString stringWithFormat:@"%f",_location.verticalAccuracy];
        NSLog(@"get a location!");
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(error != nil)
    {
        NSLog(@"There is a error : %@",error);
        [_locationManager stopUpdatingLocation];    //停止获取位置
    }
}

#pragma mark - SoundEffect

-(void)loadSoundEffect      //加载声音文件
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Sound.caf" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:path isDirectory:NO];
    if(fileURL == nil)
    {
        NSLog(@"NSURL is nil for path:%@",path);
        return;
    }
    
    //根据声音文件路径生成SystemSoundID
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &_soundID);
    if(error != kAudioServicesNoError)
    {
        NSLog(@"Error code %d loading sound at path:%@",(int)error,path);
        return;
    }
}

-(void)unloadSoundEffect    //取消声音文件的加载
{
    AudioServicesDisposeSystemSoundID(_soundID);
    _soundID=0;
}

-(void)playSoundEffect      //播放声音
{
    AudioServicesPlaySystemSound(_soundID);
}

@end
