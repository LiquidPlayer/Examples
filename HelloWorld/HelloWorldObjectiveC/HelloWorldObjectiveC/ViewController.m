//
//  ViewController.m
//  HelloWorldObjectiveC
//
//  Created by Eric Lange on 8/19/18.
//  Copyright © 2018 LiquidPlayer. All rights reserved.
//

#import "ViewController.h"
#import <LiquidCore/LiquidCore.h>

@interface ViewController ()  <LCMicroServiceDelegate, LCMicroServiceEventListener>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.text = [[UILabel alloc] init];
    self.text.textAlignment = NSTextAlignmentCenter;
    self.text.text = @"Hello World!";
    self.text.font = [UIFont fontWithName:@"Menlo" size:17.];
    [self.view addSubview:self.text];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button setTitle:@"Sprechen Sie Deutsch!" forState:UIControlStateNormal];
    [self.button.titleLabel setFont:[UIFont fontWithName:@"Menlo" size:17.]];
    [self.button addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];

    self.text.translatesAutoresizingMaskIntoConstraints = NO;
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILayoutGuide *topGuide = [[UILayoutGuide alloc] init];
    [self.view addLayoutGuide:topGuide];
    
    UILayoutGuide *bottomGuide = [[UILayoutGuide alloc] init];
    [self.view addLayoutGuide:bottomGuide];
    
    id views = @{
                 @"text": self.text,
                 @"button": self.button,
                 @"topGuide": topGuide,
                 @"bottomGuide": bottomGuide,
                 };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[text]-|"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button]-|"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[topGuide]-[text]-[button]-[bottomGuide(==topGuide)]|"
                               options:0 metrics:nil views:views]];
}

- (void) onTouch:(UIButton*)sender
{
    NSURL *url = [LCMicroService devServer];
    LCMicroService *service = [[LCMicroService alloc] initWithURL:url delegate:self];
    [service start];
}

- (void) onStart:(LCMicroService *)service
{
    [service addEventListener:@"ready" listener:self];
    [service addEventListener:@"pong" listener:self];
}

- (void) onEvent:(LCMicroService *)service event:(NSString *)event payload:(id)payload
{
    if ([event isEqualToString:@"ready"]) {
        [service emit:@"ping"];
    } else if ([event isEqualToString:@"pong"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.text setText:payload[@"message"]];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
