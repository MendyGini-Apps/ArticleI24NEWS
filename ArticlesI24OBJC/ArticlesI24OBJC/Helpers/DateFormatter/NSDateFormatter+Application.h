//
//  NSDateFormatter+Application.h
//  i24News
//
//  Created by Timur Bernikowich on 11/25/16.
//  Copyright © 2016 Webwag Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Application)

+ (NSTimeZone *)applicationServerTimeZone;
+ (NSDateFormatter *)articlesDateFormatter;
+ (NSDateFormatter *)alternativeArticlesDateFormatter;
+ (NSDate *)dateFromArticleDateString:(NSString *)dateString;
+ (NSDateFormatter *)dateFormatterForCurrentDate;

@end
