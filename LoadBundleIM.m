//
//  LoadBundleIM.m
//  LoadBundles
//
//  Created by Grayson Hansard on 12/13/08.
//  Copyright 2008 From Concentrate Software. All rights reserved.
//

#import "LoadBundleIM.h"


@implementation LoadBundleIM

+ (void)initialize
{
	NSLog(@"%s LoadBundleIM", _cmd);
}

+ (void)load
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSDictionary *dict = [(NSDictionary *)CFPreferencesCopyValue(CFSTR("bundle_info"), CFSTR("com.fcs.LoadBundles"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost) autorelease];
	
	for (NSDictionary *info in dict) {
		if ([[info objectForKey:@"application"] isEqualToString:[[NSBundle mainBundle] bundlePath]]) {
			NSString *bundlePath = [info objectForKey:@"bundle"];
			if (!bundlePath) goto bail;
			NSBundle *b = [NSBundle bundleWithPath:bundlePath];
			if (b) {
				[b load];
				[[b principalClass] new];
			}
		}
	}
	
	bail:;
	[pool release];
}

- (id)init
{
	self = [super init];
	if (!self) return nil;
	
	NSLog(@"%s LoadBundleIM", _cmd);
	
	return self;
}

@end
