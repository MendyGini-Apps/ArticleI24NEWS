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
    
    init(delegate: ArticlesCollectionDataControllerDelegate)
    {
        self.delegate = delegate
        self.queue = ProcedureQueue()
        self.dataSource = []
    }
}

extension ArticlesCollectionDataController: ArticlesCollectionDataControllerProtocol
{
    func fetchData()
    {
        let resource = VersionManager.shared.isArabic ? "articlesAR" : "articlesEN"
        guard let path = Bundle.main.path(forResource: resource, ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        
        let bringLocaleFileOperation = BringJSONDataLocaleFileOperation(url: url, outputType: [Article].self)
        
        bringLocaleFileOperation.addDidFinishBlockObserver(synchronizedWith: DispatchQueue.main) { [weak self] (networkOpration, error) in
            guard let strongSelf = self else { return }
            
            guard let articles = networkOpration.output.value?.value else { return }
            strongSelf.dataSource = [Section(itemsMetadata: articles)]
            strongSelf.delegate.dataController(strongSelf, taskStateDidChange: true)
        }
        
        queue.addOperation(bringLocaleFileOperation)
    }
}

extension ArticlesCollectionDataController: DataSourceProtocol
{
    typealias Section = OrderedSection<Any,Article,Any>
}
