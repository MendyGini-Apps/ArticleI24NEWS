//
//  News.h
//  i24News
//
//  Created by Timur Bernikowich on 1/6/17.
//  Copyright © 2017 Webwag Mobile. All rights reserved.
//

#import "MasterObject.h"

@class Article;

typedef NS_ENUM(NSUInteger, NewsStatus) {
    NewsStatusUnknown,
    NewsStatusBreaking
};

@interface News : MasterObject

@property (nonatomic) NSNumber *objectID;
@property (nonatomic) NSString *titleHTML;
@property (nonatomic) NSAttributedString *attributedTitle;
@property (nonatomic) NSString *section;
@property (nonatomic) NSString *bodyHTML;
@property (nonatomic) NSAttributedString *attributedBody;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSDate *startedAt;
@property (nonatomic) NSURL *href;
@property (nonatomic) NewsStatus status;

@property (nonatomic) Article *relatedArticle;

@end

@interface News (Sorting)

+ (NSArray<NSArray<News *> *> *)newsSortedByDateWithNews:(NSArray<News *> *)allNews;

@end
