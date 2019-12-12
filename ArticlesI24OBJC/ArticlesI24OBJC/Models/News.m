//
//  News.m
//  i24News
//
//  Created by Timur Bernikowich on 1/6/17.
//  Copyright © 2017 Webwag Mobile. All rights reserved.
//

#import "News.h"

// Models
#import "Article.h"

@implementation News

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    News *object = [super objectWithDictionary:dictionary];
    if (!object) {
        return nil;
    }
    
    NSTEasyJSON *JSON = [NSTEasyJSON withObject:dictionary];
    
    object.objectID = @(JSON[@"id"].integerValue);
    object.titleHTML = JSON[@"title"].string;
    object.attributedTitle = [self attributedStringWithHTMLString:object.titleHTML];
    object.section = JSON[@"tag"][@"name"].string;
    object.bodyHTML = JSON[@"body"].string;
    object.attributedBody = [self attributedStringWithHTMLString:object.bodyHTML];
    object.imageURL = JSON[@"image"][@"href"].URL;
    
    object.startedAt = [NSDateFormatter dateFromArticleDateString:JSON[@"startedAt"].string];
    object.href = JSON[@"href"].URL;
    object.status = [self statusWithString:JSON[@"status"].string];
    
    NSDictionary *relatedContent = JSON[@"relatedContent"].dictionary;
    if (relatedContent) {
        NSTEasyJSON *relatedJSON = JSON[@"relatedContent"];
        NSString *type = relatedJSON[@"type"].string;
        if ([type isEqualToString:@"article"]) {
            Article *article = [Article new];
            article.objectID = @(relatedJSON[@"id"].stringValue.integerValue);
            object.relatedArticle = article;
        } else if (type != nil) {
            
        }
    }
    
    return object;
}

+ (NewsStatus)statusWithString:(NSString *)string
{
    NewsStatus status = NewsStatusUnknown;
    if ([string isEqualToString:@"breaking"]) {
        status = NewsStatusBreaking;
    }
    return status;
}

@end

@implementation News (Sorting)

+ (NSArray<NSArray<News *> *> *)newsSortedByDateWithNews:(NSArray<News *> *)allNews
{
    if (!allNews) {
        return nil;
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startedAt" ascending:NO];
    allNews = [allNews sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    static NSString *key = @"NewsSortingDateFormatter";
    NSDateFormatter *dateFormatter = [NSThread currentThread].threadDictionary[key];
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd MM yyyy";
        [NSThread currentThread].threadDictionary[key] = dateFormatter;
    }
    
    NSMutableArray<NSArray<News *> *> *sections = [NSMutableArray new];
    NSString *lastDate;
    NSMutableArray<News *> *sectionItems;
    for (News *news in allNews) {
        if (!news.startedAt) {
            continue;
        }
        
        NSString *dateString = [dateFormatter stringFromDate:news.startedAt];
        if (![dateString isEqualToString:lastDate]) {
            lastDate = dateString;
            if (sectionItems.count) {
                [sections addObject:sectionItems];
            }
            sectionItems = [NSMutableArray new];
        }
        
        [sectionItems addObject:news];
    }
    if (sectionItems.count) {
        [sections addObject:sectionItems];
    }
    
    return sections;
}

@end
