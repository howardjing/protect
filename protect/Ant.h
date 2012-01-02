//
//  Ant.h
//  protect
//
//  Created by Howard Jing on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//  Representation of an ant

#import <Foundation/Foundation.h>
#import "Gradient.h"

@interface Ant : NSObject {
    
    // values at each (x,y) location
    Gradient *sharedGradient;
    
    // location on graph
    int x;
    int y;
    
    // how far away ant can see
    int repulsionRadius;
    int neutralRadius;
    int attractionRadius;
    
    // how ant moves
    double direction;
    double velocity;
    
    double alteredDirection; // for zigzagging
    double biasedVelocity;
    
    double timeStep;
    
    // more behavior stuff
    int state;
    int updateState; // if this is 0, then update the state
    double distance;
    
    bool frightened; // determine if frightened or not
    int cooldown;
}

@property int x;
@property int y;
@property double direction;
@property double velocity;
@property double distance;
@property bool frightened;

+ (double)directionNoise;
- (void)updateWithNeighbors:(NSMutableArray *) potentialNeighbors;
- (NSMutableArray *)findNeighbors: (NSMutableArray *) potentialNeighbors;
- (void)findNewDirectionAndVelocity: (NSMutableArray *) neighbors;
- (double)findOptimalDirection;

- (double)findValueWithDir:(double)dir;
- (int)updateXWithDir:(double)dir;
- (int)updateYWithDir:(double)dir;

@end
