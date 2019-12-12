//
//  LeakAvoider.swift
//  ArticlesI24OBJC
//
//  Created by Mendy Barouk on 12/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation

class LeakAvoider : NSObject, WKScriptMessageHandler
{
    weak var delegate : WKScriptMessageHandler?
    init(delegate:WKScriptMessageHandler)
    {
        self.delegate = delegate
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
    {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}
