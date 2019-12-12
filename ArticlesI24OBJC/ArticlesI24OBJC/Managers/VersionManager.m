//
//  VersionManager.m
//  i24News
//
//  Created by Timur Bernikowich on 12/6/16.
//  Copyright © 2016 Webwag Mobile. All rights reserved.
//

#import "VersionManager.h"

NSString * const VersionManagerLanguageUpdateNotification = @"VersionManagerLanguageUpdateNotification";
static NSString * const VersionManagerLanguageKey = @"VersionManagerLanguageKey";

@interface VersionManager ()

@property (nonatomic, readwrite) NSMutableDictionary *languageDependentStorage;

@end

@implementation VersionManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t p = 0;
    static id sharedInstance;
    dispatch_once(&p, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (NSMutableDictionary *)languageDependentStorage
{
    if (!_languageDependentStorage) {
        _languageDependentStorage = [NSMutableDictionary new];
    }
    return _languageDependentStorage;
}

- (void)resetStorage
{
    self.languageDependentStorage = nil;
}

#pragma mark - Language

- (void)updateLanguage:(VersionManagerLanguage)language
{
    if (language == VersionManagerLanguageUnknown) {
        language = [self defaultLanguage];
    }
    
    self.language = language;
    [self resetStorage];
    [[NSNotificationCenter defaultCenter] postNotificationName:VersionManagerLanguageUpdateNotification object:nil];
}

- (NSArray *)availibleLanguages
{
    return @[@(VersionManagerLanguageEn), @(VersionManagerLanguageFr), @(VersionManagerLanguageAr)];
}

- (NSString *)translationForLanguage:(VersionManagerLanguage)language
{
    switch (language) {
        case VersionManagerLanguageEn: return L10N(@"language_english");
        case VersionManagerLanguageFr: return L10N(@"language_french");
        case VersionManagerLanguageAr: return L10N(@"language_arabic");
        case VersionManagerLanguageUnknown: return nil;
    }
}

- (VersionManagerLanguage)language
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *forcedLanguage = [defaults stringForKey:VersionManagerLanguageKey];
    
    VersionManagerLanguage language = VersionManagerLanguageUnknown;
    NSArray *avaibleLanguages = [self availibleLanguages];
    for (NSNumber *languageNumber in avaibleLanguages) {
        VersionManagerLanguage languageToCheck = languageNumber.unsignedIntegerValue;
        NSString *languageCode = [self codeForLanguage:languageToCheck];
        if (languageCode.length && [forcedLanguage isEqualToString:languageCode]) {
            language = languageToCheck;
            break;
        }
    }
    
    if (language == VersionManagerLanguageUnknown) {
        language = [self defaultLanguage];
        self.language = language;
    }
    
    return language;
}

- (void)setLanguage:(VersionManagerLanguage)language
{
    NSString *languageCode = [self codeForLanguage:language];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:languageCode forKey:VersionManagerLanguageKey];
    [userDefaults synchronize];
}

- (VersionManagerLanguage)defaultLanguage
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *systemLanguages = [userDefaults arrayForKey:@"AppleLanguages"];
    NSArray *avaibleLanguages = [self availibleLanguages];
    
    for (NSString *systemLanguage in systemLanguages) {
        for (NSNumber *languageNumber in avaibleLanguages) {
            VersionManagerLanguage language = languageNumber.unsignedIntegerValue;
            NSString *languageCode = [self shortCodeForLanguage:language];
            if ([systemLanguage hasPrefix:languageCode]) {
                return language;
            }
        }
    }
    
    return ((NSNumber *)avaibleLanguages.firstObject).unsignedIntegerValue ;
}

- (NSString *)codeForLanguage:(VersionManagerLanguage)language
{
    switch (language) {
        case VersionManagerLanguageEn: return @"en";
        case VersionManagerLanguageFr: return @"fr";
        case VersionManagerLanguageAr: return @"ar";
        case VersionManagerLanguageUnknown: return nil;
    }
}

- (NSString *)shortCodeForLanguage:(VersionManagerLanguage)langauge
{
    return [[self codeForLanguage:langauge] substringToIndex:2];
}

- (NSLocale *)localeForLanguage:(VersionManagerLanguage)language
{
    NSString *code;
    switch (language) {
        case VersionManagerLanguageEn: {
            code = @"en_UK";
            break;
        }
        case VersionManagerLanguageFr: {
            code = @"fr_FR";
            break;
        }
        case VersionManagerLanguageAr: {
            code = @"ar_SA";
            break;
        }
        default: {
            break;
        }
    }
    
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:code];
    return locale;
}

- (NSBundle *)languageBundle
{
    NSString *bundle = [self codeForLanguage:self.language];
    if (bundle.length) {
        return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bundle ofType:@"lproj"]];
    } else {
        return [NSBundle mainBundle];
    }
}

- (NSLocale *)languageLocale
{
    return [self localeForLanguage:self.language];
}

- (BOOL)isArabic
{
    return (self.language == VersionManagerLanguageAr);
}

- (BOOL)isArabicDevice
{
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    return [currentLanguage hasPrefix:@"ar"];
}

#pragma mark - Locale

- (NSString *)serviceLocale
{
    return [self shortCodeForLanguage:self.language];
}

#pragma mark - Terms

- (NSURL *)storeURL
{
    return [NSURL URLWithString:@"https://itunes.apple.com/app/i24news/id671837118"];
}

- (NSURL *)termsURL
{
    NSString *URLString;
    switch (self.language) {
        case VersionManagerLanguageAr: {
            URLString = @"https://www.i24news.tv/ar/%EF%BA%88%EF%BA%A8%EF%BB%83%EF%BA%8D%EF%BA%AD%EF%BA%8E%EF%BA%97-%EF%BB%95%EF%BA%8E%EF%BB%A7%EF%BB%AE%EF%BB%A8%EF%BB%B3%EF%BA%93";
            break;
        }
        case VersionManagerLanguageFr: {
            URLString = @"http://www.i24news.tv/fr/mentions-legales";
            break;
        }
        case VersionManagerLanguageEn:
        default: {
            URLString = @"http://www.i24news.tv/en/legals-mentions";
            break;
        }
    }

    return [NSURL URLWithString:URLString];
}

- (NSURL *)privacyPolicyURL
{
    NSString *URLString;
    switch (self.language) {
        case VersionManagerLanguageAr: {
            URLString = @"https://www.i24news.tv/ar/%D8%B3%D9%8A%D8%A7%D8%B3%D8%A9-%D8%AE%D8%A7%D8%B5%D8%A9";
            break;
        }
        case VersionManagerLanguageFr: {
            URLString = @"https://www.i24news.tv/fr/politique-de-confidentialite";
            break;
        }
        case VersionManagerLanguageEn:
        default: {
            URLString = @"https://www.i24news.tv/en/privacy-policy";
            break;
        }
    }

    return [NSURL URLWithString:URLString];
}

- (NSURL *)registerURL
{
    NSString *URLString = [NSString stringWithFormat:@"http://www.i24news.tv/%@/register/", self.serviceLocale];
    return [NSURL URLWithString:URLString];
}

- (NSString *)localeCode
{
    return [self shortCodeForLanguage:[self language]];
}

@end
