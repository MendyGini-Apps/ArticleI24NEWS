//
//  NSDateFormatter+Application.m
//  i24News
//
//  Created by Timur Bernikowich on 11/25/16.
//  Copyright © 2016 Webwag Mobile. All rights reserved.
//

#import "NSDateFormatter+Application.h"

@implementation NSDateFormatter (Application)

+ (NSTimeZone *)applicationServerTimeZone
{
    // API team should provide dates in UTC time zone.
    return [NSTimeZone timeZoneForSecondsFromGMT:0];
}

+ (NSDateFormatter *)articlesDateFormatter
{
    static NSString *key = @"NSDateFormatterApplicationArticles";
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[key];
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [self applicationServerTimeZone];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        threadDictionary[key] = dateFormatter;
    }
    return dateFormatter;
}

+ (NSDateFormatter *)alternativeArticlesDateFormatter
{
    static NSString *key = @"NSDateFormatterApplicationArticlesAlternative";
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[key];
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [self applicationServerTimeZone];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        threadDictionary[key] = dateFormatter;
    }
    return dateFormatter;
}

+ (NSDateFormatter *)secondAlternativeArticlesDateFormatter
{
    static NSString *key = @"NSDateFormatterApplicationArticlesSecondAlternative";
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[key];
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [self applicationServerTimeZone];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        threadDictionary[key] = dateFormatter;
    }
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatterForCurrentDate
{
    static NSString *key = @"NSDateFormatterApplicationForCurrentDate";
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[key];
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return dateFormatter;
}

+ (NSDate *)dateFromArticleDateString:(NSString *)dateString
{
    if (!dateString) {
        return nil;
    }
    
    NSDate *date = [[self articlesDateFormatter] dateFromString:dateString];
    if (date) {
        return date;
    }
    
    date = [[self alternativeArticlesDateFormatter] dateFromString:dateString];
    if (date) {
        return date;
    }
    
    return [[self secondAlternativeArticlesDateFormatter] dateFromString:dateString];
}

@end
