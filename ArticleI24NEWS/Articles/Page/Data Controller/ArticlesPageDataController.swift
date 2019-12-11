//
//  ArticlesPageDataController.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 01/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation

protocol ArticlesPageDataControllerProtocol: PageDataSourceProtocol
{
    func fetchData()
}

protocol ArticlesPageDataControllerDelegate: NSObjectProtocol
{
    func dataController(_ dataController: ArticlesPageDataController, taskStateDidChange state: Bool)
    func dataController(_ dataController: ArticlesPageDataController, currentItemDidChanged item: ArticlesPageDataController.Item)
}

class ArticlesPageDataController
{
    private weak var delegate: ArticlesPageDataControllerDelegate!
    private let articleHTMLFormatter: ArticleHTMLFormatter
    private(set) var dataSource: [Item]
    private var currentIndex: Int
    {
        didSet
        {
            guard (0..<dataSource.count) ~= currentIndex else { return }
            delegate.dataController(self, currentItemDidChanged: dataSource[currentIndex])
        }
    }
    
    init(articles: [Article], at index: Int, delegate: ArticlesPageDataControllerDelegate)
    {
        self.delegate = delegate
        self.currentIndex = index
        let articleHTMLFormatter = ArticleHTMLFormatter()
        self.articleHTMLFormatter = articleHTMLFormatter
        let HTMLArticlesModels = articles.compactMap { try? articleHTMLFormatter.extractHTMLArticle(from: $0) }
        self.dataSource = HTMLArticlesModels
    }
}

extension ArticlesPageDataController: ArticlesPageDataControllerProtocol
{
    func fetchData()
    {
        self.delegate.dataController(self, taskStateDidChange: true)
    }
}

extension ArticlesPageDataController: PageDataSourceProtocol
{
    typealias Item = HTMLArticleModel
    
    var currentItem: HTMLArticleModel?
    {
        get
        {
            guard (0..<dataSource.count) ~= currentIndex else { return nil }
            return dataSource[currentIndex]
        }
        set
        {
            guard let newValue = newValue else { return }
            guard let currentIndex = dataSource.firstIndex(of: newValue) else { return }
            self.currentIndex = currentIndex
        }
    }
}
