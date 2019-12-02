//
//  Article.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 01/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation

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
    let liveNews: [News]?
    let favorite: Bool
    let href: URL
    let frontedURL: URL
    let externalVideoId: String?
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
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        self.identifier = try container.decode(Int.self, forKey: .identifier)
        self.title = try container.decode(String.self, forKey: .title)
        self.shortTitle = try container.decode(String.self, forKey: .shortTitle)
        self.excerpt = try container.decode(String.self, forKey: .excerpt)
        self.bodyHTML = try container.decode(String.self, forKey: .bodyHTML)
        
        let createdAtAsString = try container.decode(String.self, forKey: .createdAt)
        self.createdAt = DateFormatter.i24APIFormatter.date(from: createdAtAsString)
        
        let publishedAtAsString = try container.decode(String.self, forKey: .publishedAt)
        self.publishedAt = DateFormatter.i24APIFormatter.date(from: publishedAtAsString)
        
        let updatedAtAsString = try container.decode(String.self, forKey: .updatedAt)
        self.updatedAt = DateFormatter.i24APIFormatter.date(from: updatedAtAsString)
        
        self.numberOfComments = try container.decode(UInt.self, forKey: .numberOfComments)
        let image = try container.decode(ArticleImage.self, forKey: .image)
        self.images = [image]
        self.type = try container.decode(String.self, forKey: .type)
        self.liveNews = nil
        self.favorite = try container.decode(Bool.self, forKey: .favorite)
        self.href = try container.decode(URL.self, forKey: .href)
        self.frontedURL = try container.decode(URL.self, forKey: .frontedURL)
        self.externalVideoId = try container.decode(String?.self, forKey: .externalVideoId)
        self.externalVideoProvider = try container.decode(String?.self, forKey: .externalVideoProvider)
        
        let signature = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .signature)
        
        self.authorName = try signature.decode(String.self, forKey: .title)
        
        let category = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .category)
        
        self.category = try category.decode(String.self, forKey: .name)
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

struct News: Codable
{
    
}

enum ArticleType: String, Codable {
    case unknown
    case timeline
    case video
    case brightCove
}

