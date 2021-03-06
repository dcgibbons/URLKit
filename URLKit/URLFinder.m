//
//  URLFinder.m
//  URLKit
//
//  Created by Chad Gibbons on 12/8/12.
//
//  Copyright 2012-2013 Nuclear Bunny Studios, LLC.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
