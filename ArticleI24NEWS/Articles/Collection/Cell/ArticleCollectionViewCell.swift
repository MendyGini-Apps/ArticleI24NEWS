//
//  ArticleCollectionViewCell.swift
//  ArticleI24NEWS
//
//  Created by Mendy Barouk on 02/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit
import WebKit

class ArticleCollectionViewCell: UICollectionViewCell
{
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView       : UIScrollView!
    @IBOutlet weak var headerImageView  : UIImageView!
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var categoryLabel    : UILabel!
    @IBOutlet weak var loadBarView      : LoadBarView!
    @IBOutlet weak var writtenByLabel   : UILabel!
    @IBOutlet weak var authorNameLabel  : UILabel!
    @IBOutlet weak var dateLabel        : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var containerWebView : UIView!
    @IBOutlet weak var commentsButton   : UIButton!
    @IBOutlet weak var addCommentButton : UIButton!
    @IBOutlet weak var heightParallaxViewConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    lazy var webView: WKWebView = {
        //Javascript string
        let source = "window.onload=function () {window.webkit.messageHandlers.sizeNotification.postMessage({height: document.body.scrollHeight});};"
        let source2 = "document.body.addEventListener( 'resize', incrementCounter); function incrementCounter() {window.webkit.messageHandlers.sizeNotification.postMessage({height: document.body.scrollHeight});};"

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
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    var heightWebViewConstraint: NSLayoutConstraint!
    
    private var observations = Set<NSKeyValueObservation>()
    
    // MARK: - overrides
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        decideDirection()
        configureText()
        
        addWebView()
        observeWebViewEstimatedProgress()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        adjusteParallaxViewHeight()
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        if webView.isLoading
        {
            scrollView.contentOffset.y = 0
            webView.stopLoading()
        }
        webView.loadHTMLString("", baseURL: nil)
        adjustWebViewHeight()
        
        headerImageView.image = #imageLiteral(resourceName: "logo_article")
        adjusteParallaxViewHeight()
    }
}

extension ArticleCollectionViewCell
{
    private func configureText()
    {
        // TODO: - Localization "Written by"
        writtenByLabel.text = "Written by"
        commentsButton.setTitle("Comments", for: .normal)
        addCommentButton.setTitle("Add a comment", for: .normal)
    }
    
    private func addWebView()
    {
        containerWebView.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: containerWebView.leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: containerWebView.topAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: containerWebView.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: containerWebView.bottomAnchor).isActive = true
        heightWebViewConstraint = webView.heightAnchor.constraint(equalToConstant: 1.0)
        heightWebViewConstraint.isActive = true
    }
    
    private func observeWebViewEstimatedProgress()
    {
        observations.insert(webView.observe(\.estimatedProgress, options: [.new]) { [weak self] (webView, changed) in
            
            guard let strongSelf = self else { return }
            guard let newValue = changed.newValue else { return }
            strongSelf.loadBarView.progress = CGFloat(newValue)
        })
    }
    
    func adjustWebViewHeight(_ height: CGFloat = 1.0)
    {
        webView.constraints.first(where: { $0.firstAttribute == .height })?.constant = height
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func adjusteParallaxViewHeight()
    {
        var adjustedInset = UIEdgeInsets.zero
        adjustedInset.top = insetLayoutSafeArea.top
        heightParallaxViewConstraint.constant = headerImageView.image!.getHeightKeepingRatioByWidth(headerImageView.frame.width, adjustedInset: adjustedInset)
    }
}

extension ArticleCollectionViewCell: WKScriptMessageHandler
{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
    {
        guard let responseDict = message.body as? [String:Any],
            let height = responseDict["height"] as? Float else {return}
        
        if heightWebViewConstraint.constant != CGFloat(height)
        {
            print("height: - ", height)
            heightWebViewConstraint.constant = CGFloat(height)
        }
    }
}
