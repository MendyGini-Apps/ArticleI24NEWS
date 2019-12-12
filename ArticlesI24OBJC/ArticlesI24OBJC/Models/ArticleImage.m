//
//  ArticleImage.m
//  i24News
//
//  Created by Timur Bernikowich on 1/24/17.
//  Copyright © 2017 Webwag Mobile. All rights reserved.
//

#import "ArticleImage.h"

@implementation ArticleImage

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    ArticleImage *object = [super objectWithDictionary:dictionary];
    if (!object) {
        return nil;
    }
    
    NSTEasyJSON *JSON = [NSTEasyJSON withObject:dictionary];
    object.imageURL = JSON[@"href"].URL;
    object.credit = JSON[@"credit"].string;
    object.legend = JSON[@"legend"].string;
    
    return object;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@, %@, %@", [super description], self.credit, self.legend, self.imageURL];
}

@end
