//
//  ViewController.m
//  iOSFlutterHybrid
//
//  Created by ppd-03020339 on 2019/11/12.
//  Copyright © 2019 hybrid. All rights reserved.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(handleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"加载Flutetr" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    button.frame = CGRectMake(100, 100, 160, 60);
    [self.view addSubview:button];
}

- (void)handleButtonAction{
   
    FlutterEngine *flutterEngine = [(AppDelegate *)[[UIApplication sharedApplication] delegate] flutterEngine];
    FlutterViewController *flutterViewController = [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    [flutterViewController setInitialRoute:@"route2"];
    [self presentViewController:flutterViewController animated:false completion:nil];
     
}

@end
