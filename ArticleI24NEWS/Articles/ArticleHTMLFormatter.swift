//
//  ArticleHTMLFormatter.swift
//  ArticleI24NEWS
//
//  Created by Mendy Barouk on 04/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation

class VersionManager
{
    static let shared = VersionManager()
    var isArabic = true
    var locale = Locale.current
}

struct HTMLArticleModel
{
    
}

class ArticleHTMLFormatter
{
    static let articleStyleURL = Bundle.main.url(forResource: "articleStyles", withExtension: "css")!
    static let articleStyleString: String = {
        let articleStyleString = try! String(contentsOf: articleStyleURL)
        
        let direction = VersionManager.shared.isArabic ? "rtl" : "ltr"
        return String(format: articleStyleString, direction)
    }()
    
    static let templateArticleURL = Bundle.main.url(forResource: "articleTemplate", withExtension: "html")!
    static let templateArticleString: String = {
        let templateArticleString = try! String(contentsOf: templateArticleURL)
        
        return String(format: templateArticleString, articleStyleString)
    }()
    
    static let templateNewsURL = Bundle.main.url(forResource: "NewsTemplate", withExtension: "html")!
    static let templateNewsString = try! String(contentsOf: templateNewsURL)
    
    static let newsSectionDayTemplateURL = Bundle.main.url(forResource: "NewsSectionDayTemplate", withExtension: "html")!
    static let newsSectionDayTemplateString = try! String(contentsOf: newsSectionDayTemplateURL)
    
    func extractHTMLArticle(from metadata: Article) -> HTMLArticleModel?
    {
        return nil
    }
}
