//
//  ArticleUtility.swift
//  ArticleI24NEWS
//
//  Created by Mendy Barouk on 04/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation

class ArticleUtility
{
    static let templateArticleURL = Bundle.main.url(forResource: "articleTemplate", withExtension: "html")!
    static let templateArticleString = try! String(contentsOf: templateArticleURL)
    
    static let templateNewsURL = Bundle.main.url(forResource: "NewsTemplate", withExtension: "html")!
    static let templateNewsString = try! String(contentsOf: templateNewsURL)
    
    static let newsSectionDayTemplateURL = Bundle.main.url(forResource: "NewsSectionDayTemplate", withExtension: "html")!
    static let newsSectionDayTemplateString = try! String(contentsOf: newsSectionDayTemplateURL)
}
