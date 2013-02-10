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

- (void)shortenTextWithURLs:(NSString *)text
observer:(id <URLShorteningObserver>)observer
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *googleAPIKey = [bundle objectForInfoDictionaryKey:@"GoogleAPIKey"];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSArray *urls = [[URLFinder findURLs:text] mutableCopy];
        NSMutableArray *shortenedURLs = [NSMutableArray arrayWithCapacity:10];
        
        for (NSValue *rangeValue in urls)
        {
            NSRange urlRange = [rangeValue rangeValue];
            NSString *urlText = [text substringWithRange:urlRange];
            
            if ([urlText length] > 20)
            {
                NSURL *google = [NSURL URLWithString:[NSString stringWithFormat:kGoogleRequest,
                                                      googleAPIKey]];

                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:google];
                [request setHTTPMethod:@"POST"];
                [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

                NSString *escapedURLText = [urlText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *myString = [NSString stringWithFormat:@"{\"longUrl\":\"%@\"}",
                                      escapedURLText];
                [request setHTTPBody:[myString dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSURLResponse *response = NULL;
                NSError *error = NULL;
                NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:0
                                                                       error:&error];
                NSString *newURL = json[@"id"];
                [shortenedURLs addObject:@{
                 @"range" : rangeValue,
                 @"newURL" : newURL
                 }];
            }
        }
        
        NSMutableString *newText = [text mutableCopy];
        for (NSDictionary *d in shortenedURLs)
        {
            NSRange urlRange = [d[@"range"] rangeValue];
            NSString *newURL = d[@"newURL"];
            [newText replaceCharactersInRange:urlRange withString:newURL];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^(void)
                      {
                          [observer textWithURLsShortened:newText];
                      });
    }];
    
    [queue addOperation:op];
}

@end
