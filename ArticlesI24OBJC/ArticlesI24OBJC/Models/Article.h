//
//  Article.h
//  i24News
//
//  Created by Timur Bernikowich on 11/25/16.
//  Copyright © 2016 Webwag Mobile. All rights reserved.
//

#import "MasterObject.h"

typedef NS_ENUM(NSUInteger, ArticleType) {
    ArticleTypeUnknown,
    ArticleTypeTimeline,
    ArticleTypeVideo,
    ArticleTypeVideoBrightCove
};

@class Video;
@class ArticleComment;
@class ArticleImage;
@class News;

@interface Article : MasterObject

@property (nonatomic, nonnull) NSNumber *objectID;
@property (nonatomic, nonnull) NSString *title;
@property (nonatomic, nonnull) NSString *shortTitle;
@property (nonatomic, nonnull) NSString *excerpt;
@property (nonatomic, nonnull) NSString *bodyHTML;
@property (nonatomic, nonnull) NSString *shortPlainBody;
@property (nonatomic, nonnull) NSString *authorName;
@property (nonatomic, nullable) NSURL *authorImageURL;
@property (nonatomic, nonnull) NSString *category;
@property (nonatomic, nullable) NSDate *createdAt;
@property (nonatomic, nullable) NSDate *publishedAt;
@property (nonatomic, nullable) NSDate *updatedAt;
@property (nonatomic) NSUInteger numberOfComments;
@property (nonatomic, nonnull) ArticleImage *image;
@property (nonatomic, nullable) Video *video;
@property (nonatomic) ArticleType type;
@property (nonatomic, nullable) NSArray<News *> *liveNews;
@property (nonatomic) BOOL favorite;
@property (nonatomic, nonnull) NSURL *href;
@property (nonatomic, nonnull) NSURL *frontendURL;
@property (nonatomic, nullable) NSString * externalVideoId;
@property (nonatomic, nullable) NSString * externalVideoProvider;

+ (ArticleType)typeWithString:(NSString *)string;

@end
