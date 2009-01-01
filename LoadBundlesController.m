//
//  LoadBundlesController.m
//  LoadBundles
//
//  Created by Grayson Hansard on 12/13/08.
//  Copyright 2008 From Concentrate Software. All rights reserved.
//

#import "LoadBundlesController.h"

#define BUNDLE_INFO_KEY @"bundle_info"

@interface LoadBundlesController (PrivateMethods)
- (BOOL)installBundle:(NSError **)anError;
@end

@implementation LoadBundlesController

@synthesize bundleInfo = _bundleInfo;

- (void)awakeFromNib
{
	NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:BUNDLE_INFO_KEY];
	if (!array) array = [NSArray array];
	self.bundleInfo = array;
	NSError *err = nil;
	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/Library/InputManagers/LoadBundles/LoadBundleInputManager.bundle"])
		[self installBundle:&err];
	NSLog(@"%s %@", _cmd, err);
}

- (BOOL)installBundle:(NSError **)anError
{
	NSString *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];

	AuthorizationRef myAuthorizationRef;
	OSStatus myStatus;
	myStatus = AuthorizationCreate (NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &myAuthorizationRef);

	if (![fm fileExistsAtPath:@"/Library/InputManagers/LoadBundles/"]) {
		//Set up simple rights
		if (myStatus == noErr)
		{
		    char *args[3]; // arguments for the mv command
			args[0] = "-p";
		    args[1] = "/Library/InputManagers/LoadBundles/"; // force the mv so it won't ask for confirmation
			args[2] = NULL;

		    myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef, "/bin/mkdir", 0, args, NULL);
			if (myStatus != noErr) {
				error = NSLocalizedString(@"Error creating directory", @"error");
				goto createError;
			}
		}
	}
	
	if (![fm fileExistsAtPath:@"/Library/InputManagers/LoadBundles/LoadBundleInputManager.bundle"]) {
		if (myStatus == noErr)
		{
			NSString *path = [[NSBundle mainBundle] pathForResource:@"LoadBundleInputManager" ofType:@"bundle"];
		    char *args[4]; // arguments for the mv command
		    args[0] = "-f"; // force the mv so it won't ask for confirmation
		    args[1] = (char *)[path UTF8String]; // path of file to move
		    args[2] = "/Library/InputManagers/LoadBundles/"; // location to move to
		    args[3] = NULL; // terminate the args

		    myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef, "/bin/mv", 0, args, NULL);

			if (myStatus != noErr) {
				error = NSLocalizedString(@"Error moving file", @"error");
				goto createError;
			}
		}
	}
	
	if (![fm fileExistsAtPath:@"/Library/InputManagers/LoadBundles/Info"] && myStatus == noErr) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@""];
	    char *args[4]; // arguments for the mv command
	    args[0] = "-f"; // force the mv so it won't ask for confirmation
	    args[1] = (char *)[path UTF8String]; // path of file to move
	    args[2] = "/Library/InputManagers/LoadBundles/"; // location to move to
	    args[3] = NULL; // terminate the args

		myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef, "/bin/mv", 0, args, NULL);

		if (myStatus != noErr) {
			error = NSLocalizedString(@"Error moving file", @"error");
			goto createError;
		}
	}
	
	char *args[4];
	args[0] = "-R";
	args[1] = "root:admin";
	args[3] = "/Library/InputManagers";
	args[4] = NULL;
	myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef, "/usr/sbin/chown", 0, args, NULL);
	
	return true;
	
	createError:
	*anError = [NSError errorWithDomain:NSPOSIXErrorDomain code:-1 userInfo:[NSDictionary dictionaryWithObject:error forKey:NSLocalizedDescriptionKey]];
	return false;
}

- (IBAction)add:(id)sender {
	NSOpenPanel *op = [NSOpenPanel openPanel];
	[op setTitle:NSLocalizedString(@"Choose application", @"open panel title")];
	if ([op runModal] != NSOKButton || !op.filename) return;
	NSString *applicationPath = [NSString stringWithString:[op filename]];
	
	op = [NSOpenPanel openPanel];
	[op setTitle:NSLocalizedString(@"Choose bundle", @"open panel title")];
	if ([op runModal] != NSOKButton || !op.filename) return;
	NSString *bundlePath = [NSString stringWithString:[op filename]];
	
	NSMutableArray *array = [self.bundleInfo.mutableCopy autorelease];
	[array addObject:[NSDictionary dictionaryWithObjectsAndKeys:applicationPath, @"application", bundlePath, @"bundle", nil]];
	self.bundleInfo = array;
	[[NSUserDefaults standardUserDefaults] setObject:array forKey:BUNDLE_INFO_KEY];
}

- (IBAction)delete:(id)sender {
	NSMutableArray *array = [self.bundleInfo.mutableCopy autorelease];
	NSIndexSet *selection = [tableView selectedRowIndexes];
	if (!selection || ![selection count]) return;
	unsigned int count = selection.count;
	unsigned int indexes[count];
	[selection getIndexes:indexes maxCount:count inIndexRange:nil];
	unsigned int i = 0;
	for (i=0; i < count; i++) [array removeObjectAtIndex:indexes[i]];
	self.bundleInfo = array;
	[[NSUserDefaults standardUserDefaults] setObject:array forKey:BUNDLE_INFO_KEY];
}

@end
