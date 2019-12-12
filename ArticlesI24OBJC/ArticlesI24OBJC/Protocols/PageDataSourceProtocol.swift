//
//  PageDataSourceProtocol.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 01/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation

protocol PageDataSourceProtocol
{
    associatedtype Item: Equatable
    var dataSource: [Item] { get }
    var currentItem: Item? { get set }
    func previousItem() -> Item?
    func nextItem() -> Item?
    func itemsCount() -> Int
    func itemIndex() -> Int
}

extension PageDataSourceProtocol
{
    func previousItem() -> Item?
    {
        let previousIndex = itemIndex() - 1
        guard (0..<dataSource.count) ~= previousIndex else { return nil }
        
        return dataSource[previousIndex]
    }
    func nextItem() -> Item?
    {
        let nextIndex = itemIndex() + 1
        guard (0..<dataSource.count) ~= nextIndex else { return nil }
        
        return dataSource[nextIndex]
    }
    func itemsCount() -> Int
    {
        return dataSource.count
    }
    func itemIndex() -> Int
    {
        guard let currentItem = currentItem else { return 0 }
        return dataSource.firstIndex(of: currentItem) ?? 0
    }
}
