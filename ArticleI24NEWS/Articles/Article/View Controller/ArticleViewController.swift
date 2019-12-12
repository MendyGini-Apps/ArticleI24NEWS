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
import SafariServices

@objc
protocol FromArticleVCToArticlesPageVCProtocol
{
    @objc func updateNavigationBarBackground(withScrollView scrollView: UIScrollView, heightParallaxView: CGFloat, animated: Bool)
}

class ArticleViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView       : UIScrollView!
    @IBOutlet weak var headerImageView  : UIImageView!
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var categoryLabel    : UILabel!
    @IBOutlet weak var loadBarView      : LoadBarView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        shouldNotifyScrollDidScroll(scrollView, withAnimation: animated)
    }

    deinit {
        observations.forEach { $0.invalidate() }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        adjusteParallaxViewHeight()
    }
    
    @IBAction func articleImageDidTapped(_ sender: UITapGestureRecognizer)
    {
        presentPhotoBrowser(from: 0, animatedFrom: sender.view)
    }
}

extension ArticleViewController
{
    private func addWebView()
    {
        guard let htmlArticle = dataController.article as? HTMLArticleModel else { return }
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
        webView.loadHTMLString(htmlArticle.htmlFormated, baseURL: nil)
    }
    
    private func configureView()
    {
        scrollView.delegate = self
        // TODO: - Localization "Written by"
        writtenByLabel.text = "Written by"
        commentsButton.setTitle("Comments", for: .normal)
        addCommentButton.setTitle("Add a comment", for: .normal)
        
        let article = dataController.article
        
        titleLabel.text = article.title
        descriptionLabel.text = article.excerpt
        authorNameLabel.text = article.authorName
        let numberOfComments = article.numberOfComments
        numberOfCommentsLabel.text = numberOfComments > 0 ? "(\(numberOfComments))" : ""
        
        categoryLabel.text = article.category.uppercased(with: VersionManager.shared.locale)
        
        if var articleCreatedAtAsString = stringFor(date: article.createdAt)
        {
            if article.createdAt!.compare(article.updatedAt!) == .orderedAscending, let articleUpdateAtAsString = stringFor(date: article.updatedAt)
            {
                // TODO: - Localization "UPD"
                articleCreatedAtAsString += " | UPD \(articleUpdateAtAsString)"
            }
            dateLabel.text = articleCreatedAtAsString
        }
        
        headerImageView.sd_setImage(with: article.image.imageURL, placeholderImage: #imageLiteral(resourceName: "logo_article"))
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
            guard newValue == 1.0 else { return }
            strongSelf.activityIndicator.stopAnimating()
        })
        
        observations.insert(webView.observe(\.isLoading, options: [.new]) { [weak self] (webView, changed) in
            
            guard let strongSelf = self else { return }
            guard let isLoading = changed.newValue else { return }
            if isLoading
            {
                strongSelf.activityIndicator.startAnimating()
            }
            else
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.activityIndicator.stopAnimating()
                }
            }
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
    func bindData(article: Article)
    {
        dataController = ArticleDataController(article: article)
        webController = ArticleWebController(dataController: dataController, delegate: self)
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
    
    private func presentPhotoBrowser(from index: Int, animatedFrom view: UIView? = nil)
    {
        guard let browser = IDMPhotoBrowser(photoURLs: dataController.imagesURLs, animatedFrom: view) else { return }
        browser.setInitialPageIndex(UInt(index))
        browser.portraitOrientationOnDismiss = !(UIDevice.current.userInterfaceIdiom == .pad)
        browser.delegate = self
        browser.displayActionButton = false
        browser.displayArrowButton = false
        browser.displayCounterLabel = false
        browser.controlsAlwaysVisible = false
        browser.doneButtonImage = #imageLiteral(resourceName: "article_photos_close")
        present(browser, animated: true, completion: nil)
    }
    
    func webController(_ webController: WebControllerProtocol, articleImageLinkActivatedAtIndex index: Int)
    {
        presentPhotoBrowser(from: index)
    }
    
    func webController(_ webController: WebControllerProtocol, articleLinkActivatedWithSlug slug: String)
    {
        // TODO: - show ArticlesPageViewController from slug
    }
    
    func webController(_ webController: WebControllerProtocol, linkActivated url: URL)
    {
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}

extension ArticleViewController: UIScrollViewDelegate
{
    private func shouldNotifyScrollDidScroll(_ scrollView: UIScrollView, withAnimation animated: Bool)
    {
        let selector = #selector(FromArticleVCToArticlesPageVCProtocol.updateNavigationBarBackground(withScrollView:heightParallaxView:animated:))
        
        if let responder = target(forAction: selector, withSender: self) as? FromArticleVCToArticlesPageVCProtocol
        {
            responder.updateNavigationBarBackground(withScrollView: scrollView, heightParallaxView: heightParallaxViewConstraint.constant, animated: animated)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        shouldNotifyScrollDidScroll(scrollView, withAnimation: false)
    }
}

extension ArticleViewController: IDMPhotoBrowserDelegate
{
//    func photoBrowser(_ photoBrowser: IDMPhotoBrowser!, captionViewForPhotoAt index: UInt) -> IDMCaptionView!
//    {
//        // TODO: - take the code from the app
//    }
}
