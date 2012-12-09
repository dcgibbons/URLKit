//
//  URLShortener.h
//  URLKit
//
//  Created by Chad Gibbons on 12/8/12.
//  Copyright (c) 2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "URLShorteningObserver.h"

#define kDefaultURLPattern              @"(?s)((?:\\w+://|\\bwww\\.[^.])\\S+)"

typedef enum : NSUInteger
{
    URLShortenerProviderBitly,
    URLShortenerProviderGoogle
} URLShortenerProvider;

@interface URLShortener : NSObject

+ (id)defaultURLShortener;

+ (id)urlShortenerWithProvider:(URLShortenerProvider)provider;

- (void)shortenURL:(NSURL *)url
          observer:(id <URLShorteningObserver> *)observer;

- (void)shortenTextWithURLs:(NSString *)text
                   observer:(id <URLShorteningObserver> *)observer;

@end

