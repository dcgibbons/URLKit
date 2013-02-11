//
//  GoogleProvider.m
//  URLKit
//
//  Created by Chad Gibbons on 2013-10-02.
//
//  Copyright 2013 Nuclear Bunny Studios, LLC.
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

#import "GoogleProvider.h"

@implementation GoogleProvider

#define kGoogleRequest  @"https://www.googleapis.com/urlshortener/v1/url?key=%@"
#define kMinimumURLSize 18  // len(http://goo.gl/wQQW)

- (NSString *)shortenURLTextSynchronously:(NSString *)longURLtext
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *googleAPIKey = [bundle objectForInfoDictionaryKey:@"GoogleAPIKey"];
    
    NSString *newURL = nil;
    if ([longURLtext length] < kMinimumURLSize)
    {
        newURL = longURLtext;
    }
    else
    {
        NSURL *google = [NSURL URLWithString:[NSString stringWithFormat:kGoogleRequest,
                                              googleAPIKey]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:google];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSString *myString = [NSString stringWithFormat:@"{\"longUrl\":\"%@\"}",
                              longURLtext];
        [request setHTTPBody:[myString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *response = NULL;
        NSError *error = NULL;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:&error];
        newURL = json[@"id"];
    }

    return newURL;
}

@end
