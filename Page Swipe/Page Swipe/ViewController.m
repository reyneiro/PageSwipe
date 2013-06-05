//
//  ViewController.m
//  Page Swipe
//
//Copyright (c) 2013 Reyneiro Hernandez
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

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
        self.pageBook = [[PSPageBook alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.pageBook.center = self.view.center;
        [self.pageBook setBackgroundColor:[UIColor whiteColor]];
        
        
        for (int i = 0; i < 3; i++) {
            PSPage *page = [[PSPage alloc] initWithFrame:CGRectMake(0, 0, self.pageBook.frame.size.width/1.2, self.pageBook.frame.size.height/1.2)];
            [page setBackgroundColor:[UIColor purpleColor]];
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
    
    PSPage *page = [[PSPage alloc] initWithFrame:CGRectMake(0, 0, self.pageBook.frame.size.width/1.2, self.pageBook.frame.size.height/1.2)];
    
    if (self.pageBook.pages.count % 2 == 0) {
        [page setBackgroundColor:[UIColor greenColor]];
    }
    else
    {
        [page setBackgroundColor:[UIColor blueColor]];
    }
    
    [self.pageBook addPage:page];
    
}
@end
