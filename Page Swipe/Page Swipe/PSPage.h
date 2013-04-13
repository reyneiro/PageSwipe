//
//  PSPage.h
//  Page Swipe
//
//  Created by Reyneiro Hernandez on 4/13/13.
//  Copyright (c) 2013 Reyneiro Hernandez. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    PSRecursiveDirectionNone = 0,
    PSRecursiveDirectionNext = 1,
    PSRecursiveDirectionPrev = 2
}PSRecursiveDirection;


@interface PSPage : UIView

@property (strong, nonatomic) PSPage *nextPage;
@property (strong, nonatomic) PSPage *prevPage;

-(void)decreaseSize:(PSRecursiveDirection) recursiveDirection;
-(void)originalSize:(PSRecursiveDirection) recursiveDirection;
-(void)increaselSize:(PSRecursiveDirection) recursiveDirection;

-(void)setNextPageCenter:(CGPoint)translationPoint;
-(void)setPrevPageCenter:(CGPoint)translationPoint;

@end
