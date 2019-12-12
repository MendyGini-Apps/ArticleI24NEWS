//
//  HTMLArticleExtratorOperation.swift
//  ArticleI24NEWS
//
//  Created by Mendy Barouk on 04/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation
import SwiftSoup
import ProcedureKit

class HTMLArticleExtratorOperation: Procedure, InputProcedure, OutputProcedure
{
    private static var articleStyleString: String = {
        let articleStyleURL = Bundle.main.url(forResource: "articleStyles", withExtension: "css")!
        let articleStyleString = try! String(contentsOf: articleStyleURL)
        
        return articleStyleString
    }()
    
    private static var templateArticleLTRString: String = {
        let templateArticleURL = Bundle.main.url(forResource: "articleTemplate", withExtension: "html")!
        let templateArticleString = try! String(contentsOf: templateArticleURL)
        
        return String(format: templateArticleString, "ltr", articleStyleString)
    }()
    
    private static var templateArticleRTLString: String = {
        let templateArticleURL = Bundle.main.url(forResource: "articleTemplate", withExtension: "html")!
        let templateArticleString = try! String(contentsOf: templateArticleURL)
        
        return String(format: templateArticleString, "rtl", articleStyleString)
    }()
    
    private static var templateNewsString: String = {
        let templateNewsURL = Bundle.main.url(forResource: "NewsTemplate", withExtension: "html")!
        
        return try! String(contentsOf: templateNewsURL)
    }()
    
    private static var newsSectionDayTemplateString: String = {
        let newsSectionDayTemplateURL = Bundle.main.url(forResource: "NewsSectionDayTemplate", withExtension: "html")!
        
        return try! String(contentsOf: newsSectionDayTemplateURL)
    }()
    
    typealias Input = Article
    typealias Output = HTMLArticleModel
    
    var input: Pending<Article> {
        get { stateLock.withCriticalScope { _input } }
        set {
            stateLock.withCriticalScope {
                _input = newValue
            }
        }
    }
    var output: Pending<ProcedureResult<HTMLArticleModel>> {
        get { stateLock.withCriticalScope { _output } }
        set {
            stateLock.withCriticalScope {
                _output = newValue
            }
        }
    }
    
    private var _input: Pending<Article> = .pending
    private var _output: Pending<ProcedureResult<HTMLArticleModel>> = .pending
    
    private let stateLock = NSLock()
    
    init(article: Article)
    {
        super.init()
        self.input = .ready(article)
    }
    
    override func execute()
    {
        guard let article = input.value else {
            finish(withResult: .failure(ProcedureKitError.requirementNotSatisfied()))
            return
        }
        guard !isCancelled else {
            finish()
            return
        }
        
        do
        {
            let templateArticle = VersionManager.sharedInstance()?.isArabic ?? false ? HTMLArticleExtratorOperation.templateArticleRTLString : HTMLArticleExtratorOperation.templateArticleLTRString
            let doc = try SwiftSoup.parse(templateArticle)
            
            try doc.body()?.select("#contentBody").prepend(article.bodyHTML)
            
            if let liveNews = article.liveNews?.sorted(by: >)
            {
                let contentLive = try doc.select("#contentLive")
                let liveNewsByDaySections = liveNews.groupedBy(dateComponents: [.day])
                
                for daySection in liveNewsByDaySections.keys.sorted(by: >)
                {
                    
                    let daySectionHTMLStrings = liveNewsByDaySections[daySection]!.map {
                        
                        let time = DateFormatter.i24TimeForeNewsFormatter.string(from: $0.date)
                        
                        let newsHTMLString = String(format: HTMLArticleExtratorOperation.templateNewsString,
                                                    time,
                                                    $0.titleHTML)
                        
                        return newsHTMLString
                    }.joined(separator: "\n")
                    
                    let dayAsString = DateFormatter.i24DateForeNewsFormatter.string(from: daySection)
                    let sectionDayHTMLString = String(format: HTMLArticleExtratorOperation.newsSectionDayTemplateString, dayAsString, daySectionHTMLStrings)
                    try contentLive.append(sectionDayHTMLString)
                }
            }
            
            let html = try doc.html()
            
            let imgElements = try doc.select("img")
            
            let articleImages = try imgElements.array().compactMap({ (img) -> ArticleImage? in
                guard let imageURL = URL(string: try img.attr("src")) else { return nil }
                return ArticleImage(imageURL: imageURL, credit: "", legend: try img.attr("title"))
            })
            
            let htmlArticleModel = HTMLArticleModel(article: article,
                                                    htmlFormated: html,
                                                    images: [article.image] + articleImages)
            finish(withResult: .success(htmlArticleModel))
        }
        catch let error
        {
            finish(withResult: .failure(error))
        }
    }
}
