//
//  URLFinder.m
//  URLKit
//
//  Created by Chad Gibbons on 12/8/12.
//  Copyright (c) 2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import "URLFinder.h"

@implementation URLFinder

+ (NSArray *)findURLs:(NSString *)text
{
    return [self findURLs:text usingPattern:kDefaultURLPattern];
}

+ (NSArray *)findURLs:(NSString *)text usingPattern:(NSString *)pattern
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:text
                                      options:0
                                        range:NSMakeRange(0, [text length])];
    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:[matches count]];
    for (NSTextCheckingResult *match in matches)
    {
        NSRange urlRange = [match rangeAtIndex:1];
        [urls addObject:[NSValue valueWithRange:urlRange]];
    }
    
    return urls;
}

@end
