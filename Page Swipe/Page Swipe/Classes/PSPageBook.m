//
//  PSPageBook.m
//  Page Swipe
//
//  Created by Reyneiro Hernandez on 4/13/13.
//  Copyright (c) 2013 Reyneiro Hernandez. All rights reserved.
//

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
        
        CGPoint center = self.center;
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
