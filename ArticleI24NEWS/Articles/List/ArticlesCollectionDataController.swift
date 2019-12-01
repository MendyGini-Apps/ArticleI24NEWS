//
//  ArticlesCollectionDataController.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 01/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation
import ProcedureKit

class ArticlesCollectionDataController
{
    let queue: ProcedureQueue
    
    init()
    {
        self.queue = ProcedureQueue()
    }
    
    func fetchData()
    {
        guard let url = Bundle.main.url(forResource: "articlesEN", withExtension: "json") else { return }
        
        let bringNetworkOperation = BringJSONDataNetworkOperation(urlRequest: URLRequest(url: url), outputType: [Article].self)
        
        bringNetworkOperation.addDidFinishBlockObserver(synchronizedWith: DispatchQueue.main) { (networkOpration, error) in
            
            print(networkOpration.output)
            
        }
        
        queue.addOperation(bringNetworkOperation)
    }
}
