//
//  ArticleImage.h
//  i24News
//
//  Created by Timur Bernikowich on 1/24/17.
//  Copyright © 2017 Webwag Mobile. All rights reserved.
//

#import "MasterObject.h"

@interface ArticleImage : MasterObject

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *credit;
@property (nonatomic) NSString *legend;

@end
