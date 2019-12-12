//
//  Video.h
//  i24News
//
//  Created by Timur Bernikowich on 12/15/16.
//  Copyright © 2016 Webwag Mobile. All rights reserved.
//

#import "MasterObject.h"

typedef enum {
    BrightCoveLive,
    BrightCoveDetail,
    BrightCove,
    Normal
} VideoType;

@interface CustomFields : MasterObject

@property (nonatomic) NSString *videotype;
@property (nonatomic) NSString *videosubscription;
@property (nonatomic) NSString *videolocale;
@property (nonatomic) NSString *accesslevel;

@end

@interface Video : MasterObject

+ (instancetype)objectWithDictionaryBrightCove:(NSDictionary *)dictionary;
+ (NSArray *)objectsWithDictionariesBrightCove:(NSDictionary*)dictionaries;

//@property (nonatomic) BOOL live;
//@property (nonatomic) BOOL isBrightCove;
@property (nonatomic) VideoType VideoType;

@property (nonatomic) NSNumber *objectID;


@property (nonatomic) NSString *titleHTML;
@property (nonatomic) NSString *titleSharing;
@property (nonatomic) NSAttributedString *attributedTitle;
@property (nonatomic) NSString *bodyHTML;
@property (nonatomic) NSAttributedString *attributedBody;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) CustomFields *customFields;
@property (nonatomic) NSString *idBrightCove;


@property (nonatomic) NSURL *embeddedURL;
@property (nonatomic) NSURL *frontendURL;
@property (nonatomic) NSString *videoHash;


@end


