//
//  PSPageBook.m
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

#import "PSPageBook.h"

@interface PSPageBook ()
{
    PSPage *_currentPage; //current page been showed (main page at a given moment)
}

@property (strong, nonatomic) NSMutableArray *pagesArray;

@end


@implementation PSPageBook

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpBook];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setUpBook];
    }
    return self;
}

-(NSArray *)pages
{
    return [self.pagesArray copy];
}

-(void)setUpBook
{
    self.pagesArray = [[NSMutableArray alloc] init];
}

-(void)addPage:(PSPage *)page
{
    if (page)
    {
        page.delegate = self;
        
        page.alpha = 0;
        [self addSubview:page];
        
        CGPoint center =  self.pagesArray.count > 0 ? ((PSPage *)self.pagesArray.lastObject).center : self.center;
        center.y -= page.frame.size.height/2;
        page.center = center;
        
        
        center.y += page.frame.size.height/2;
        [UIView animateWithDuration:.3 animations:^{
            page.center =  center;
            page.alpha = 1;
            
            ((PSPage *)self.pagesArray.lastObject).nextPage = page;
            [self.pagesArray addObject:page];
        }];
    }
}

#pragma mark PSPageDelegate

-(void)setAllowRemovePages:(BOOL)allowRemovePages
{
    _allowRemovePages = allowRemovePages;
    for (PSPage *page in self.pagesArray) {
        page.canBeRemoved = allowRemovePages;
    }
}

-(void)pageWasRemoved:(PSPage *)page
{
    [self.pagesArray removeObject:page];
}

-(void)setCurrentPage:(PSPage *)currentPage
{
    _currentPage = currentPage;
}

-(PSPage *)currentPage
{
    return _currentPage;
}

@end
