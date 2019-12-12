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
    func webController(_ webController: WebControllerProtocol, articleImageLinkActivatedAtIndex index: Int)
    func webController(_ webController: WebControllerProtocol, articleLinkActivatedWithSlug slug: String)
    func webController(_ webController: WebControllerProtocol, linkActivated url: URL)
}

class ArticleWebController: NSObject
{
    private static var jsSource: String
    {
        let articleJS = Bundle.main.url(forResource: "Article", withExtension: "js")!
        let source = try! String(contentsOf: articleJS)
        return source
    }
    private weak var delegate: WebControllerDelegate?
    private weak var dataController: ArticleDataController?
    
    init(dataController: ArticleDataController, delegate: WebControllerDelegate)
    {
        self.dataController = dataController
        self.delegate = delegate
    }
}

extension ArticleWebController
{
    func handleNavigation(with url: URL)
    {
        if let imageIndex = dataController?.indexOfArticleImage(from: url)
        {
            delegate?.webController(self, articleImageLinkActivatedAtIndex: imageIndex)
        }
        else if let slug = dataController?.slugFromArticleLink(url)
        {
            delegate?.webController(self, articleLinkActivatedWithSlug: slug)
        }
        else
        {
            delegate?.webController(self, linkActivated: url)
        }
    }
}

extension ArticleWebController: WebControllerProtocol
{
    func configuration() -> WKWebViewConfiguration
    {
        //UserScript object
        let script = WKUserScript(source: ArticleWebController.jsSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        //Content Controller object
        let controller = WKUserContentController()

        //Add script to controller
        controller.addUserScript(script)

        //Add message handler reference
        controller.add(LeakAvoider(delegate: self), name: "sizeNotification")

        //Create configuration
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = controller
        
        return configuration
    }
}

extension ArticleWebController: WKNavigationDelegate
{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        guard navigationAction.navigationType == .linkActivated else { decisionHandler(.allow); return }
        guard let url = navigationAction.request.url else { decisionHandler(.allow); return }
        decisionHandler(.cancel)
        handleNavigation(with: url)
    }
}

extension ArticleWebController: WKScriptMessageHandler
{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
    {
        guard let responseDict = message.body as? [String:Any],
            let height = responseDict["height"] as? CGFloat else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.webController(strongSelf, heightOfBody: height)
        }
    }
}
