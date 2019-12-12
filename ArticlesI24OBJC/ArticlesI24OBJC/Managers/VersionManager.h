//
//  VersionManager.h
//  i24News
//
//  Created by Timur Bernikowich on 12/6/16.
//  Copyright © 2016 Webwag Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VersionManagerLanguage) {
    VersionManagerLanguageUnknown,
    VersionManagerLanguageEn,
    VersionManagerLanguageFr,
    VersionManagerLanguageAr
};

extern NSString * const VersionManagerLanguageUpdateNotification;

@interface VersionManager : NSObject

+ (instancetype)sharedInstance;

// Can be used to store date formatters. Use it on main thread only.
@property (nonatomic, readonly) NSMutableDictionary *languageDependentStorage;

// Language.
- (void)updateLanguage:(VersionManagerLanguage)language;
- (NSArray *)availibleLanguages;
- (NSString *)translationForLanguage:(VersionManagerLanguage)language;
- (NSString *)codeForLanguage:(VersionManagerLanguage)language;
- (NSString *)localeCode;
- (NSString *)shortCodeForLanguage:(VersionManagerLanguage)langauge;
- (NSLocale *)localeForLanguage:(VersionManagerLanguage)language;
@property (nonatomic, readonly) VersionManagerLanguage language;
@property (nonatomic, readonly) BOOL isArabic;
@property (nonatomic, readonly) BOOL isArabicDevice;
@property (nonatomic, readonly) NSBundle *languageBundle;
@property (nonatomic, readonly) NSLocale *languageLocale;

// Locale
@property (nonatomic, readonly) NSString *serviceLocale;

// URLs
@property (nonatomic, readonly) NSURL *storeURL;
@property (nonatomic, readonly) NSURL *termsURL;
@property (nonatomic, readonly) NSURL *registerURL;
@property (nonatomic, readonly) NSURL *privacyPolicyURL;

@end
