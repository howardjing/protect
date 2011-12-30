//
//  protectViewController.h
//  protect
//
//  Created by Howard Jing on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Swarm.h"

@interface protectViewController : UIViewController {
    
    Swarm *ants;
    
}

- (void) gameLoop;

@end
