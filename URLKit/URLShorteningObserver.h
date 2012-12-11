//
//  URLShorteningObserver.h
//  URLKit
//
//  Created by Chad Gibbons on 12/8/12.
//  Copyright (c) 2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol URLShorteningObserver <NSObject>

@optional
- (void)urlShortened:(NSURL *)url;

@optional
- (void)textWithURLsShortened:(NSString *)text;

@end
