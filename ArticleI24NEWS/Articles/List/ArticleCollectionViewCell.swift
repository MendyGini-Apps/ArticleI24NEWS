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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var heightParallaxViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerWebView: UIView!
    
    let webView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())
        webView.scrollView.isScrollEnabled = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private var observations = Set<NSKeyValueObservation>()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        containerWebView.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: containerWebView.leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: containerWebView.topAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: containerWebView.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: containerWebView.bottomAnchor).isActive = true
        webView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true

        
        self.observations.insert(webView.observe(\.estimatedProgress, options: [.new]) { (webView, changed) in
            
            guard let newValue = changed.newValue else { return }
            guard newValue == 1.0 else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                webView.constraints.first(where: { $0.firstAttribute == .height })?.constant = webView.scrollView.contentSize.height
            })
        })
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        headerImageView.image = nil
        webView.constraints.first(where: { $0.firstAttribute == .height })?.constant = 1.0
        if webView.isLoading
        {
            scrollView.contentOffset.y = 0
            webView.stopLoading()
        }
        webView.loadHTMLString("", baseURL: nil)
    }
}
