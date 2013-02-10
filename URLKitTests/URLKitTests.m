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

@end
