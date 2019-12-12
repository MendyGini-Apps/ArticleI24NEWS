//
//  Article.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 01/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation
import SwiftSoup

class Article: Decodable, Equatable, NSCopying
{
    static func == (lhs: Article, rhs: Article) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }
    
    let identifier           : Int
    let title                : String
    let shortTitle           : String
    let excerpt              : String
    let bodyHTML             : String
    let authorName           : String
    let category             : String
    let createdAt            : Date?
    let publishedAt          : Date?
    let updatedAt            : Date?
    let numberOfComments     : UInt
    let image                : ArticleImage
    let type                 : String
    let liveNews             : [ArticleNews]?
    let favorite             : Bool
    let href                 : URL
    let frontedURL           : URL
    let externalVideoId      : String?
    let externalVideoProvider: String?
    
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
    
    required init(from decoder: Decoder) throws
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
        self.image = try container.decode(ArticleImage.self, forKey: .image)
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
        
        self.bodyHTML = try container.decode(String.self, forKey: .bodyHTML)
        self.liveNews = try container.decode([ArticleNews]?.self, forKey: .liveNews)
    }
    
    init(identifier           : Int,
         title                : String,
         shortTitle           : String,
         excerpt              : String,
         bodyHTML             : String,
         authorName           : String,
         category             : String,
         createdAt            : Date?,
         publishedAt          : Date?,
         updatedAt            : Date?,
         numberOfComments     : UInt,
         image                : ArticleImage,
         type                 : String,
         liveNews             : [ArticleNews]?,
         favorite             : Bool,
         href                 : URL,
         frontedURL           : URL,
         externalVideoId      : String?,
         externalVideoProvider: String?)
    {
        self.identifier            = identifier
        self.title                 = title
        self.shortTitle            = shortTitle
        self.excerpt               = excerpt
        self.bodyHTML              = bodyHTML
        self.authorName            = authorName
        self.category              = category
        self.createdAt             = createdAt
        self.publishedAt           = publishedAt
        self.updatedAt             = updatedAt
        self.numberOfComments      = numberOfComments
        self.image                 = image
        self.type                  = type
        self.liveNews              = liveNews
        self.favorite              = favorite
        self.href                  = href
        self.frontedURL            = frontedURL
        self.externalVideoId       = externalVideoId
        self.externalVideoProvider = externalVideoProvider
    }
    
    func copy(with zone: NSZone? = nil) -> Any
    {
        return Article(identifier           : self.identifier,
                       title                : self.title,
                       shortTitle           : self.shortTitle,
                       excerpt              : self.excerpt,
                       bodyHTML             : self.bodyHTML,
                       authorName           : self.authorName,
                       category             : self.category,
                       createdAt            : self.createdAt,
                       publishedAt          : self.publishedAt,
                       updatedAt            : self.updatedAt,
                       numberOfComments     : self.numberOfComments,
                       image                : self.image,
                       type                 : self.type,
                       liveNews             : self.liveNews,
                       favorite             : self.favorite,
                       href                 : self.href,
                       frontedURL           : self.frontedURL,
                       externalVideoId      : self.externalVideoId,
                       externalVideoProvider: self.externalVideoProvider)
    }
}

struct ArticleImage: Codable
{
    let imageURL: URL
    let credit  : String
    let legent  : String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "href"
        case credit   = "credit"
        case legent   = "legend"
    }
    
    init(imageURL: URL, credit: String = String(), legend: String = String())
    {
        self.imageURL = imageURL
        self.credit   = credit
        self.legent   = legend
    }
}

struct ArticleNews: Codable, Comparable, Dated
{
    static func < (lhs: ArticleNews, rhs: ArticleNews) -> Bool
    {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }
    
    let identifier: Int
    let date: Date
    let contentHTML: String
    
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
    }
}

enum ArticleType: String, Codable {
    case unknown
    case timeline
    case video
    case brightCove
}
