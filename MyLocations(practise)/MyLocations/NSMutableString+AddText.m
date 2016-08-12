//
//  NSMutableString+AddText.m
//  MyLocations
//
//  Created by Matthijs on 18-10-13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "NSMutableString+AddText.h"

@implementation NSMutableString (AddText)

- (void)addText:(NSString *)text withSeparator:(NSString *)separator
{
  if (text != nil) {
    if ([self length] > 0) {
      [self appendString:separator];
    }
    [self appendString:text];
  }
}

@end
