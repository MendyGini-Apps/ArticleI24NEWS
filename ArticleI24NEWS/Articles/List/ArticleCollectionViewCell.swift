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
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var containerWebView : UIView!
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
        
        addWebView()
        observeWebViewEstimatedProgress()
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        headerImageView.image = nil
        adjustWebViewHeight(1.0)
        if webView.isLoading
        {
            scrollView.contentOffset.y = 0
            webView.stopLoading()
        }
        webView.loadHTMLString("", baseURL: nil)
    }
}

extension ArticleCollectionViewCell
{
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
        observations.insert(webView.observe(\.estimatedProgress, options: [.new]) { (webView, changed) in
            
            guard let newValue = changed.newValue else { return }
            guard newValue == 1.0 else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
                self?.adjustWebViewHeight(webView.scrollView.contentSize.height)
            })
        })
    }
    
    private func adjustWebViewHeight(_ height: CGFloat)
    {
        webView.constraints.first(where: { $0.firstAttribute == .height })?.constant = height
    }
}
