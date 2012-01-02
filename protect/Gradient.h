//
//  Gradient.h
//  protect
//
//  Created by Howard Jing on 12/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//  SINGLETON
//  Associate every point on the coordinate system with a value
//  Ants will gravitate towards higher values and avoid lower values

#import <Foundation/Foundation.h>

@interface Gradient : NSObject {
    
    NSMutableArray *value;
    int width;
    int height;
    
}

@property (readonly) int width;
@property (readonly) int height;

// returns instance of shared singleton Gradient
+ (Gradient *)sharedGradient;

// returns f(x,y) 
- (double)getValueAtX:(int)x andY:(int)y; 

// sets the value to -infinity in circle centered
// around given location 
// (square for now)
- (void)depressValuesAt: (CGPoint)location;

// restores the values to original state
- (void)restoreValues: (CGPoint)location;


@end
