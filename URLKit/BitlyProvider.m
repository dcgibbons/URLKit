//
//  BitlyProvider.m
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

#import "BitlyProvider.h"

@implementation BitlyProvider

#define kBitlyRequest   @"http://api.bit.ly/shorten?version=2.0.1&format=json&login=%@&apiKey=%@&longUrl=%@"
#define kMinimumURLSize 20  // len(http://bit.ly/WR5sD7)

- (NSString *)shortenURLTextSynchronously:(NSString *)longURLtext
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bitlyUser = [bundle objectForInfoDictionaryKey:@"BitlyAPIUser"];
    NSString *bitlyAPIKey = [bundle objectForInfoDictionaryKey:@"BitlyAPIKey"];
    
    NSString *newURL = nil;
    if ([longURLtext length] < kMinimumURLSize)
    {
        newURL = longURLtext;
    }
    else
    {
        NSString *escapedURLText = [longURLtext stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *bitlyURL = [NSString stringWithFormat:kBitlyRequest,
                              bitlyUser,
                              bitlyAPIKey,
                              escapedURLText];
        
        NSURL *bitly = [NSURL URLWithString:bitlyURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:bitly];
        NSURLResponse *response = NULL;
        NSError *error = NULL;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:&error];
        NSString *statusCode = json[@"statusCode"];
        if ([statusCode compare:@"OK" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            NSDictionary *results = [json[@"results"] allValues][0];
            newURL = results[@"shortUrl"];
        }
    }
    
    return newURL;
}

@end
