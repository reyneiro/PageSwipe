//
//  ViewController.m
//  Page Swipe
//
//  Created by Reyneiro Hernandez on 4/13/13.
//  Copyright (c) 2013 Reyneiro Hernandez. All rights reserved.
//

#import "ViewController.h"
#import "PSPageBook.h"

@interface ViewController ()

@property (strong, nonatomic) PSPageBook *pageBook;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    if(!self.pageBook)
    {
        self.pageBook = [[PSPageBook alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.pageBook.center = self.view.center;
        [self.pageBook setBackgroundColor:[UIColor whiteColor]];
        
        
        for (int i = 0; i < 10; i++) {
            PSPage *page = [[PSPage alloc] initWithFrame:CGRectMake(0, 0, self.pageBook.frame.size.width/2, self.pageBook.frame.size.height/2)];
            [page setBackgroundColor:[UIColor redColor]];
            [self.pageBook addPage:page];
        }
        
        [self.view addSubview:self.pageBook];
        [self.view sendSubviewToBack:self.pageBook];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewPage:(id)sender {
    
    PSPage *page = [[PSPage alloc] initWithFrame:CGRectMake(0, 0, self.pageBook.frame.size.width/2, self.pageBook.frame.size.height/2)];
    [page setBackgroundColor:[UIColor redColor]];
    [self.pageBook addPage:page];
    
}
@end
