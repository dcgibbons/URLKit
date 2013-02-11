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


BUILDING
--------

URLKit is provided as an Xcode project with two primary targets: URLKit, a
framework for Mac OS X, and URLKitLibrary, a Cocoa Touch Static Library for
iOS. To embed URLKit into your application, do the following:

For *Mac OS X*
 1. Insert the URLKit Xcode project into your application's project.
 2. Add the URLKit framework as a dependency to your target(s).
 3. Add URLKit.framework to your Link Binaries with Libraries build phase.
 4. Add #import <URLKit/URLKit.h> to your source modules as needed.

For *iOS*
 1. Insert the URLKit Xcode project into your application's project.
 2. Add URLKitLibrary as a dependency to your target(s).
 3. Add libURLKitLibrary.a to your Link Binaries with Libraries build phrase.
 4. Copy all of the API Key settings from URLKit-Info.plist into your
    application's .plist file. Today these include BitlyAPIUser, BitlyAPIKey, and
    GoogleAPIKey.
 5. Add #import <URLKitLibrary/URLKit.h> to your source modules as needed.


API KEYS
--------

URLKit calls out to third-party URL shortening services that require API 
credentials in order to use their services. It is best practice not to include
API keys and other security credentials in your source code repositories,
especially those that are public. How can you manage this with URLKit?

As part of the final build process, URLKit will look for a file named 
~/.api_keys that contains overrides to the default values of the API key 
variables. The default values for these variables are provided in this project's
URLKit-Info.plist file. As part of the final build step, the correct values 
will be fetched from your ~/.api_keys files and substituted into the final
Info.plist file.

Presently, the following API Key variables are supported by URLKit:

```
BITLY_API_USERID
BITLY_API_KEY
GOOGLE_API_KEY
````


ADDING A NEW PROVIDER
---------------------

To add a new URL Shortening provider, perform the following steps:

 1. Add and implement your new provider class, e.g. FoobarProvider. The easiest
    thing to do is to implement a version of shortenURLTextSynchronously for
    your specific provider and let URLShortener.m do all the work of splitting
    up multiple URLs and handling operation queues as needed.
 2. Update the unit tests to test your new provider
 3. Add FoobarProvider to the URLShortenerProvider enum in URLShortener.h
 4. Determine what API key credentials are needed by your provider, e.g.
    FoobarAPIKey
 5. Add FoobarAPIKey to URLKit-Info.Plist
 6. Modify the script Build Phase and add a translation of FOOBAR_API_KEY to
    FoobarAPIKey so that actual API keys can be correctly fetched from 
    ~/.api_keys
 7. Test!


QUESTIONS OR SUGGESTIONS?
-------------------------

Please drop an email to support@nuclearbunny.com and we'll get back to you as
soon as we can.

If you are a developer, patches are always welcome via GitHub. Please use a
topic branch for any pull requests.


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
