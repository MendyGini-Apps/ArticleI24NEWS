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
    func dataController(_ dataController: ArticlesPageDataController, currentItemDidChanged: ArticlesPageDataController.Item)
}

class ArticlesPageDataController
{
    private weak var delegate: ArticlesPageDataControllerDelegate!
    private let articleHTMLFormatter: ArticleHTMLFormatter
    private(set) var dataSource: [Item]
    private var _currentItem: Item?
    {
        didSet
        {
            guard let currentItem = _currentItem else { return }
            delegate.dataController(self, currentItemDidChanged: currentItem)
        }
    }
    
    init(articles: [Article], delegate: ArticlesPageDataControllerDelegate)
    {
        self.delegate = delegate
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
        _currentItem = dataSource.first
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
            return _currentItem
        }
        set
        {
            guard let newValue = newValue else { return }
            guard dataSource.contains(newValue) else { return }
            _currentItem = newValue
        }
    }
}
