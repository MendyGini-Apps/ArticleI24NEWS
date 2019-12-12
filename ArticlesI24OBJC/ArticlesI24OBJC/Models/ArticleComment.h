//
//  ArticleComment.h
//  i24News
//
//  Created by Timur Bernikowich on 12/12/16.
//  Copyright © 2016 Webwag Mobile. All rights reserved.
//

#import "MasterObject.h"

@interface ArticleComment : MasterObject

@property (nonatomic) NSString *author;
@property (nonatomic) NSString *message;
@property (nonatomic) NSDate *createdAt;

@end
