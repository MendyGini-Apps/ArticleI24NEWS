//
//  SectionProtocol.swift
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

protocol SectionProtocol
{
    associatedtype Header
    associatedtype Item
    associatedtype Footer
    
    var headerMetadata: Header? { get }
    var itemsMetadata : [Item] { get }
    var footerMetadata: Footer? { get }
}

protocol DataSourceProtocol
{
    associatedtype Section: SectionProtocol
    
    var dataSource: [Section] { get set }
    
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    
    func header(at section: Int) -> Section.Header?
    func item(at indexPath: IndexPath) -> Section.Item
    func footer(at section: Int) -> Section.Footer?
}

extension DataSourceProtocol
{
    func numberOfSections() -> Int
    {
        return dataSource.count
    }
    func numberOfItems(in section: Int) -> Int
    {
        return dataSource[section].itemsMetadata.count
    }
    
    func header(at section: Int) -> Section.Header?
    {
        return dataSource[section].headerMetadata
    }
    func item(at indexPath: IndexPath) -> Section.Item
    {
        return dataSource[indexPath.section].itemsMetadata[indexPath.item]
    }
    func footer(at section: Int) -> Section.Footer?
    {
        return dataSource[section].footerMetadata
    }
}
