//
//  Ant.m
//  protect
//
//  Created by Howard Jing on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Ant.h"
#import <stdlib.h> // for randomness

#define MAX_WIDTH 1024
#define MAX_HEIGHT 768

@implementation Ant

@synthesize x;
@synthesize y;
@synthesize direction;
@synthesize velocity;
@synthesize distance;

+ (double) directionNoise {
    return ((double)arc4random() / UINT32_MAX) * (2*M_PI);
}

- (id)init
{
    self = [super init];
    if (self) {
        // instance variables are random
        x = arc4random()%(MAX_WIDTH+1);
        y = arc4random()%(MAX_HEIGHT+1);
        
        repulsionRadius = 50;
        neutralRadius = 0;
        attractionRadius = 100;
        
        // direction is between 0 and 2pi
        direction = ((double)arc4random() / UINT32_MAX) * (2*M_PI);
        velocity = arc4random()%5 + 8;
        
        biasedDirection = direction;
        biasedVelocity = velocity;
        
        timeStep = 1;
        
        state=0;
        distance=0;
    }
    
    return self;
}

- (void)updateWithNeighbors:(NSMutableArray *)potentialNeighbors {
    
    // find the ant's new direction and velocity
    NSMutableArray *neighbors = [self findNeighbors:potentialNeighbors];
    [self findNewDirectionAndVelocity:neighbors];
    
    // update its position
    x = x + velocity*cos(direction)*timeStep;
    y = y + velocity*sin(direction)*timeStep;
    
    // reset if out of bounds
    if ((x < 0 || x > MAX_WIDTH) || (y < 0 || y > MAX_HEIGHT)) {
        [self init];
    }
    
}

- (NSMutableArray *)findNeighbors:(NSMutableArray *)potentialNeighbors {
    
    NSMutableArray *neighbors = [[NSMutableArray alloc] init];
    for (int i=0; i<potentialNeighbors.count; i++) {
        Ant *tempAnt = [potentialNeighbors objectAtIndex:i];
        if (![self isEqual: tempAnt]) {
            // determine if the potential neighbor is within the proper radius
            double thisDistance = sqrt(pow((self.x - tempAnt.x),2) + pow((self.y - tempAnt.y), 2));
            if (thisDistance < attractionRadius) {
                tempAnt.distance = thisDistance;
                [neighbors addObject:tempAnt];
            }
        }
    }
    return [neighbors autorelease];
}

- (void)findNewDirectionAndVelocity:(NSMutableArray *)neighbors {
    
    // add some noise (linear combinations)
    direction = 0.7*direction + 0.3*[Ant directionNoise];
    
    if (neighbors.count == 0) {
        // do nothing
    }
    else {
        double directionSum = 0;
        double velocitySum = 0;
        for (int i=0; i<neighbors.count; i++) {
            Ant *tempAnt = [neighbors objectAtIndex:i];
            if (tempAnt.distance < repulsionRadius) {
                directionSum += tempAnt.direction;
                velocitySum += tempAnt.velocity;
                
            }
            else {
                directionSum += tempAnt.direction;
                velocitySum += tempAnt.velocity;
            }
        }
        
        //NSLog(@"directionNoise: %f",direction);
        direction = 0.85*direction + 0.15*directionSum/neighbors.count;
        velocity = 0.85*velocity + 0.15*velocitySum/neighbors.count;
        //NSLog(@"velocity: %f, velocitySum: %f, neighborSum: %d", velocity, velocitySum, neighbors.count);
    }
}

@end
