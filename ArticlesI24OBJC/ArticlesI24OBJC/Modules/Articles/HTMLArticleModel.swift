//
//  HTMLArticleModel.swift
//  ArticlesI24OBJC
//
//  Created by Menahem Barouk on 12/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation

class HTMLArticleModel: Article
{
    let htmlFormated: String
    let images      : [ArticleImage]
    
    init(article: Article, htmlFormated: String, images: [ArticleImage])
    {
        self.htmlFormated = htmlFormated
        self.images = images
        super.init()
        self.objectID              = article.objectID
        self.title                 = article.title
        self.shortTitle            = article.shortTitle
        self.excerpt               = article.excerpt
        self.bodyHTML              = article.bodyHTML
        self.shortPlainBody        = article.shortPlainBody
        self.authorName            = article.authorName
        self.authorImageURL        = article.authorImageURL
        self.category              = article.category
        self.createdAt             = article.createdAt
        self.publishedAt           = article.publishedAt
        self.updatedAt             = article.updatedAt
        self.numberOfComments      = article.numberOfComments
        self.image                 = article.image
        self.video                 = article.video
        self.type                  = article.type
        self.liveNews              = article.liveNews
        self.favorite              = article.favorite
        self.href                  = article.href
        self.frontendURL           = article.frontendURL
        self.externalVideoId       = article.externalVideoId
        self.externalVideoProvider = article.externalVideoProvider
    }
    
    required init(from decoder: Decoder) throws
    {
        fatalError("init(from:) has not been implemented")
    }
}

extension ArticleImage
{
    convenience init(imageURL: URL, credit: String, legend: String)
    {
        self.init()
        self.imageURL = imageURL
        self.credit = credit
        self.legend = legend
    }
}


extension Article
{
    public static func == (lhs: Article, rhs: Article) -> Bool
    {
        return lhs.objectID == rhs.objectID
    }
    
    convenience init(objectID             : NSNumber,
                     title                : String,
                     shortTitle           : String,
                     excerpt              : String,
                     bodyHTML             : String,
                     shortPlainBody       : String,
                     authorName           : String,
                     authorImageURL       : URL?,
                     category             : String,
                     createdAt            : Date?,
                     publishedAt          : Date?,
                     updatedAt            : Date?,
                     numberOfComments     : UInt,
                     image                : ArticleImage,
                     video                : Video?,
                     type                 : ArticleType,
                     liveNews             : [News]?,
                     favorite             : Bool,
                     href                 : URL,
                     frontendURL          : URL,
                     externalVideoId      : String?,
                     externalVideoProvider: String?)
    {
        self.init()
        self.objectID              = objectID
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
        self.frontendURL           = frontendURL
        self.externalVideoId       = externalVideoId
        self.externalVideoProvider = externalVideoProvider
    }
}

extension News: Comparable, Dated
{
    public static func < (lhs: News, rhs: News) -> Bool
    {
        return lhs.startedAt < rhs.startedAt
    }
    
    var date: Date
    {
        return startedAt
    }
}
