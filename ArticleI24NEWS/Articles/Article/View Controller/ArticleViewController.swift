//
//  ArticleViewController.swift
//  ArticleI24NEWS
//
//  Created by Mendy Barouk on 08/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit
import WebKit
import SDWebImage

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
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    @IBOutlet weak var addCommentButton : UIButton!
    @IBOutlet weak var heightParallaxViewConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var webController: WebControllerProtocol!
    weak var webView: WKWebView!
    weak var heightWebViewConstraint: NSLayoutConstraint!
    
    private var observations = Set<NSKeyValueObservation>()
    
    var dataController: ArticleDataController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        addWebView()
        view.decideDirection()
        configureView()
    }
    
    deinit {
        observations.forEach { $0.invalidate() }
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
        let webView = WKWebView(frame: CGRect.zero, configuration: webController.configuration())
        self.webView = webView
        webView.scrollView.isScrollEnabled = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = webController
        containerWebView.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: containerWebView.leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: containerWebView.topAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: containerWebView.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: containerWebView.bottomAnchor).isActive = true
        heightWebViewConstraint = webView.heightAnchor.constraint(equalToConstant: 0.0)
        heightWebViewConstraint.isActive = true
        
        observeWebViewEstimatedProgress(webView: webView)
        
        guard webView.estimatedProgress == 0.0 else { return }
        let htmlArticleModel = dataController.htmlArticle
        webView.loadHTMLString(htmlArticleModel.formatted, baseURL: nil)
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
        let numberOfComments = htmlArticleModel.base.numberOfComments
        numberOfCommentsLabel.text = numberOfComments > 0 ? "(\(numberOfComments))" : ""
        
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
    
    private func observeWebViewEstimatedProgress(webView: WKWebView)
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
        webController = ArticleWebController(delegate: self)
    }
}

extension ArticleViewController: WebControllerDelegate
{
    func webController(_ webController: WebControllerProtocol, heightOfBody height: CGFloat)
    {
        let inset = CGFloat(30.0)
        let heightWithInset = height + inset
        guard heightWebViewConstraint.constant != heightWithInset else { return }
        
        self.heightWebViewConstraint.constant = heightWithInset
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
}
