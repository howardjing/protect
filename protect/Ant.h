//
//  Ant.h
//  protect
//
//  Created by Howard Jing on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//  Representation of an ant

#import <Foundation/Foundation.h>

@interface Ant : NSObject {
    
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
    
    double biasedDirection;
    double biasedVelocity;
    
    double timeStep;
    
    // more behavior stuff
    int state;
    double distance;
}

@property int x;
@property int y;
@property double direction;
@property double velocity;
@property double distance;

+ (double)directionNoise;
- (void)updateWithNeighbors: (NSMutableArray *) potentialNeighbors;
- (NSMutableArray *)findNeighbors: (NSMutableArray *) potentialNeighbors;
- (void)findNewDirectionAndVelocity: (NSMutableArray *) neighbors;
@end
