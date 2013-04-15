//
//  PSPage.h
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

#import <UIKit/UIKit.h>
#import "DirectionPanGestureRecognizer.h"


typedef enum {
    PSRecursiveDirectionNone = 0,
    PSRecursiveDirectionNext = 1,
    PSRecursiveDirectionPrev = 2
}PSRecursiveDirection;

@class PSPage;
@protocol PSPageDelegate <NSObject>

@property (weak, nonatomic) PSPage *currentPage; //current page been showed (main page at a given moment)

-(void)pageWasRemoved:(PSPage *)page;

@end

@interface PSPage : UIView <UIGestureRecognizerDelegate>

@property (assign, nonatomic) id <PSPageDelegate> delegate;
@property (strong, nonatomic) PSPage *nextPage;
@property (strong, nonatomic) PSPage *prevPage;

-(void)decreaseSize:(PSRecursiveDirection) recursiveDirection;
-(void)originalSize:(PSRecursiveDirection) recursiveDirection;
-(void)increaselSize:(PSRecursiveDirection) recursiveDirection;

-(void)setNextPageCenter:(CGPoint)translationPoint;
-(void)setPrevPageCenter:(CGPoint)translationPoint;

@end
