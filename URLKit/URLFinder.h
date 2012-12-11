//
//  URLFinder.h
//  URLKit
//
//  Created by Chad Gibbons on 12/8/12.
//  Copyright (c) 2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLFinder : NSObject

#define kDefaultURLPattern              @"(?s)((?:\\w+://|\\bwww\\.[^.])\\S+)"

+ (NSArray *)findURLs:(NSString *)text;
+ (NSArray *)findURLs:(NSString *)text usingPattern:(NSString *)pattern;

@end
