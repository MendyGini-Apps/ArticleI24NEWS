//
//  Dated.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 12/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation

protocol Dated {
    var date: Date { get }
}

extension Array where Element: Dated
{
    func groupedBy(dateComponents: Set<Calendar.Component>, calendar: Calendar = Calendar.current) -> [Date: [Element]]
    {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = calendar.dateComponents(dateComponents, from: cur.date)
            let date = calendar.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        
        return groupedByDateComponents
    }
}
