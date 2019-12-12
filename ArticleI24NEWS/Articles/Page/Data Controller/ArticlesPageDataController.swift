//
//  ArticlesPageDataController.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 01/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation
import ProcedureKit

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
    private      let queue       : ProcedureQueue
    private weak var delegate    : ArticlesPageDataControllerDelegate!
    private(set) var dataSource  : [Item]
    private      var currentIndex: Int
    {
        didSet
        {
            guard (0..<dataSource.count) ~= currentIndex else { return }
            delegate.dataController(self, currentItemDidChanged: dataSource[currentIndex])
        }
    }
    
    init(articles: [Item], at index: Int, delegate: ArticlesPageDataControllerDelegate)
    {
        self.dataSource   = articles
        self.currentIndex = index
        self.delegate     = delegate
        self.queue        = ProcedureQueue()
    }
}

extension ArticlesPageDataController: ArticlesPageDataControllerProtocol
{
    func fetchData()
    {
        delegate.dataController(self, taskStateDidChange: true)
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            let htmlArticlesExtractors = strongSelf.dataSource.map { HTMLArticleExtratorOperation(article: $0) }
            
            htmlArticlesExtractors.forEach { (htmlArticlesExtractor) in
                
                htmlArticlesExtractor.addDidFinishBlockObserver { [weak self] (operation, error) in
                    
                    guard let strongSelf = self else { return }
                    
                    guard let htmlArticle = operation.output.value?.value,
                        let index = strongSelf.dataSource.firstIndex(of: htmlArticle) else { return }
                    
                    strongSelf.dataSource[index] = htmlArticle
                    
                    if index == strongSelf.currentIndex
                    {
                        DispatchQueue.main.async {
                            strongSelf.delegate.dataController(strongSelf, taskStateDidChange: true)
                        }
                    }
                }
            }
            
            strongSelf.queue.addOperations(htmlArticlesExtractors)
        }
    }
}

extension ArticlesPageDataController: PageDataSourceProtocol
{
    typealias Item = Article
    
    var currentItem: Item?
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
