//
//  ArticleDataController.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 08/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation

protocol ArticleDataControllerProtocol
{
    func indexOfArticleImage(from url: URL) -> Int?
    func slugFromArticleLink(_ url: URL) -> String?
    var imagesURLs: [URL] { get }
}

class ArticleDataController
{
    let htmlArticle: HTMLArticleModel
    init(htmlArticle: HTMLArticleModel)
    {
        self.htmlArticle = htmlArticle
    }
}

// MARK: - Private helpers methods
extension ArticleDataController
{
    func extractLocaleCodeFromURL(_ url: URL) -> String?
    {
        let availableLocaleIdentifiers = Locale.availableIdentifiers
        let localePathComponent = url.pathComponents.first { availableLocaleIdentifiers.contains($0) }
        return localePathComponent
    }
}

// MARK: - ArticleDataControllerProtocol Implementation
extension ArticleDataController: ArticleDataControllerProtocol
{
    var imagesURLs: [URL]
    {
        return htmlArticle.articleImages.map { $0.imageURL }
    }
    
    func indexOfArticleImage(from url: URL) -> Int?
    {
        return htmlArticle.articleImages.firstIndex { $0.imageURL == url }
    }
    
    func slugFromArticleLink(_ url: URL) -> String?
    {
        // TODO: - take host from i24constant file
        guard url.host == "www.i24news.tv" else { return nil }
        guard extractLocaleCodeFromURL(url) == VersionManager.shared.localeCode else { return nil }
        return url.lastPathComponent
    }
}
