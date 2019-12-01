//
//  SectionProtocol.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 01/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation

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
