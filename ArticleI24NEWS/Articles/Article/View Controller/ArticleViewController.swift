//
//  ArticleViewController.swift
//  ArticleI24NEWS
//
//  Created by Mendy Barouk on 08/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController
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
    lazy var webView: WKWebView! = {
        //Javascript string
        let source = "window.onload=function () {window.webkit.messageHandlers.sizeNotification.postMessage({height: document.getElementById('contentBody').offsetHeight});};"
        let source2 = "document.body.addEventListener( 'resize', incrementCounter); function incrementCounter() {window.webkit.messageHandlers.sizeNotification.postMessage({height: document.getElementById('contentBody').offsetHeight});};"

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
    weak var heightWebViewConstraint: NSLayoutConstraint!
    
    private var observations = Set<NSKeyValueObservation>()
    
    var dataController: ArticleDataController!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        addWebView()
        view.decideDirection()
        configureView()
        observeWebViewEstimatedProgress()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        adjusteParallaxViewHeight()
    }
}

extension ArticleViewController
{
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
    
    private func configureView()
    {
        // TODO: - Localization "Written by"
        writtenByLabel.text = "Written by"
        commentsButton.setTitle("Comments", for: .normal)
        addCommentButton.setTitle("Add a comment", for: .normal)
        
        let htmlArticleModel = dataController.htmlArticle
        
        titleLabel.text = htmlArticleModel.base.title
        descriptionLabel.text = htmlArticleModel.base.excerpt
        authorNameLabel.text = htmlArticleModel.base.authorName
        
        categoryLabel.text = htmlArticleModel.base.category.uppercased(with: VersionManager.shared.locale)
        
        if var articleCreatedAtAsString = stringFor(date: htmlArticleModel.base.createdAt)
        {
            if htmlArticleModel.base.createdAt!.compare(htmlArticleModel.base.updatedAt!) == .orderedAscending, let articleUpdateAtAsString = stringFor(date: htmlArticleModel.base.updatedAt)
            {
                // TODO: - Localization "UPD"
                articleCreatedAtAsString += " | UPD \(articleUpdateAtAsString)"
            }
            dateLabel.text = articleCreatedAtAsString
        }
        
        webView.loadHTMLString(htmlArticleModel.formatted, baseURL: nil)
        
        guard let imageURL = htmlArticleModel.base.images.first?.imageURL else { return }
        headerImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "logo_article"))
    }
    
    private func stringFor(date: Date?) -> String?
    {
        guard let date = date else { return nil }
        
        let dateAsString = DateFormatter.i24DayForArticleFormatter.string(from: date)
        let timeAsString = DateFormatter.i24TimeForArticleFormatter.string(from: date)
        if Calendar.current.isDateInToday(date)
        {
            return timeAsString
        }
        else
        {
            // TODO: - Localization "at"
            return "\(dateAsString) at \(timeAsString)"
        }
    }
    
    private func observeWebViewEstimatedProgress()
    {
        observations.insert(webView.observe(\.estimatedProgress, options: [.new]) { [weak self] (webView, changed) in
            
            guard let strongSelf = self else { return }
            guard let newValue = changed.newValue else { return }
            strongSelf.loadBarView.progress = CGFloat(newValue)
        })
    }
    
    private func adjusteParallaxViewHeight()
    {
        var adjustedInset = UIEdgeInsets.zero
        adjustedInset.top = view.insetLayoutSafeArea.top
        heightParallaxViewConstraint.constant = headerImageView.image!.getHeightKeepingRatioByWidth(headerImageView.frame.width, adjustedInset: adjustedInset)
    }
}

extension ArticleViewController
{
    func bindData(htmlArticle: HTMLArticleModel)
    {
        dataController = ArticleDataController(htmlArticle: htmlArticle)
    }
}

extension ArticleViewController: WKScriptMessageHandler
{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
    {
        guard userContentController === webView.configuration.userContentController else { return }
        guard let responseDict = message.body as? [String:Any],
            let height = responseDict["height"] as? Float else {return}

        if heightWebViewConstraint.constant != CGFloat(height)
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                print(self.webView.scrollView.contentSize.height, height,self.heightWebViewConstraint.constant, self.webView.estimatedProgress)
                self.heightWebViewConstraint.constant = self.webView.scrollView.contentSize.height
            }
        }
    }
}
