//
//  BitlyProvider.m
//  URLKit
//
//  Created by Chad Gibbons on 12/8/12.
//  Copyright (c) 2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import "BitlyProvider.h"

@implementation BitlyProvider

#define kBitlyRequest @"http://api.bit.ly/shorten?version=2.0.1&format=json&login=%@&apiKey=%@&longUrl=%@"

- (void)shortenTextWithURLs:(NSString *)text
                   observer:(id <URLShorteningObserver>)observer
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bitlyUser = [bundle objectForInfoDictionaryKey:@"BitlyAPIUser"];
    NSString *bitlyAPIKey = [bundle objectForInfoDictionaryKey:@"BitlyAPIKey"];
    NSLog(@"bitlyuser=%@ bitlyAPIKey=%@", bitlyUser, bitlyAPIKey);
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSArray *urls = [[URLFinder findURLs:text] mutableCopy];
        NSMutableArray *shortenedURLs = [NSMutableArray arrayWithCapacity:10];
        
        for (NSValue *rangeValue in urls)
        {
            NSRange urlRange = [rangeValue rangeValue];
            NSString *urlText = [text substringWithRange:urlRange];
            
            if ([urlText length] > 24)
            {
                NSString *escapedURLText = [urlText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
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
                NSString *newURL = urlText;
                if ([statusCode compare:@"OK" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                {
                    NSDictionary *results = json[@"results"][urlText];
                    newURL = results[@"shortUrl"];
                    [shortenedURLs addObject:@{
                     @"range" : rangeValue,
                     @"newURL" : newURL
                     }];
                }
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
