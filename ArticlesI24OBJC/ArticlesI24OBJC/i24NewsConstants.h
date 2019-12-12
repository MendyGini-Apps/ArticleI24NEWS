//
//  i24NewsConstants.h
//  i24News
//
//  Created by Guillaume on 25/10/2016.
//  Copyright © 2016 Webwag Mobile. All rights reserved.
//

#ifndef i24NewsConstants_h
#define i24NewsConstants_h

#if DEBUG
#define PREPROD YES
#endif

#pragma mark - URLs

// TODO: - Not forget to test all environments
#ifdef PREPROD
#define BASE_URL @"https://api.preprod-knp.i24news.org/"
#else
#define BASE_URL @"https://api.i24news.tv/"
#endif

#define WEB_HOST_ARTICLE @"www.i24news.tv"

#ifdef PREPROD
#define BASE_URL_CLEEN_G @"https://cleeng.com"
#else
#define BASE_URL_CLEEN_G @"https://cleeng.com"
#endif

#ifdef PREPROD
#define BASE_URL_CLEEN_G_JACK @"https://jackdaw.cleeng.com"
#else
#define BASE_URL_CLEEN_G_JACK @"https://jackdaw.cleeng.com"
#endif


#define DefaultAccount @"webwag@webwag.com"

#ifdef PREPROD
#define DEFAULT_PASSWORD @"password"
#else
#define DEFAULT_PASSWORD @"webwag33"
#endif

#define RSA_KEY @"RSA_KEY"
#define NotifificationLogin @"updateViewAfterLogin"
#define NotificationRegistrationSceneDismiss @"NotificationRegistrationSceneDismiss"
#define NotificationSubscription @"NotificationSubscription"
#define NotificationCurrentFonSizeDidChange @"NotificationCurrentFonSizeDidChange"

#define AccesslevelFree @"Free"
#define AccesslevelPremium @"Premium"

#ifdef PREPROD
#define CleanGOfferid @"S920352949_XX"
#else
#define CleanGOfferid @"S920352949_XX"
#endif

#pragma mark - Taboola PublisherId
#define TaboolaPublisherIDEN @"alticemediapublicitenetwork-i24newsen-iosapp"
#define TaboolaPublisherIDFR @"alticemediapublicitenetwork-i24newsfr-iosapp"
#define TaboolaPublisherIDAR @"alticemediapublicitenetwork-i24newsar-iosapp"
#define TaboolaPlacementName @"App Below Article Thumbnails iOS"
#define TaboolaModeName      @"organic-thumbs-feed-01"


// Fix IphoneX
#define IphoneX ([UIScreen mainScreen].bounds.size.height == 812)


// Localizations.
#define L10N(str) NSLocalizedStringFromTableInBundle(str, nil, [VersionManager sharedInstance].languageBundle, nil)

// UI helpers.
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define PIXEL 1.0 / ([UIScreen mainScreen].scale)

// Right-to-Left support.
#define NSTextAlignmentNaturalApplication (([UIView defaultDirection] == MASLayoutDirectionRightToLeft) ? NSTextAlignmentRight : NSTextAlignmentLeft)
#define NSTextAlignmentUnnaturalApplication (([UIView defaultDirection] == MASLayoutDirectionRightToLeft) ? NSTextAlignmentLeft : NSTextAlignmentRight)

// Remove following.

#define kStatusBarHeight                        20
#define kNavigationBarHeight                    64
#define kOfflineMode                            @"Hors Ligne"


#pragma mark - ANIMATIONS, OPACITY, LAYERS
#define kMinValue                               0.0f
#define k10PercentValue                         0.1f
#define k20PercentValue                         0.2f
#define k30PercentValue                         0.3f
#define k40PercentValue                         0.4f
#define k50PercentValue                         0.5f
#define k60PercentValue                         0.6f
#define k70PercentValue                         0.7f
#define k80PercentValue                         0.8f
#define k90PercentValue                         0.9f
#define kMaxValue                               1.0f

#define kDefaultValue                           0.35f
#define kFastValue                              0.25f

#pragma mark - COLORS
#define kNavigationBarDefaultColor				@"#001C3E"
#define kMenuBackgroundDefaultColor				@"#1F366A"
#define kLightWhiteDefaultColor					@"#F5F5F5"

#pragma mark - CELLS
#define kMenuCellFontSize						20.0 // 19pt

#pragma mark - FONTS
#define kRobotoBoldFont							@"Roboto-Bold"
#define kRobotoBoldItalicFont					@"Roboto-BoldItalic"
#define kRobotoItalicFont						@"Roboto-Italic"
#define kRobotoRegularFont						@"Roboto-Regular"

#pragma mark - FILES

#define kMenuSettingsFile                       @"MenuSettings"
#define kPlistExtension                         @"plist"

#pragma mark - IDENTIFIERS
#define kSettingsMenuCellIdentifier				@"SettingsViewCell"

#define kStandardNewsListStoryboardId			@"StandardListViewControllerId"
#define kFilterNewsListStoryboardId				@"FilterListViewControllerId"

#pragma mark - IMAGES

#define kMenuBtnImage							@"btn_menu"
#define kSettingsBtnImage						@"btn_settings"
#define kBackBtnImage							@"btn_back"
#define kFontBtnImage							@"btn_font"
#define kCloseBtnImage							@"btn_close"
#define kLogoImage								@"i24_logo"

#define kLanguageMenuItemImage					@"picto_languages"
#define kTextResizingMenuItemImage				@"picto_resizing"
#define kNotificationsMenuItemImage				@"picto_notif"
#define kNewsletterMenuItemImage				@"picto_newsletter"
#define kContactMenuItemImage					@"picto_contact"
#define kRateAppMenuItemImage					@"picto_rate"
#define kTermsOfServicesMenuItemImage			@"picto_terms"
#define kVersionMenuItemImage					@"picto_version"

#pragma mark - VIEWS (RATIO, PERCENTAGE)
#define kMenuWidthPercentage					0.75

#pragma mark - SEGUES
#define kLeftMenuSegue							@"leftMenuSegue"
#define kRightMenuSegue							@"rightMenuSegue"
#define kNewsListSegue							@"newsListSegue"

#define EMAIL_REGEX                             @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define PASSWORD_REGEX                          @"(?=.*?\\d)(?=.*?[A-Za-z])[A-Za-z0-9-$@$!%*?&#]{8,}"

#define JAVA_SCRIPT_CHANGE_ARTICLE_FONT_SIZE(sizeValue) [NSString stringWithFormat:@"document.getElementsByTagName(\"body\")[0].style.fontSize = \"%ld\" + \"px\";document.getElementsByClassName(\"title\")[0].style.fontSize = \"%ld\" + \"px\";document.getElementsByClassName(\"author\")[0].style.fontSize = \"%ld\" + \"px\";document.getElementsByClassName(\"date\")[0].style.fontSize = \"%ld\" + \"px\";document.getElementsByClassName(\"description\")[0].style.fontSize = \"%ld\" + \"px\";",sizeValue,sizeValue + 11,sizeValue - 2,sizeValue - 2,sizeValue]

#define JAVASCRIPT_LINK_DISABLE(elementId) [NSString stringWithFormat:@"var element = document.getElementById('%@'); element.style.pointerEvents = 'none'; element.style.opacity = 0.5;", elementId]

#define JAVASCRIPT_LINK_ENABLE(elementId)  [NSString stringWithFormat:@"var element = document.getElementById('%@'); element.style.pointerEvents = 'auto'; element.style.opacity = 1.0;", elementId]

#endif /* i24NewsConstants_h */
