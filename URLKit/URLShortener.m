//
//  URLShortener.m
//  URLKit
//
//  Created by Chad Gibbons on 12/8/12.
//  Copyright (c) 2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import "URLShortener.h"

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
            shortener = nil;
            break;
    }
    
    NSAssert(shortener != nil, @"Unknown URLShortener provider specified");
    
    return shortener;
}

- (void)shortenURL:(NSURL *)url
          observer:(id <URLShorteningObserver> *)observer
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass",
     NSStringFromSelector(_cmd)];
}

- (void)shortenTextWithURLs:(NSString *)text
                   observer:(id <URLShorteningObserver> *)observer
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass",
     NSStringFromSelector(_cmd)];
}

@end
