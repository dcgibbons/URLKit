//
//  URLShortener.m
//  URLKit
//
//  Created by Chad Gibbons on 12/8/12.
//  Copyright (c) 2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import "URLShortener.h"
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
            shortener = nil;
            break;
        case URLShortenerProviderGoogle:
            shortener = [[BitlyProvider alloc] init];
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
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass",
     NSStringFromSelector(_cmd)];
}



//    // a special paste will look for URLs in the pasteboard text and then
//    // send them to a URL shortener processor before they are pasted to the
//    // input buffer
//    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
//    NSArray *classes = @[[NSString class]];
//    NSDictionary *options = @{};
//    NSArray *copiedItems = [pasteboard readObjectsForClasses:classes
//                                                     options:options];
//    for (NSString *text in copiedItems)
//    {
//        NSError *error = NULL;
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kDefaultURLPattern
//                                                                               options:NSRegularExpressionCaseInsensitive
//                                                                                 error:&error];
//
//        NSArray *matches = [regex matchesInString:text
//                                          options:0
//                                            range:NSMakeRange(0, [text length])];
//
//        for (NSTextCheckingResult *match in matches)
//        {
//            NSRange urlRange = [match rangeAtIndex:1];
//            NSString *urlText = [text substringWithRange:urlRange];
//            [URLHelper shortenURL:[NSURL URLWithString:urlText]
//                       toSelector:@selector(pasteURL:)
//                         onObject:self];
//        }
//
//        // TODO: this special paste doesn't deal with the text in the pasteboard
//        // that aren't URL's! whoops
//    }

@end
