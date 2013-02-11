//
//  URLKitTests.m
//  URLKitTests
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

#import "URLKitTests.h"
#import "URLShortener.h"
#import "BitlyProvider.h"
#import "GoogleProvider.h"

typedef void (^CompletionBlock)(NSString *text);

@interface TestObserver : NSObject <URLShorteningObserver>
{
    CompletionBlock _block;
}
- (id)initWithBlock:(CompletionBlock)block;
@end

@implementation TestObserver
- (id)initWithBlock:(CompletionBlock)block
{
    _block = block;
    return self;
}
- (void)textWithURLsShortened:(NSString *)text
{
    _block(text);
}
@end

@implementation URLKitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testDefaultProvider
{
    URLShortener *shortener = [URLShortener defaultURLShortener];
    STAssertNotNil(shortener, @"default provider not available");
    STAssertTrue([shortener isKindOfClass:[GoogleProvider class]],
                 @"default URLShortener object is not GoogleProvider");
}

- (void)testBitlyProvider
{
    URLShortener *shortener = [URLShortener urlShortenerWithProvider:URLShortenerProviderBitly];
    STAssertNotNil(shortener, @"BitLy provider not available");
    STAssertTrue([shortener isKindOfClass:[BitlyProvider class]],
                 @"default URLShortener object is not BitlyProvider");
}

- (void)testGoogleProvider
{
    URLShortener *shortener = [URLShortener urlShortenerWithProvider:URLShortenerProviderGoogle];
    STAssertNotNil(shortener, @"Google provider not available");
    STAssertTrue([shortener isKindOfClass:[GoogleProvider class]],
                 @"default URLShortener object is not GoogleProvider");
    
}

- (void)testProviderResults
{
    __block BOOL hasCalledBack = NO;
    __block NSString *shortenedText = nil;
    
    void (^completionBlock)(NSString *) = ^(NSString *text) {
        NSLog(@"Completion Block! text=%@", text);
        hasCalledBack = YES;
        shortenedText = [text copy];
    };
    
    TestObserver *testObserver = [[TestObserver alloc] initWithBlock:completionBlock];

    NSArray *tests = @[
                      @{
                        @"provider": @(URLShortenerProviderBitly),
                        @"result": @"http://bit.ly/WR5sD7"
                      },
                      @{
                        @"provider": @(URLShortenerProviderGoogle),
                        @"result": @"http://goo.gl/M6loJ"
                      }
    ];
    
    for (NSDictionary *test in tests)
    {
        NSUInteger provider = [test[@"provider"] unsignedLongValue];
        NSString *result = test[@"result"];
        
        hasCalledBack = NO;
        shortenedText = nil;
        
        URLShortener *shortener = [URLShortener urlShortenerWithProvider:provider];
        [shortener shortenTextWithURLs:@"http://www.nuclearbunny.com/projects/urlkit"
                              observer:testObserver];
        
        NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
        while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:loopUntil];
        }

        if (!hasCalledBack)
        {
            STFail(@"Timeout while requesting URL shortening from provider");
        }
        
        STAssertEqualObjects(result, shortenedText, @"returned URL does not match expected result");
    }
}

@end
