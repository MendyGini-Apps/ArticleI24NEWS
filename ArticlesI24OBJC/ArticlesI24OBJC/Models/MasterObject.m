//
//  MasterObject.m
//  i24News
//
//  Created by Timur Bernikowich on 11/25/16.
//  Copyright © 2016 Webwag Mobile. All rights reserved.
//

#import "MasterObject.h"

@implementation MasterObject

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [self new];
}

+ (NSArray *)objectsWithDictionaries:(NSArray<NSDictionary *> *)dictionaries {
    if (![dictionaries isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *objects = [NSMutableArray new];
    for (NSDictionary *dictionary in dictionaries) {
        MasterObject *object = [self objectWithDictionary:dictionary];
        if (object) {
            [objects addObject:object];
        }
    }
    
    return objects;
}

#pragma mark - Helpers

+ (NSString *)plainTextWithHTMLString:(NSString *)HTMLString limit:(NSUInteger)limit
{
    if (!HTMLString.length) {
        return nil;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:HTMLString];
    NSMutableString *result = [NSMutableString new];;
    while (!scanner.isAtEnd && (limit == 0 || scanner.scanLocation < limit)) {
        NSString *plainPart;
        [scanner scanUpToString:@"<" intoString:&plainPart];
        [scanner scanUpToString:@">" intoString:NULL];
        [scanner scanString:@">" intoString:NULL];
        if (plainPart) {
            if (plainPart.length && result.length) {
                [result appendString:@" "];
            }
            [result appendString:plainPart];
        }
    }
    
    if (limit != 0 && result.length > limit) {
        return [result substringWithRange:NSMakeRange(0, limit)];
    }
    
    return result;
}

+ (NSAttributedString *)attributedStringWithHTMLString:(NSString *)HTMLString
{
    if (!HTMLString) {
        return nil;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        // iOS 8 does not support HTML decoding in background thread.
        NSString *cleanString = [self plainTextWithHTMLString:HTMLString limit:0];
        if (!cleanString) {
            return nil;
        }
        
        return [[NSAttributedString alloc] initWithString:cleanString attributes:nil];
    }
    
    NSStringEncoding encoding = NSUnicodeStringEncoding;
    NSData *data = [HTMLString dataUsingEncoding:encoding];
    if (!data.length) {
        return nil;
    }
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute:@(encoding)};
    NSAttributedString *string = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:NULL error:NULL];
    return string;
}

@end
