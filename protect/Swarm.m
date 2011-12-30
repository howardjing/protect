//
//  Swarm.m
//  protect
//
//  Created by Howard Jing on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Swarm.h"
#import "Ant.h"

#define ANT_WIDTH 30
#define ANT_HEIGHT 30

@implementation Swarm

@synthesize pop;
@synthesize ants;
@synthesize antsImageView;


- (id)init
{
    self = [super init];
    if (self) {
        ants = [[NSMutableArray alloc] init];
        antsImageView = [[NSMutableArray alloc] init];
        pop = 0;
    }
    
    return self;
}

- (id)initWithPop: (int)population {
    [self init];
    pop = population;
    UIImage *antImage = [UIImage imageNamed: @"dot.png"];
    for (int i=0; i<population; i++) {
        Ant *tempAnt = [[Ant alloc] init];
        [ants addObject:tempAnt];
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame: CGRectMake(tempAnt.x, tempAnt.y, ANT_WIDTH,ANT_HEIGHT)];
        [tempImageView setImage:antImage];
        [antsImageView addObject:tempImageView];
        
        [tempAnt release];
        [tempImageView release];
    }
    
    return self;
}

// updates the individual ant's position, and updates the imageview accordingly
- (void)update {

    for (int i=0; i<pop; i++) {
        Ant *tempAnt = [ants objectAtIndex:i];
        [tempAnt updateWithNeighbors: ants];
        [[antsImageView objectAtIndex:i] setFrame: CGRectMake(tempAnt.x, tempAnt.y, ANT_WIDTH, ANT_HEIGHT)];
    }
}

- (void)dealloc {
    [ants release];
    [antsImageView release];
    [super dealloc];
}

@end
