//
//  protectViewController.m
//  protect
//
//  Created by Howard Jing on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "protectViewController.h"

#define POP 320

@implementation protectViewController
@synthesize updateButton;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}

// Game loop logic
- (void)gameLoop {
    [ants update];
}

// for debugging
- (IBAction)update:(id)sender {
    [ants update];
}

- (void)dealloc {
    // release instance variables
    [ants release];
    [sharedGradient release];
    [super dealloc];
}

// interaction
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // BOOL touched = true
    // update gradient with new values
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    //NSLog(@"location: %f,%f", location.x, location.y);
    [sharedGradient depressValuesAt:location];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // BOOL touched = false
    // switch gradient back to normal
    //UITouch *touch = [[event allTouches] anyObject];
    //CGPoint location = [touch locationInView:self.view];
    //NSLog(@"location: %f,%f", location.x, location.y);
    //[sharedGradient restoreValuesAt:location];
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // make the gradient
    sharedGradient = [Gradient sharedGradient];
    
    // make a new ant
    ants = [[Swarm alloc] initWithPop:POP];
    for (int i=0; i<POP; i++) {
        [self.view addSubview: [ants.antsImageView objectAtIndex:i]];
    }
    
    // start the game loop
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

// only supports landscape mode
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        || (interfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
        return YES;
    }
    else {
        return NO;
    }
}


@end
