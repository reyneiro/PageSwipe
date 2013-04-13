//
//  PSPage.m
//  Page Swipe
//
//  Created by Reyneiro Hernandez on 4/13/13.
//  Copyright (c) 2013 Reyneiro Hernandez. All rights reserved.
//

#import "PSPage.h"

#define kAnimationsSpeed .3

@interface PSPage ()

@property (strong, nonatomic) UIPanGestureRecognizer *draggingGesture;
@property (nonatomic) CGSize *size;
@property (nonatomic) CGPoint originalCenter;

@end

@implementation PSPage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self viewSetUp];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self viewSetUp];
    }
    return self;
}


-(void)setNextPageCenter:(CGPoint)translationPoint
{
    self.nextPage.center = CGPointMake(self.nextPage.center.x + translationPoint.x, self.nextPage.center.y);
    [self.nextPage setNextPageCenter:translationPoint];
}

-(void)setPrevPageCenter:(CGPoint)translationPoint
{
    self.prevPage.center = CGPointMake(self.prevPage.center.x + translationPoint.x, self.prevPage.center.y);
    [self.prevPage setPrevPageCenter:translationPoint];
}

-(void)setNextPage:(PSPage *)nextPage
{
    _nextPage = nextPage;
    
    if ([self isEqual:nextPage.prevPage]) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.x = self.frame.origin.x + self.frame.size.width + 5.0f;
    nextPage.frame = frame;
}

-(void)setPrevPage:(PSPage *)prevPage
{
    _prevPage = prevPage;
    
    if ([self isEqual:prevPage.nextPage]) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.x = self.frame.origin.x - self.frame.size.width - 5.0f;
    prevPage.frame = frame;
    
    
}

-(void)viewSetUp
{
    self.draggingGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragView:)];
    [self addGestureRecognizer:self.draggingGesture];
}


-(void)dragView:(UIPanGestureRecognizer *) draggingGesture
{

    if (draggingGesture.state == UIGestureRecognizerStateBegan) {
        // set original center so we know where to put it back if we have to.
        self.originalCenter = self.center;
        
        [self decreaseSize:PSRecursiveDirectionNext];
        [self.prevPage decreaseSize:PSRecursiveDirectionPrev];
    }
    
    CGPoint translatedPoint = [draggingGesture translationInView:self.superview];
    
    if (draggingGesture.state == UIGestureRecognizerStateChanged) {
        [self setCenter:CGPointMake(self.center.x + translatedPoint.x, self.center.y)];
        [self setPrevPageCenter:translatedPoint];
        [self setNextPageCenter:translatedPoint];
        [draggingGesture setTranslation:CGPointZero inView:[self superview]];
    }

    
    if (draggingGesture.state == UIGestureRecognizerStateEnded)
    {
        
        [self centerView:^(BOOL finished) {
            [self originalSize:PSRecursiveDirectionNext];
            [self.prevPage originalSize:PSRecursiveDirectionPrev];
        }];
        
       
        
    }

    
}

-(void)decreaseSize:(PSRecursiveDirection) recursiveDirection
{
    [UIView animateWithDuration: kAnimationsSpeed
                          delay: 0
                        options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{self.transform = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);}
                     completion:^(BOOL finished) { }
     ];
    
    switch (recursiveDirection) {
        case PSRecursiveDirectionNext:
            [self.nextPage decreaseSize:recursiveDirection];
            break;
        case PSRecursiveDirectionPrev:
            [self.prevPage decreaseSize:recursiveDirection];
            break;
            
        default:
            return;
            break;
    }
}


-(void)originalSize:(PSRecursiveDirection) recursiveDirection
{
    [UIView animateWithDuration: kAnimationsSpeed
                          delay: 0
                        options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);}
                     completion:^(BOOL finished) { }
     ];
    
    switch (recursiveDirection) {
        case PSRecursiveDirectionNext:
            [self.nextPage originalSize:recursiveDirection];
            break;
        case PSRecursiveDirectionPrev:
            [self.prevPage originalSize:recursiveDirection];
            break;
            
        default:
            return;
            break;
    }
}


-(void)increaselSize:(PSRecursiveDirection) recursiveDirection
{
    [UIView animateWithDuration: kAnimationsSpeed
                          delay: 0
                        options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);}
                     completion:^(BOOL finished) { }
     ];
    
    switch (recursiveDirection) {
        case PSRecursiveDirectionNext:
            [self.nextPage increaselSize:recursiveDirection];
            break;
        case PSRecursiveDirectionPrev:
            [self.prevPage increaselSize:recursiveDirection];
            break;
            
        default:
            return;
            break;
    }
}

-(void)centerView:(void (^)(BOOL finished)) completion
{
    CGFloat distance = [self distanceFrom:self.center to:self.superview.center];
    CGFloat distanceNext = [self distanceFrom:self.nextPage.center to:self.superview.center];
    CGFloat distancePrev = [self distanceFrom:self.prevPage.center to:self.superview.center];
    
    [UIView animateWithDuration:kAnimationsSpeed animations:^{
        if (distance <= distanceNext)
        {
            if (distance <= distancePrev)
            {
                [self alignCentersFromPage:self];
            }
            else
            {
                [self.prevPage alignCentersFromPage:self.prevPage];
            }
        }
        else if(distanceNext <= distancePrev)
        {
            [self.nextPage alignCentersFromPage:self.nextPage];
        }
        else
        {
            [self.prevPage alignCentersFromPage:self.prevPage];
        }
    } completion:^(BOOL finished) {
        completion(YES);
    } ];
    
}

-(void)alignCentersFromPage:(PSPage *)page
{
    CGPoint originalCenter = page.center;
    
    CGPoint tranlationPoint = [page translationPointFrom:originalCenter];
    [page setCenter:page.superview.center];
    [page setNextPageCenter:tranlationPoint];
    [page setPrevPageCenter:tranlationPoint];
}

-(CGPoint)translationPointFrom:(CGPoint )originalCenter
{    
    CGFloat xDist = (self.superview.center.x - originalCenter.x);
    CGFloat yDist = (self.superview.center.y - originalCenter.y);
    CGPoint tranlationPoint = CGPointMake(xDist, yDist);
    
    return tranlationPoint;
}

-(CGFloat)distanceFrom:(CGPoint)point1 to:(CGPoint)point2
{
    CGFloat xDist = (point2.x - point1.x);
    CGFloat yDist = (point2.y - point1.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}


@end
