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

#define FRIGHT -1000000000
#define DEATH -10000000000

#define COOL 9

@implementation Ant

@synthesize x;
@synthesize y;
@synthesize direction;
@synthesize velocity;
@synthesize distance;
@synthesize frightened;

+ (double) directionNoise {
    return ((double)arc4random() / UINT32_MAX) * (2*M_PI);
}

- (id)init
{
    self = [super init];
    if (self) {
        
        // the shared gradient
        sharedGradient = [Gradient sharedGradient];
        
        // instance variables are random
        x = arc4random()%(MAX_WIDTH+1);
        y = arc4random()%(MAX_HEIGHT+1);
        
        repulsionRadius = 50;
        neutralRadius = 0;
        attractionRadius = 100;
        
        // direction is between 0 and 2pi
        direction = ((double)arc4random() / UINT32_MAX) * (2*M_PI);
        velocity = arc4random()%5 + 8;
        
        alteredDirection = direction;
        biasedVelocity = velocity;
        
        timeStep = 1;
        
        state = arc4random()%4;
        updateState = 0;
        distance = 0;
        
        // for frightened behavior
        frightened = NO;
        cooldown = COOL;
    }
    
    return self;
}

- (void)updateWithNeighbors:(NSMutableArray *)potentialNeighbors {
    
    // update the ant's state
    updateState = (updateState + 1)%2;
    if (updateState == 0) {
        state = (state + 1)%4;
    }
    
    if (frightened) {
        cooldown = cooldown - 1;
        if (cooldown <= 0) {
            frightened = NO;
            velocity = velocity / 2;
        }
    }
    
    
    
    // find the ant's new direction and velocity
    NSMutableArray *neighbors = [self findNeighbors:potentialNeighbors];
    [self findNewDirectionAndVelocity:neighbors];
    
    // update its position
    x = x + velocity*cos(direction)*timeStep;
    y = y + velocity*sin(direction)*timeStep;
    
    //NSLog(@"value: %f", [sharedGradient getValueAtX:x andY:y]);
    // reset if out of bounds
    if ((x < 0 || x > MAX_WIDTH) || (y < 0 || y > MAX_HEIGHT)) {
        [self init];
    }
    
    double value = [sharedGradient getValueAtX:x andY:y];
    
    // become frightened
    if (value == FRIGHT) {
        if (!frightened) {
            frightened = YES;
            cooldown = COOL;
            direction = -direction;
            velocity = 2*velocity;
        }
    }
    
    // reset if value is death
    if (value == DEATH) {
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
    //direction = 0.9*direction + 0.1*[Ant directionNoise];
    
    if (neighbors.count == 0) {
        // do nothing
    }
    else {
        double directionSum = 0;
        double velocitySum = 0;
        for (int i=0; i<neighbors.count; i++) {
            Ant *tempAnt = [neighbors objectAtIndex:i];
            
            // if distance is within attraction
            if (tempAnt.distance < repulsionRadius) {
                directionSum += tempAnt.direction;
                velocitySum += tempAnt.velocity;
            }
            
            // otherwise it is repulsion
            else {
                directionSum += tempAnt.direction;
                velocitySum += tempAnt.velocity;
            }
        }
        
        direction = 0.85*direction + 0.15*directionSum/neighbors.count;
        velocity = 0.85*velocity + 0.15*velocitySum/neighbors.count;
        //NSLog(@"velocity: %f, velocitySum: %f, neighborSum: %d", velocity, velocitySum, neighbors.count);
    }
    
    if (!frightened) {
        direction = 0.85*direction + 0.15*([self findOptimalDirection] + 0.15*[Ant directionNoise]);
        
        // offset direction based on state
        double changeDir = M_PI/6;
        switch (state) {
            case 0:
                //NSLog(@"state one, left");
                direction = direction + changeDir;
                break;
            case 1:
                //NSLog(@"state two, right");
                direction = direction - changeDir;
                break;
            case 2:
                //NSLog(@"state three, right again");
                direction = direction - changeDir;
                break;
            case 3:
                //NSLog(@"state four, left");
                direction = direction + changeDir;
                break;
            default:
                NSLog(@"default, no change");
                break;
        }
    }
    else {
        // keep same direction
    }
    //NSLog(@"direction: %f", direction);
}

- (double)findOptimalDirection {
    
    // get possible directions, take a step and stick with the highest one
    double changeDir = M_PI/4;
    NSMutableArray *maxDirs = [NSMutableArray array];
    
    // THIS SHOULD PROBABLY BE A LOOP
    // Case 1: default direction
    double tempDir = direction;
    double tempVal = [self findValueWithDir:tempDir];
    double maxVal = tempVal;
    [maxDirs addObject:[NSNumber numberWithDouble:tempDir]];
    
    // Case 2: forward-left
    tempDir = direction + changeDir;
    tempVal = [self findValueWithDir:tempDir];
    if (tempVal > maxVal) {
        maxVal = tempVal;
        [maxDirs replaceObjectAtIndex:0 withObject:[NSNumber numberWithDouble:tempDir]];
    }
    else if (tempVal == maxVal) {
        [maxDirs addObject: [NSNumber numberWithDouble:tempDir]];
    }
    
    // Case 3: forward-right
    tempDir = direction - changeDir;
    tempVal = [self findValueWithDir:tempDir];
    if (tempVal > maxVal) {
        maxVal = tempVal;
        [maxDirs replaceObjectAtIndex:0 withObject:[NSNumber numberWithDouble:tempDir]];
    }
    else if (tempVal == maxVal) {
        [maxDirs addObject: [NSNumber numberWithDouble:tempDir]];
    }
    
    // Case 4: backwards-left
    tempDir = -direction + changeDir;
    tempVal = [self findValueWithDir:tempDir];
    if (tempVal > maxVal) {
        maxVal = tempVal;
        [maxDirs replaceObjectAtIndex:0 withObject:[NSNumber numberWithDouble:tempDir]];
    }
    else if (tempVal == maxVal) {
        [maxDirs addObject: [NSNumber numberWithDouble:tempDir]];
    }
    
    // Case 5: backwards-right
    tempDir = -direction - changeDir;
    tempVal = [self findValueWithDir:tempDir];
    if (tempVal > maxVal) {
        maxVal = tempVal;
        [maxDirs replaceObjectAtIndex:0 withObject:[NSNumber numberWithDouble:tempDir]];
    }
    else if (tempVal == maxVal) {
        [maxDirs addObject: [NSNumber numberWithDouble:tempDir]];
    }
    
    // pick a random max direction
    int randomIndex = arc4random()%[maxDirs count];
    NSNumber *randomMaxDir = [maxDirs objectAtIndex:randomIndex];
    //NSLog(@"direction: %f", [randomMaxDir doubleValue]);
    return [randomMaxDir doubleValue];
}

- (double)findValueWithDir:(double)dir {
    int possibleX = [self updateXWithDir: dir];
    int possibleY = [self updateYWithDir: dir];
    return [sharedGradient getValueAtX:possibleX andY:possibleY];
}

- (int)updateXWithDir:(double)dir {
    return x + velocity*cos(dir);
    
}
- (int)updateYWithDir:(double)dir {
    return y + velocity*sin(dir);
}

@end
