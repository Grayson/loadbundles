//
//  LoadBundlesController.h
//  LoadBundles
//
//  Created by Grayson Hansard on 12/13/08.
//  Copyright 2008 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Security/Security.h>

@interface LoadBundlesController : NSObject {
	NSArray *_bundleInfo;
	IBOutlet NSTableView *tableView;
}

@property (retain) NSArray *bundleInfo;

- (IBAction)add:(id)sender;
- (IBAction)delete:(id)sender;

@end
