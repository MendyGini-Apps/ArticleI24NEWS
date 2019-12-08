//
//  ArticleHTMLFormatter.swift
//  ArticleI24NEWS
//
//  Created by Mendy Barouk on 04/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation
import SwiftSoup

class VersionManager
{
    static let shared = VersionManager()
    var isArabic = true
    var locale = Locale.current
    {
        didSet
        {
            DateFormatter.i24TimeForeNewsFormatter.locale = locale
            DateFormatter.i24DateForeNewsFormatter.locale = locale
        }
    }
}

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
struct HTMLArticleModel: Equatable
{
    let base            : Article
    let formatted       : String
    let imageMetadata   : [ArticleImage]
    
    static func == (lhs: Self, rhs: Self) -> Bool
    {
        return lhs.base.identifier == rhs.base.identifier
    }
}
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

class ArticleHTMLFormatter
{
    private lazy var articleStyleString: String = {
        let articleStyleURL = Bundle.main.url(forResource: "articleStyles", withExtension: "css")!
        let articleStyleString = try! String(contentsOf: articleStyleURL)
        
        let direction = VersionManager.shared.isArabic ? "rtl" : "ltr"
        return String(format: articleStyleString, direction)
    }()
    
    private lazy var templateArticleString: String = {
        let templateArticleURL = Bundle.main.url(forResource: "articleTemplate", withExtension: "html")!
        let templateArticleString = try! String(contentsOf: templateArticleURL)
        
        return String(format: templateArticleString, articleStyleString)
    }()
    
    private lazy var templateNewsString: String = {
        let templateNewsURL = Bundle.main.url(forResource: "NewsTemplate", withExtension: "html")!
        
        return try! String(contentsOf: templateNewsURL)
    }()
    
    private lazy var newsSectionDayTemplateString: String = {
        let newsSectionDayTemplateURL = Bundle.main.url(forResource: "NewsSectionDayTemplate", withExtension: "html")!
        
        return try! String(contentsOf: newsSectionDayTemplateURL)
    }()
    
    func extractHTMLArticle(from metadata: Article) throws -> HTMLArticleModel
    {
        let doc = try SwiftSoup.parse(templateArticleString)
        try doc.body()?.select("#contentBody").prepend(metadata.bodyHTML)
        
        if let liveNews = metadata.liveNews?.sorted(by: >)
        {
            let contentLive = try doc.select("#contentLive")
            let liveNewsByDaySections = liveNews.groupedBy(dateComponents: [.day])
            
            for daySection in liveNewsByDaySections.keys.sorted(by: >)
            {
                
                let daySectionHTMLStrings = liveNewsByDaySections[daySection]!.map {
                    
                    let time = DateFormatter.i24TimeForeNewsFormatter.string(from: $0.date)
                    
                    let newsHTMLString = String(format: templateNewsString, time, $0.contentHTML)
                    
                    return newsHTMLString
                }.joined(separator: "\n")
                
                let dayAsString = DateFormatter.i24DateForeNewsFormatter.string(from: daySection)
                let sectionDayHTMLString = String(format: newsSectionDayTemplateString, dayAsString, daySectionHTMLStrings)
                try contentLive.append(sectionDayHTMLString)
            }
        }
        
        let html = try doc.html()
        
        return HTMLArticleModel(base: metadata,
                                formatted: html,
                                imageMetadata: [])
    }
}
