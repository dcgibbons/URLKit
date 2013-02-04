URLKit
======

URL Shortening for Mac OS X and iOS

URLKit provides your applications with a way to shorten long URLs using a 
variety of common URL shortening services, such as Bit.Ly or Google. There are
options for shortening both a single NSURL, or a block of text that may contain
many embedded URLs within, e.g. from a pasteboard buffer.

URLKit is implemented such that the shortening takes place in a secondary
thread within Grand Dispatch. When the shortening process has completed, an
observer object provided to URLKit will be called with the results of the
shortening process.

USAGE
-----

````objc
@interface MyController : NSObject <URLShorteningObserver>
@end

@implementation MyController

- (void)doSomethingAwesome
{
    const URLShortener *shortener = [URLShortener defaultURLShortener];
    
    const NSString *text = @"hello, this is cool: http://newoldage.blogs.nytimes.com/2013/02/01/caregiving-laced-with-humor/?hp but this one isn't that cool http://religion.blogs.cnn.com/2013/01/29/poll-quarter-of-americans-say-god-influences-sporting-events/";

    [shortener shortenTextWithURLs:text observer:self];
}

- (void)textWithURLsShortened:(NSString *)text
{
    ...
}

@end
````

LICENSE
-------
Copyright 2012-2013 Nuclear Bunny Studios, LLC

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
