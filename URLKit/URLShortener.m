//
//  URLShortener.m
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

#import "URLShortener.h"
#import "GoogleProvider.h"
#import "BitlyProvider.h"

@implementation URLShortener

+ (id)defaultURLShortener
{
    return [self urlShortenerWithProvider:URLShortenerProviderGoogle];
}

+ (id)urlShortenerWithProvider:(URLShortenerProvider)provider
{
    URLShortener *shortener = nil;

    switch (provider)
    {
        case URLShortenerProviderBitly:
            shortener = [[BitlyProvider alloc] init];
            break;
        case URLShortenerProviderGoogle:
            shortener = [[GoogleProvider alloc] init];
            break;
    }
    
    NSAssert(shortener != nil, @"Unknown URLShortener provider specified");
    
    return shortener;
}

- (void)shortenURL:(NSURL *)url
          observer:(id <URLShorteningObserver>)observer
{
    NSString *urlText = [url absoluteString];
    [self shortenTextWithURLs:urlText observer:observer];
}

- (void)shortenTextWithURLs:(NSString *)text
                   observer:(id <URLShorteningObserver>)observer
{
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSArray *urls = [[URLFinder findURLs:text] mutableCopy];
        NSMutableArray *shortenedURLs = [NSMutableArray arrayWithCapacity:10];
        
        for (NSValue *rangeValue in urls)
        {
            NSRange urlRange = [rangeValue rangeValue];
            NSString *urlText = [text substringWithRange:urlRange];
            
            NSString *shortenedURL = [self shortenURLTextSynchronously:urlText];
            [shortenedURLs addObject:@{
             @"range" : rangeValue,
             @"newURL" : shortenedURL
             }];
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

- (NSString *)shortenURLTextSynchronously:(NSString *)longURLtext
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass",
     NSStringFromSelector(_cmd)];
    return nil;
}

@end
