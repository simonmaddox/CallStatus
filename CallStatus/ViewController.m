//
//  ViewController.m
//  CallStatus
//
//  Created by Simon Maddox on 04/10/2012.
//  Copyright (c) 2012 Simon Maddox. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)call:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:202"]];
	
	[(AppDelegate *)[[UIApplication sharedApplication] delegate] setIsInCall:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
