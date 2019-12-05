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
    let webView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())
        webView.scrollView.isScrollEnabled = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
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
        webView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
    
    private func observeWebViewEstimatedProgress()
    {
        observations.insert(webView.observe(\.estimatedProgress, options: [.new]) { [weak self] (webView, changed) in
            
            guard let strongSelf = self else { return }
            guard let newValue = changed.newValue else { return }
            strongSelf.loadBarView.progress = CGFloat(newValue)
            guard newValue == 1.0 else { return }
            
            strongSelf.adjustWebViewHeight()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.adjustWebViewHeight(webView.scrollView.contentSize.height)
            })
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
        heightParallaxViewConstraint.constant = headerImageView.image!.getHeightKeepingRatioByWidth(headerImageView.frame.width, adjustedInset: insetLayoutSafeArea)
    }
}
