//
//  Gradient.m
//  protect
//
//  Created by Howard Jing on 12/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// TDL: MAKE DEPRESSED VALUES A CIRCLE
// TDL: LEARN ABOUT BLOCKS

#import "Gradient.h"

// ==== DEFINITIONS START ====
#define MAX_WIDTH 1024
#define MAX_HEIGHT 768
#define HIT_RADIUS 20
#define AFFECT_RADIUS 40

// max of f(x,y)  
#define X_MAX 500
#define Y_MAX 500

#define FRIGHT -1000000000
#define DEATH -10000000000

// ==== DEFINITIONS END ====

static Gradient *sharedInstance = nil;

@implementation Gradient
//@synthesize value;
@synthesize width;
@synthesize height;

// ==== Boilerplate Singleton code start =====
+ (Gradient *)sharedGradient {
    @synchronized(self) {
        
        // only make a new object if sharedInstance is nil
        if (sharedInstance == nil) {
            [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        
        // only allocate memory if sharedInstance is nil
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    
    // don't make copies
    return self;
}

- (id)retain {
    return self;
}

- (oneway void)release {
    // do nothing
}

- (id)autorelease {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// ==== Boilerplate Singleton code end =====

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        width = MAX_WIDTH;
        height = MAX_HEIGHT;
        
        value = [[NSMutableArray alloc] initWithCapacity:MAX_WIDTH];
        for (int i=0; i<MAX_WIDTH; i++) {
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:MAX_HEIGHT];
            for (int j=0; j<MAX_HEIGHT; j++) {
                // the value at (x,y)
                double temp = -pow(i-X_MAX,2) + -pow(j-Y_MAX,2);
                [tempArray addObject: [NSNumber numberWithDouble:temp]];
            }
            [value addObject: tempArray];
            [tempArray release];
        }
    }
    
    return self;
}

- (double)getValueAtX:(int)x andY:(int)y {
    
    // if it's a valid position, find the value
    if ((x > 0) && (x < MAX_WIDTH) && (y > 0) && (y < MAX_HEIGHT)) {
        NSMutableArray *tempX = [value objectAtIndex:x];
        NSNumber *answer = [tempX objectAtIndex:y];
        //NSLog(@"value: %d", [answer intValue]);
        return [answer doubleValue];
    }
    // otherwise return some dummy value
    else {
        return 0;
    }
    
}

- (void)depressValuesAt:(CGPoint)location {
    
    // get the x and y coordinates, cast to int
    int x = (int)location.x;
    int y = (int)location.y;
    
    int left = x - AFFECT_RADIUS;
    int right = x + AFFECT_RADIUS;
    int top = y + AFFECT_RADIUS; 
    int bottom = y - AFFECT_RADIUS;
    
    int deathLeft = x - HIT_RADIUS;
    int deathRight = x + HIT_RADIUS;
    int deathTop = y + HIT_RADIUS;
    int deathBottom = y - HIT_RADIUS;
    
    for (int i=left; i<=right; i++) {
        NSMutableArray *row = [value objectAtIndex:i];
        for (int j=bottom; j<=top; j++) {
            double newValue = FRIGHT;
            // check to see if in hit radius
            if ((i >=deathLeft && i <= deathRight) &&
                (j >=deathBottom && j <= deathTop)) {
                newValue = DEATH;
            }
            [row replaceObjectAtIndex:j withObject:[NSNumber numberWithDouble:newValue]];
            
        }
    }
    
    // restore the values in 0.05 seconds
    
    // describe Gradient's restoreValues method signature
    NSMethodSignature *signature = [Gradient instanceMethodSignatureForSelector:@selector(restoreValues:)];
    // create the invocation, set the target, set selector, set arguments
    NSInvocation *restoreInvocation = [NSInvocation invocationWithMethodSignature:signature];
    [restoreInvocation setTarget:self];
    [restoreInvocation setSelector:@selector(restoreValues:)];
    [restoreInvocation setArgument:&location atIndex:2];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 invocation:restoreInvocation repeats:NO];
}

- (void)restoreValues:(CGPoint)location {

    int x = (int)location.x;
    int y = (int)location.y;
    //NSLog(@"location at: %d,%d", x,y);
    
    int left = x - AFFECT_RADIUS;
    int right = x + AFFECT_RADIUS;
    int top = y + AFFECT_RADIUS; 
    int bottom = y - AFFECT_RADIUS;
    
    for (int i=left; i<=right; i++) {
        NSMutableArray *row = [value objectAtIndex:i];
        for (int j=bottom; j<=top; j++) {
            double newValue = -pow(i-X_MAX,2) + -pow(j-Y_MAX,2);
            [row replaceObjectAtIndex:j withObject:[NSNumber numberWithDouble:newValue]];
        }
    }
    
}

-(void)dealloc {
    [value release];
    [super dealloc];
}

@end
