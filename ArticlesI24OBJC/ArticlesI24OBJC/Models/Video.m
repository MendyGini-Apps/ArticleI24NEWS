//
//  Video.m
//  i24News
//
//  Created by Timur Bernikowich on 12/15/16.
//  Copyright © 2016 Webwag Mobile. All rights reserved.
//

#import "Video.h"

@implementation CustomFields

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    CustomFields *object = [super objectWithDictionary:dictionary];
    if (!object) {
        return nil;
    }

    NSTEasyJSON *JSON = [NSTEasyJSON withObject:dictionary];
    object.videotype = JSON[@"videotype"].string;
    object.videosubscription = JSON[@"videosubscription"].string;
    object.videolocale = JSON[@"videolocale"].string;
    object.accesslevel = JSON[@"accesslevel"].string;
    return object;
}


@end

@implementation Video

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    Video *object = [super objectWithDictionary:dictionary];
    if (!object) {
        return nil;
    }

    /* Delete live ans isBrightCove */
//    object.isBrightCove = false;
    object.VideoType = Normal;
    
    NSTEasyJSON *JSON = [NSTEasyJSON withObject:dictionary];
    object.objectID = @(JSON[@"id"].integerValue);
    object.titleHTML = JSON[@"title"].string;
    object.attributedTitle = [self attributedStringWithHTMLString:object.titleHTML];
    
    object.bodyHTML = JSON[@"description"].string;
    object.attributedBody = [self attributedStringWithHTMLString:object.bodyHTML];
    object.imageURL = JSON[@"thumbnails"][@"url_360"].URL;
    
    object.createdAt = [NSDateFormatter dateFromArticleDateString:JSON[@"createdAt"].string];
    object.embeddedURL = JSON[@"embedUrl"].URL;
    object.frontendURL = JSON[@"frontendUrl"].URL;
    object.videoHash = JSON[@"hash"].string;
    
    
    if (object.titleHTML != nil){
        NSString *cleanString = [self plainTextWithHTMLString:object.titleHTML limit:0];
        object.titleSharing = cleanString;
    }
    else {
        object.titleSharing = @"";
    }
    
     return object;
}

+ (NSArray *)objectsWithDictionariesBrightCove:(NSDictionary*)dictionaries {
    NSTEasyJSON *JSON = [NSTEasyJSON withObject:dictionaries];
    
    NSArray* array = JSON[@"videos"].array;
    
    NSMutableArray *objects = [NSMutableArray new];
    for (NSDictionary *dictionary in array) {
        MasterObject *object = [self objectWithDictionaryBrightCove:dictionary];
        if (object) {
            [objects addObject:object];
        }
    }
    
    return objects;
}

+ (instancetype)objectWithDictionaryBrightCove:(NSDictionary *)dictionary {
    Video *object = [super objectWithDictionary:dictionary];
    if (!object) {
        return nil;
    }
    
        /* Delete live ans isBrightCove */
//    object.isBrightCove = true;
    object.VideoType = BrightCove;
    
    NSTEasyJSON *JSON = [NSTEasyJSON withObject:dictionary];    
	
    object.titleHTML = JSON[@"name"].string;
    object.attributedTitle = [self attributedStringWithHTMLString:object.titleHTML];
    
    object.bodyHTML = JSON[@"long_description"].string;
    object.attributedBody = [self attributedStringWithHTMLString:object.bodyHTML];
    object.imageURL = JSON[@"poster"].URL;//poster //thumbnail
    object.createdAt = [NSDateFormatter dateFromArticleDateString:JSON[@"published_at"].string];
    object.customFields = [CustomFields objectWithDictionary:JSON[@"custom_fields"].dictionary];
    object.idBrightCove = JSON[@"id"].string;
    //    object.frontendURL = JSON[@"frontendUrl"].URL;

    if (object.titleHTML != nil){
        NSString *cleanString = [self plainTextWithHTMLString:object.titleHTML limit:0];
        object.titleSharing = cleanString;
    }
    else {
        object.titleSharing = @"";
    }
    
    return object;
}



@end
