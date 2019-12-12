//
//  ArticleComment.m
//  i24News
//
//  Created by Timur Bernikowich on 12/12/16.
//  Copyright © 2016 Webwag Mobile. All rights reserved.
//

#import "ArticleComment.h"

@implementation ArticleComment

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    ArticleComment *object = [super objectWithDictionary:dictionary];
    if (!object) {
        return nil;
    }
    
    NSTEasyJSON *JSON = [NSTEasyJSON withObject:dictionary];
    object.author = JSON[@"author"][@"username"].string ?: JSON[@"author"][@"nickname"].string;
    object.message = JSON[@"message"].string;
    
    object.createdAt = [NSDateFormatter dateFromArticleDateString:JSON[@"createdAt"].string];
    
    return object;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@: %@", [super description], self.author, self.message];
}

@end
