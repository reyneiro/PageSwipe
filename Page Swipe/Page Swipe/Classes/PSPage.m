//
//  PSPage.m
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

#import "PSPage.h"
#import <QuartzCore/QuartzCore.h>
#define distanceBetweenPages 50.0f 

@interface PSPage ()
{
    CGFloat kAnimationsSpeed;
}

@property (strong, nonatomic) DirectionPanGestureRecognizer *horizontalDraggingGesture;
@property (strong, nonatomic) DirectionPanGestureRecognizer *verticalDraggingGesture;
@property (nonatomic) CGSize *size;
@property (nonatomic) CGPoint originalCenter;
@property (nonatomic) BOOL shouldIncrease;

@property (nonatomic) BOOL isMovingOnY;
@property (nonatomic) BOOL isMovingOnX;
@property (nonatomic) BOOL shouldRemovePage;

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

/*
    When this is set to NO the size of the pages won't increase after any user interaction but the pinch out 
*/
-(void)setShouldIncrease:(BOOL)shouldIncrease
{
    _shouldIncrease = shouldIncrease;
    
    if (self.nextPage.shouldIncrease != shouldIncrease) {
        [self.nextPage setShouldIncrease:shouldIncrease];
    }
    
    if (self.prevPage.shouldIncrease != shouldIncrease) {
        [self.prevPage setShouldIncrease:shouldIncrease];
    }
}

/*
    Change the center of the next pages recursivly using a translation point
*/
-(void)setNextPageCenter:(CGPoint)translationPoint
{
    self.nextPage.center = CGPointMake(self.nextPage.center.x + translationPoint.x, self.nextPage.center.y);
    [self.nextPage setNextPageCenter:translationPoint];
}

/*
 Change the center of the previous pages recursivly using a translation point
*/
-(void)setPrevPageCenter:(CGPoint)translationPoint
{
    self.prevPage.center = CGPointMake(self.prevPage.center.x + translationPoint.x, self.prevPage.center.y);
    [self.prevPage setPrevPageCenter:translationPoint];
}

/*
    Set the next page and if necessary set the position and size of this view 
    based ont the postion of it's previous page
*/
-(void)setNextPage:(PSPage *)nextPage
{
    _nextPage = nextPage;
    
    if ([self isEqual:nextPage.prevPage]) {
        return;
    }
    
    nextPage.prevPage = self;
    
    CGRect frame = self.frame;
    frame.origin.x = self.frame.origin.x + self.frame.size.width + distanceBetweenPages;
    nextPage.frame = frame;
}

/*
 Set the previous page and if necessary set the position and size of this view
 based ont the postion of it's next page
 */
-(void)setPrevPage:(PSPage *)prevPage
{
    _prevPage = prevPage;
    
    if ([self isEqual:prevPage.nextPage]) {
        return;
    }
    
    prevPage.nextPage = self;
    
    CGRect frame = self.frame;
    frame.origin.x = self.frame.origin.x - self.frame.size.width - distanceBetweenPages;
    prevPage.frame = frame;
    
    
}

/*
    Initilize the gestures recognizers of the page and set some properties initials values 
*/
-(void)viewSetUp
{
    self.horizontalDraggingGesture = [[DirectionPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragViewHorizontally:)];
    [self addGestureRecognizer:self.horizontalDraggingGesture];
    [self.horizontalDraggingGesture setDirection:DirectionPanGestureRecognizerHorizontal];
    self.horizontalDraggingGesture.delegate = self;
    
    self.verticalDraggingGesture = [[DirectionPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragViewVertically:)];
    [self addGestureRecognizer:self.verticalDraggingGesture];
    [self.verticalDraggingGesture setDirection:DirectionPangestureRecognizerVertical];
    self.verticalDraggingGesture.delegate = self;
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self addGestureRecognizer:pinchGesture];
    
    kAnimationsSpeed = .3;
    self.shouldIncrease = YES;
}

/*
    Avoid the detection of the vertical pan gesture when the horizontal gesture is beeing recognized and vice versa
*/
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isEqual:self.horizontalDraggingGesture] && [otherGestureRecognizer isEqual:self.verticalDraggingGesture])
    {
        return NO;
    }
    
    if ([gestureRecognizer isEqual:self.verticalDraggingGesture] && [otherGestureRecognizer isEqual:self.horizontalDraggingGesture])
    {
        return NO;
    }
    
    return YES;
}

/*
    This method get's trigered by the pinch gesture. It zooms out or in the pages depending on the scale of the gesture.
    When the pages zoom out the only way to zoom in again is using this method through the gesture (pinch in)
*/
-(void)pinchView:(UIPinchGestureRecognizer *)pinchGesture
{
    if (!self.canBeResized) {
        return;
    }
    
    if (pinchGesture.scale < 1)
    {
        kAnimationsSpeed = .2;
        [self decreaseSize:PSRecursiveDirectionNext];
        [self.prevPage decreaseSize:PSRecursiveDirectionPrev];
        self.shouldIncrease = NO;
        kAnimationsSpeed = .3;
    }
    else
    {
        kAnimationsSpeed = .2;
        [self originalSize:PSRecursiveDirectionNext];
        [self.prevPage originalSize:PSRecursiveDirectionPrev];
        self.shouldIncrease = YES;
        kAnimationsSpeed = .3;
    }
}

/*
 This method takes care the horizontal dragging
*/
-(void)dragViewHorizontally:(UIPanGestureRecognizer *) draggingGesture
{

    if (draggingGesture.state == UIGestureRecognizerStateBegan) {
        // set original center so we know where to put it back if we have to.
        self.originalCenter = self.center;
        
        [self decreaseSize:PSRecursiveDirectionNext];
        [self.prevPage decreaseSize:PSRecursiveDirectionPrev];
        self.isMovingOnX = YES;
    }
    
    CGPoint translatedPoint = [draggingGesture translationInView:self.superview];
    
    if (draggingGesture.state == UIGestureRecognizerStateChanged) {
        
        [self setCenter:CGPointMake(self.center.x + translatedPoint.x, self.center.y)];
        [self setPrevPageCenter:translatedPoint];
        [self setNextPageCenter:translatedPoint];
        [draggingGesture setTranslation:CGPointZero inView:[self superview]];
        
        //Use only if do not want to scroll 100% horizontal
        //Know the direction
        CGPoint velocity = [draggingGesture velocityInView:self];
        
        if(self.center.x < self.superview.center.x)
        {
            [self rotateInZPrev: velocity.x < 0 || self.center.x < self.superview.center.x ? self : self.prevPage];
            [self rotateInZNext: velocity.x < 0 || self.center.x < self.superview.center.x ? self.nextPage : self];
        }
        else
        {
            [self rotateInZPrev: velocity.x < 0 && self.center.x < self.superview.center.x ? self : self.prevPage];
            [self rotateInZNext: velocity.x < 0 && self.center.x < self.superview.center.x ? self.nextPage : self];
        }
        //End
    }
    
    
    if (draggingGesture.state == UIGestureRecognizerStateEnded || draggingGesture.state == UIGestureRecognizerStateCancelled)
    {
                
        kAnimationsSpeed = .3;
        
        if(!self.isHorizontalOnly)
        {
            [self originalSize:PSRecursiveDirectionNext];
            [self.prevPage originalSize:PSRecursiveDirectionPrev];
        }
        
        [self centerView:^(BOOL finished) {
            
            if (self.shouldIncrease) {
                [self originalSize:PSRecursiveDirectionNext];
                [self.prevPage originalSize:PSRecursiveDirectionPrev];
            }
           
            self.isMovingOnX = NO;
            
        }];
    
    }

    
}

/*
    This method takes care the vertical dragging
*/
-(void)dragViewVertically:(UIPanGestureRecognizer *) draggingGesture
{
    if (!self.canBeRemoved) {
        return;
    }
    
    if (draggingGesture.state == UIGestureRecognizerStateBegan) {
        // set original center so we know where to put it back if we have to.
        self.originalCenter = self.center;
        
        [self decreaseSize:PSRecursiveDirectionNext];
        [self.prevPage decreaseSize:PSRecursiveDirectionPrev];
        
        self.isMovingOnY = YES;
    }
    
    CGPoint translatedPoint = [draggingGesture translationInView:self.superview];
    
    if (draggingGesture.state == UIGestureRecognizerStateChanged) {
        
        [self setCenter:CGPointMake(self.center.x, self.center.y + translatedPoint.y)];
        CGFloat num = MAX(self.center.y - [self centerOnSuperView].y, [self centerOnSuperView].y - self.center.y);
        self.alpha = 60.0f/num;
//        [self setPrevPageCenter:translatedPoint];
//        [self setNextPageCenter:translatedPoint];
        int directionIndicator = 0;
        
        if (self.prevPage) {
//            [self setPrevPageCenter:CGPointMake(MAX(-1 * translatedPoint.y, translatedPoint.y), translatedPoint.y)];
            directionIndicator = [draggingGesture velocityInView:self].y < 0 ?  1 :  -1;
            [self setPrevPageCenter:CGPointMake(-1 *directionIndicator * translatedPoint.y, translatedPoint.y)];
        }
        else
        {
//            [self setNextPageCenter:CGPointMake(MIN(-1 * translatedPoint.y, translatedPoint.y), translatedPoint.y)];
            directionIndicator = [draggingGesture velocityInView:self].y >= 0 ?  -1 :  1;
            [self setNextPageCenter:CGPointMake(directionIndicator * translatedPoint.y, translatedPoint.y)];
        }
        
        [draggingGesture setTranslation:CGPointZero inView:[self superview]];
    }
    
    
    if (draggingGesture.state == UIGestureRecognizerStateEnded || draggingGesture.state == UIGestureRecognizerStateCancelled)
    {
        
        kAnimationsSpeed = .3;
        [self centerView:^(BOOL finished) {            
            
            
            if (self.shouldIncrease) {
                [self originalSize:PSRecursiveDirectionNext];
                [self.prevPage originalSize:PSRecursiveDirectionPrev];
            }
            
            if (self.shouldRemovePage) {
                PSPage *tempPage = self.prevPage ? self.prevPage : self.nextPage;
                [self removePage];
                [tempPage alignCentersFromPoint:[tempPage centerOnSuperView]];
                self.isMovingOnY = NO;
            }
            else
            {
                [self alignCentersFromPoint:[self centerOnSuperView]];
                self.isMovingOnY = NO;
            }
         
            
        }];
        
    }
    
    
}

/*
    Decrease the size of the view and if a recursive direction is passed does the same 
    for the pages on that direction
 */
-(void)decreaseSize:(PSRecursiveDirection) recursiveDirection
{
    if (!self.canBeResized) {
        return;
    }
    
    [UIView animateWithDuration: kAnimationsSpeed
                          delay: 0
                        options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                                self.transform = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
                                }
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

/*
 Set the size of the page to its original size and if a recursive direction is passed does the same
 for the pages on that direction
 */
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

/*
 Increase the size of the page and if a recursive direction is passed does the same
 for the pages on that direction
 */
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

/*
    When the dragging gestures end this method gets triggered to determine what should be 
    the position of the pages.
*/
-(void)centerView:(void (^)(BOOL finished)) completion
{
    CGFloat distance = [self distanceFrom:self.center to:[self centerOnSuperView]];
    CGFloat distanceNext = [self distanceFrom:self.nextPage.center to:[self centerOnSuperView]];
    CGFloat distancePrev = [self distanceFrom:self.prevPage.center to:[self centerOnSuperView]];
    
    [UIView animateWithDuration:kAnimationsSpeed animations:^{
        if (distance <= distanceNext)
        {
            if (distance <= distancePrev)
            {
                [self alignCentersFromPage:self];
                [self.delegate setCurrentPage:self];
                self.alpha = 1;
            }
            else
            {
                [self.prevPage alignCentersFromPage:self.prevPage];
                [self.delegate setCurrentPage:self.prevPage];
                [self setShouldRemovePage:YES];
            }
        }
        else if(distanceNext <= distancePrev)
        {
            [self.nextPage alignCentersFromPage:self.nextPage];
            [self.delegate setCurrentPage:self.nextPage];
            [self setShouldRemovePage:YES];
        }
        else
        {
            [self.prevPage alignCentersFromPage:self.prevPage];
            [self.delegate setCurrentPage:self.prevPage];
            [self setShouldRemovePage:YES];
        }
    } completion:^(BOOL finished) {
        
        if(completion)
        {
            completion(YES);
        }
        
    } ];
    
}

/*
    Remove a page
*/
-(void)removePage
{
    if (self.isMovingOnY) {
        
        if ([self.delegate respondsToSelector:@selector(pageWasRemoved:)]) {
            [self.delegate pageWasRemoved:self];
        }
        
        self.prevPage.nextPage = self.nextPage;
        self.nextPage.prevPage = self.prevPage;
        self.prevPage = nil;
        self.nextPage = nil;
        [UIView animateWithDuration:kAnimationsSpeed animations:^{
            self.alpha = 0;
            [self removeFromSuperview];
        }];
        
    }
}

-(void)alignCentersFromPage:(PSPage *)page
{
    CGPoint originalCenter = page.center;
    
    CGPoint tranlationPoint = [page translationPointFrom:originalCenter];
    [page setCenter:[page centerOnSuperView]];
    [page setNextPageCenter:tranlationPoint];
    [page setPrevPageCenter:tranlationPoint];
}

-(void)alignCentersFromPoint:(CGPoint)point
{
    [UIView animateWithDuration:kAnimationsSpeed animations:^{
        [self alignNextPageCentersFromPoint:point];
        [self alignPrevPageCentersFromPoint:point];
    }];
}

-(void)alignNextPageCentersFromPoint:(CGPoint)point
{
    self.nextPage.center = CGPointMake(self.center.x + self.frame.size.width + 5.0, self.center.y);
    [self.nextPage alignNextPageCentersFromPoint:self.nextPage.center];
}

-(void)alignPrevPageCentersFromPoint:(CGPoint)point
{
    self.prevPage.center = CGPointMake(self.center.x - self.frame.size.width - 5.0, self.center.y);
    [self.prevPage alignNextPageCentersFromPoint:self.prevPage.center];
}

-(CGPoint)translationPointFrom:(CGPoint )originalCenter
{    
    CGFloat xDist = ([self centerOnSuperView].x - originalCenter.x);
    CGFloat yDist = ([self centerOnSuperView].y - originalCenter.y);
    CGPoint tranlationPoint = CGPointMake(xDist, yDist);
    
    return tranlationPoint;
}

-(CGFloat)distanceFrom:(CGPoint)point1 to:(CGPoint)point2
{
    CGFloat xDist = (point2.x - point1.x);
    CGFloat yDist = (point2.y - point1.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

-(CGPoint)centerOnSuperView
{
    CGFloat width = self.superview.frame.size.width/2.0f;
    CGFloat height = self.superview.frame.size.height/2.0f;
    CGPoint center = CGPointMake(width, height);
    
    return center;
}

-(void)rotateInZPrev:(PSPage *)page
{
    CGFloat distanceFromCenter = [page distanceFrom:[page centerOnSuperView] to:page.center];
    CGFloat zAngle = -1 * 0.2f * distanceFromCenter/(page.superview.frame.size.width/3.0f);
    CGFloat angle = 15.0f * distanceFromCenter/(page.superview.frame.size.width/2.5f);
    //MAX(-1 * fmodl(distanceFromCenter, 0.2f), zAngle);
    
    [UIView animateWithDuration:.5 animations:^{
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, angle * M_PI / 180.0f, 0.0f, 1.0f, zAngle);
        page.layer.transform = rotationAndPerspectiveTransform;
        page.center = CGPointMake(page.center.x, page.superview.center.y + distanceFromCenter/6.0f);
    }];
}

-(void)rotateInZNext:(PSPage *)page
{
    CGFloat distanceFromCenter = [page distanceFrom:[page centerOnSuperView] to:page.center];
    CGFloat zAngle = -1 * (0.2f * distanceFromCenter/(page.superview.frame.size.width/3.0f));
    CGFloat angle = -1 * (15.0f * distanceFromCenter/(page.superview.frame.size.width/2.5f));
    
    [UIView animateWithDuration:.5 animations:^{
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, angle * M_PI / 180.0f, 0.0f, 1.0f, zAngle);
        page.layer.transform = rotationAndPerspectiveTransform;
        page.center = CGPointMake(page.center.x, page.superview.center.y + distanceFromCenter/6.0f);
    }];
}
@end
