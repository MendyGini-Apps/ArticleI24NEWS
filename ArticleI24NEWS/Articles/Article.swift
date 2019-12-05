//
//  Article.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 01/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation
import SwiftSoup

struct Article: Decodable
{
    let identifier: Int
    let title: String
    let shortTitle: String
    let excerpt: String
    let bodyHTML: String
    let authorName: String
    let category: String
    let createdAt: Date?
    let publishedAt: Date?
    let updatedAt: Date?
    let numberOfComments: UInt
    let images: [ArticleImage]
    let type: String
    let liveNews: [ArticleNews]?
    let favorite: Bool
    let href: URL
    let frontedURL: URL
    let externalVideoId: String?
    let externalVideoProvider: String?
    let HTMLString: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title = "title"
        case shortTitle = "shortTitle"
        case excerpt = "excerpt"
        case bodyHTML = "body"
        case category = "category"
        case createdAt = "createdAt"
        case publishedAt = "publishedAt"
        case updatedAt = "updatedAt"
        case numberOfComments = "numberOfComments"
        case image = "image"
        case type = "type"
        case liveNews = "events"
        case favorite = "favorite"
        case href = "href"
        case frontedURL = "frontendUrl"
        case externalVideoId = "externalVideoId"
        case externalVideoProvider = "externalVideoProvider"
        case signature = "signature"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        self.identifier = try container.decode(Int.self, forKey: .identifier)
        self.title = try container.decode(String.self, forKey: .title)
        self.shortTitle = try container.decode(String.self, forKey: .shortTitle)
        self.excerpt = try container.decode(String.self, forKey: .excerpt)
        
        
        let createdAtAsString = try container.decode(String.self, forKey: .createdAt)
        self.createdAt = DateFormatter.i24APIArticleFormatter.date(from: createdAtAsString)
        
        let publishedAtAsString = try container.decode(String.self, forKey: .publishedAt)
        self.publishedAt = DateFormatter.i24APIArticleFormatter.date(from: publishedAtAsString)
        
        let updatedAtAsString = try container.decode(String.self, forKey: .updatedAt)
        self.updatedAt = DateFormatter.i24APIArticleFormatter.date(from: updatedAtAsString)
        
        self.numberOfComments = try container.decode(UInt.self, forKey: .numberOfComments)
        let image = try container.decode(ArticleImage.self, forKey: .image)
        self.images = [image]
        self.type = try container.decode(String.self, forKey: .type)
        
        self.favorite = try container.decode(Bool.self, forKey: .favorite)
        self.href = try container.decode(URL.self, forKey: .href)
        self.frontedURL = try container.decode(URL.self, forKey: .frontedURL)
        self.externalVideoId = try container.decode(String?.self, forKey: .externalVideoId)
        self.externalVideoProvider = try container.decode(String?.self, forKey: .externalVideoProvider)
        
        let signature = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .signature)
        
        self.authorName = try signature.decode(String.self, forKey: .title)
        
        let category = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .category)
        
        self.category = try category.decode(String.self, forKey: .name)
        
        let bodyHTML = try container.decode(String.self, forKey: .bodyHTML)
        self.bodyHTML = bodyHTML
        
        let doc = try SwiftSoup.parse(ArticleHTMLFormatter.templateArticleString)
        try doc.body()?.prepend(bodyHTML)
        
        let liveNews = try container.decode([ArticleNews]?.self, forKey: .liveNews)
        self.liveNews = liveNews?.sorted(by: >)
        
        if let liveNews = liveNews
        {
            let contentLive = try doc.select(".contentLive")
            let liveNewsByDaySections = liveNews.groupedBy(dateComponents: [.day])
            
            for daySection in liveNewsByDaySections.keys.sorted(by: >)
            {
                let daySectionHTMLStrings = liveNewsByDaySections[daySection]!.map { $0.HTMLString }.joined(separator: "\n")
                let dayAsString = DateFormatter.i24DateForeNewsFormatter.string(from: daySection)
                let sectionDayHTMLString = String(format: ArticleHTMLFormatter.newsSectionDayTemplateString, dayAsString, daySectionHTMLStrings)
                try contentLive.append(sectionDayHTMLString)
            }
        }
        
        let html = try doc.html()
        self.HTMLString = html
    }
}

struct ArticleImage: Codable
{
    let imageURL: URL
    let credit: String
    let legent: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "href"
        case credit = "credit"
        case legent = "legend"
    }
}

struct ArticleNews: Codable, Comparable, Dated
{
    static func < (lhs: ArticleNews, rhs: ArticleNews) -> Bool
    {
        return lhs.date < rhs.date
    }
    
    let identifier: Int
    let date: Date
    let contentHTML: String
    let HTMLString: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case date = "date"
        case contentHTML = "content"
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let idAsString = try container.decode(String.self, forKey: .identifier)
        self.identifier = Int(idAsString) ?? -1
        self.contentHTML = try container.decode(String.self, forKey: .contentHTML)
        
        let dateAsString = try container.decode(String.self, forKey: .date)
        let date = DateFormatter.i24APINewsFormatter.date(from: dateAsString)
        self.date = date ?? Date()
        
        let time: String
        if let date = date
        {
            time = DateFormatter.i24TimeForeNewsFormatter.string(from: date)
        }
        else
        {
            time = ""
        }
        self.HTMLString = String(format: ArticleHTMLFormatter.templateNewsString, time, contentHTML)
    }
}

enum ArticleType: String, Codable {
    case unknown
    case timeline
    case video
    case brightCove
}

protocol Dated {
    var date: Date { get }
}

extension Array where Element: Dated
{
    func groupedBy(dateComponents: Set<Calendar.Component>, calendar: Calendar = Calendar.current) -> [Date: [Element]]
    {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = calendar.dateComponents(dateComponents, from: cur.date)
            let date = calendar.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        
        return groupedByDateComponents
    }
}
