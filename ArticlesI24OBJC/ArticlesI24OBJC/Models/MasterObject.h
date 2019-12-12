//
//  MasterObject.h
//  i24News
//
//  Created by Timur Bernikowich on 11/25/16.
//  Copyright © 2016 Webwag Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterObject : NSObject

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)objectsWithDictionaries:(NSArray<NSDictionary *> *)dictionaries;

// Helpers
+ (NSString *)plainTextWithHTMLString:(NSString *)HTMLString limit:(NSUInteger)limit;
+ (NSAttributedString *)attributedStringWithHTMLString:(NSString *)HTMLString;

@end
