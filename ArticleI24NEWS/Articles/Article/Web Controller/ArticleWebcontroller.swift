//
//  ArticleWebcontroller.swift
//  ArticleI24NEWS
//
//  Created by Mendy Barouk on 08/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation
import WebKit

protocol WebControllerProtocol: WKNavigationDelegate
{
    func configuration() -> WKWebViewConfiguration
}

protocol WebControllerDelegate: NSObjectProtocol
{
    func webController(_ webController: WebControllerProtocol, heightOfBody height: CGFloat)
}

class ArticleWebController: NSObject
{
    weak var delegate: WebControllerDelegate!
    
    init(delegate: WebControllerDelegate)
    {
        self.delegate = delegate
    }
}

extension ArticleWebController: WebControllerProtocol
{
    func configuration() -> WKWebViewConfiguration
    {
        //Javascript string
        let source = "window.addEventListener('load', function(event) {window.webkit.messageHandlers.sizeNotification.postMessage({height:document.getElementById('contentBody').scrollHeight});});"
        let source2 = "document.getElementById('contentBody').addEventListener('resize', function(event){window.webkit.messageHandlers.sizeNotification.postMessage({height: document.getElementById('contentBody').scrollHeight});});"
        
        
        //UserScript object
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        let script2 = WKUserScript(source: source2, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        //Content Controller object
        let controller = WKUserContentController()

        //Add script to controller
        controller.addUserScript(script)
        controller.addUserScript(script2)

        //Add message handler reference
        controller.add(self, name: "sizeNotification")

        //Create configuration
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = controller
        
        return configuration
    }
}

extension ArticleWebController: WKNavigationDelegate
{
    
}

extension ArticleWebController: WKScriptMessageHandler
{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
    {
        guard let responseDict = message.body as? [String:Any],
            let height = responseDict["height"] as? CGFloat else { return }
        
        DispatchQueue.main.async {
            self.delegate.webController(self, heightOfBody: height + 30.0)
        }
    }
}
