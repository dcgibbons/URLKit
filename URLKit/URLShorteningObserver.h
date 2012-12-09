//
//  URLShorteningObserver.h
//  URLKit
//
//  Created by Chad Gibbons on 12/8/12.
//  Copyright (c) 2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol URLShorteningObserver <NSObject>

- (void)urlShortened:(NSURL *)url;

- (void)textWithURLsShortened:(NSString *)text;

@end
