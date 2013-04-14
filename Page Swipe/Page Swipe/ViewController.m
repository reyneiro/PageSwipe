//
//  ViewController.m
//  Page Swipe
//
//  Created by Reyneiro Hernandez on 4/13/13.
//  Copyright (c) 2013 Reyneiro Hernandez. All rights reserved.
//

#import "ViewController.h"
#import "PSPage.h"

@interface ViewController ()

@property (strong, nonatomic) PSPage *page;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    self.page = [[PSPage alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.page = [[PSPage alloc] initWithFrame:CGRectMake(20, 120, 200, 200)];
    self.page.center = self.view.center;
    [self.view addSubview:self.page];
    [self.page setBackgroundColor:[UIColor redColor]];
    
//    self.page.prevPage = [[PSPage alloc] initWithFrame:CGRectMake(20, 120, 200, 200)];
    self.page.prevPage = [[PSPage alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.page.prevPage];
    [self.page.prevPage setBackgroundColor:[UIColor greenColor]];
    self.page.prevPage.nextPage = self.page;
    
//    self.page.nextPage = [[PSPage alloc] initWithFrame:CGRectMake(20, 120, 200, 200)];
    self.page.nextPage = [[PSPage alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.page.nextPage];
    [self.page.nextPage setBackgroundColor:[UIColor blueColor]];
    self.page.nextPage.prevPage = self.page;
    
//    self.page.nextPage.nextPage = [[PSPage alloc] initWithFrame:CGRectMake(20, 120, 80, 80)];
    self.page.nextPage.nextPage = [[PSPage alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.page.nextPage.nextPage];
    [self.page.nextPage.nextPage setBackgroundColor:[UIColor yellowColor]];
    self.page.nextPage.nextPage.prevPage = self.page.nextPage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
