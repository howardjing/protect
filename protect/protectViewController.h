//
//  protectViewController.h
//  protect
//
//  Created by Howard Jing on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Swarm.h"
#import "Gradient.h"

@interface protectViewController : UIViewController {
    
    Swarm *ants;
    Gradient *sharedGradient;
    IBOutlet UIButton *updateButton;
    
}

@property(nonatomic, retain) UIButton *updateButton; 

- (void) gameLoop;
- (IBAction) update:(id)sender;

@end
