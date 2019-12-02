//
//  Section.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 01/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation

final class OrderedSection<Header, Item, Footer>: SectionProtocol
{
    var headerMetadata: Header?
    
    var itemsMetadata: [Item]
    
    var footerMetadata: Footer?
    
    convenience init(itemsMetadata: Item..., headerMetadata: Header? = nil, footerMetadata: Footer? = nil)
    {
        self.init(itemsMetadata: itemsMetadata, headerMetadata: headerMetadata, footerMetadata: footerMetadata)
    }
    
    init(itemsMetadata: [Item], headerMetadata: Header? = nil, footerMetadata: Footer? = nil)
    {
        self.itemsMetadata = itemsMetadata
        self.headerMetadata = headerMetadata
        self.footerMetadata = footerMetadata
    }
}
