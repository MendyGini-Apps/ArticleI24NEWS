//
//  ExtenstionDateFormatter.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 05/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation

extension DateFormatter
{
    static let applicationServerTimeZone = TimeZone(secondsFromGMT: 0)
    static let i24APIArticleFormatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.timeZone = DateFormatter.applicationServerTimeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return formatter
    }()
    
    static let i24APINewsFormatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.timeZone = DateFormatter.applicationServerTimeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }()
    
    static let i24DayForArticleFormatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy"
        
        return formatter
    }()
    
    static let i24TimeForArticleFormatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        
        return formatter
    }()
    
    static let i24DateForeNewsFormatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.locale = VersionManager.sharedInstance()?.languageLocale
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        formatter.doesRelativeDateFormatting = true
        
        return formatter
    }()
    
    static let i24TimeForeNewsFormatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.locale = VersionManager.sharedInstance().languageLocale
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        return formatter
    }()
}
