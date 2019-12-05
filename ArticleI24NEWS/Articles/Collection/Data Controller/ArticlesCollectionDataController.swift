//
//  ArticlesCollectionDataController.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 01/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation
import ProcedureKit

protocol ArticlesCollectionDataControllerProtocol: DataSourceProtocol
{
    func fetchData()
}

protocol ArticlesCollectionDataControllerDelegate: NSObjectProtocol
{
    func dataController(_ dataController: ArticlesCollectionDataController, taskStateDidChange state: Bool)
}

class ArticlesCollectionDataController
{
    private weak var delegate: ArticlesCollectionDataControllerDelegate!
    private let queue: ProcedureQueue
    var dataSource: [Section]
    
    init(articles: [Article], delegate: ArticlesCollectionDataControllerDelegate)
    {
        self.delegate = delegate
        self.queue = ProcedureQueue()
        self.dataSource = [Section(itemsMetadata: articles)]
    }
}

extension ArticlesCollectionDataController: ArticlesCollectionDataControllerProtocol
{
    func fetchData()
    {
        self.delegate.dataController(self, taskStateDidChange: true)
    }
}

extension ArticlesCollectionDataController: DataSourceProtocol
{
    typealias Section = OrderedSection<Any,Article,Any>
}
