//
//  Swarm.h
//  protect
//
//  Created by Howard Jing on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

//  A collection of ants and images of ants

#import <Foundation/Foundation.h>

@interface Swarm : NSObject {
    int pop; // how many ants in the swarm
    NSMutableArray *ants; // an array of ants
    NSMutableArray *antsImageView; // imageview of each corresponding ant
}

@property (readonly) int pop;
@property (retain) NSMutableArray *ants;
@property (retain) NSMutableArray *antsImageView;

- (id)initWithPop: (int)population;
- (void)update;

@end
