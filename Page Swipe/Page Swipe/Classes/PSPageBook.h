//
//  PSPageBook.h
//  Page Swipe
//
//  Created by Reyneiro Hernandez on 4/13/13.
//  Copyright (c) 2013 Reyneiro Hernandez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPage.h"

@interface PSPageBook : UIView <PSPageDelegate>

@property (strong, nonatomic, readonly) NSArray *pages; //array of all the pages

-(void)addPage:(PSPage *)page;

@end
