//
//  Article.m
//  i24News
//
//  Created by Timur Bernikowich on 11/25/16.
//  Copyright © 2016 Webwag Mobile. All rights reserved.
//

#import "Article.h"

// Models
#import "ArticleComment.h"
#import "ArticleImage.h"
#import "Video.h"
#import "News.h"

@implementation Article

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    Article *object = [super objectWithDictionary:dictionary];
    if (!object) {
        return nil;
    }
    
    NSTEasyJSON *JSON = [NSTEasyJSON withObject:dictionary];
	
    object.objectID = @(JSON[@"id"].integerValue);
    object.title = JSON[@"title"].string;
    object.externalVideoId = JSON[@"externalVideoId"].string;
    object.externalVideoProvider = JSON[@"externalVideoProvider"].string;
    object.shortTitle = JSON[@"shortTitle"].string;
    object.excerpt = JSON[@"excerpt"].string;
    object.bodyHTML = JSON[@"body"].string;
    object.shortPlainBody = object.excerpt.length > 0 ? object.excerpt : [self plainTextWithHTMLString:object.bodyHTML limit:300];
    object.authorName = JSON[@"signature"][@"title"].string;
    object.authorImageURL = JSON[@"signature"][@"image"].URL;
    object.category = JSON[@"category"][@"name"].string;

    object.createdAt = [NSDateFormatter dateFromArticleDateString:JSON[@"createdAt"].string];
    object.updatedAt = [NSDateFormatter dateFromArticleDateString:JSON[@"updatedAt"].string];
	object.publishedAt = [NSDateFormatter dateFromArticleDateString:JSON[@"publishedAt"].string];
    
    object.numberOfComments = JSON[@"numberOfComments"].unsignedIntegerValue;
    object.image = [ArticleImage objectWithDictionary:JSON[@"image"].dictionary];
    object.type = [self typeWithString:JSON[@"type"].string external:object.externalVideoProvider];
    object.video = [Video objectWithDictionary:JSON[@"video"].dictionary];
    object.favorite = JSON[@"favorite"].boolValue;
    object.href = JSON[@"href"].URL;
    object.frontendURL = JSON[@"frontendUrl"].URL;
    
    if (object.type == ArticleTypeVideoBrightCove) {
        object.video = [Video new];
        /* Delete live ans isBrightCove */
//        object.video.isBrightCove = true;
        object.video.VideoType = BrightCoveDetail;
        object.video.idBrightCove = object.externalVideoId;

        
    }
    
    NSMutableArray<News *> *news = [NSMutableArray new];
    for (NSDictionary *newsDictioanry in JSON[@"events"].array) {
        NSTEasyJSON *newsJSON = [NSTEasyJSON withObject:newsDictioanry];
        News *newsObject = [News new];
        newsObject.objectID = @(newsJSON[@"id"].string.integerValue);
        newsObject.titleHTML = newsJSON[@"content"].string;
        newsObject.attributedTitle = [self attributedStringWithHTMLString:newsObject.titleHTML];
        newsObject.startedAt = [NSDateFormatter dateFromArticleDateString:newsJSON[@"date"].string];
        [news addObject:newsObject];
    }
	
    object.liveNews = news.count ? news : nil;
    
    return object;
}

- (NSString *)description
{
	//self.shortTitle ?: self.title
    return [NSString stringWithFormat:@"%@ %@, %@", [super description], self.objectID, ((self.shortTitle && self.shortTitle.length > 0) ? self.shortTitle : self.title)];
}

+ (ArticleType)typeWithString:(NSString *)string external:(NSString*)external
{
    if ([string isEqualToString:@"timeline"]) {
        return ArticleTypeTimeline;
    } else if ([string isEqualToString:@"video"]) {
        if (external != NULL && [external isEqualToString:@"brightcove"]) {
            return ArticleTypeVideoBrightCove;
        }
        return ArticleTypeVideo;
    }
    
    return ArticleTypeUnknown;
}

- (BOOL)isEqual:(id)other
{
    if ([other isKindOfClass:[Article class]])
    {
        return [self.objectID isEqual:((Article *)other).objectID];
    }
    else
    {
        return [super isEqual:other];
    }
}

@end
