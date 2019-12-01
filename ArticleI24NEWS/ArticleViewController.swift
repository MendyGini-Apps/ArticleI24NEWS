//
//  ArticleViewController.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 28/11/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController
{
    @IBOutlet weak var heightParallaxViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerWebView: UIView!
    
    var heightWebViewConstraint: NSLayoutConstraint!
    let webView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())
        webView.scrollView.isScrollEnabled = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        let backItem = UINavigationItem()
//        backItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem, target: <#T##Any?#>, action: <#T##Selector?#>)
        navigationBar.items = [self.navigationItem]
        return navigationBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        view.addSubview(navigationBar)
        navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        
        containerWebView.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: containerWebView.leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: containerWebView.topAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: containerWebView.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: containerWebView.bottomAnchor).isActive = true
        heightWebViewConstraint = webView.heightAnchor.constraint(equalToConstant: 200)
        heightWebViewConstraint.isActive = true
        
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: "https://www.google.com")!))
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension ArticleViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let contentYOffsetAdjusted: CGFloat
        if #available(iOS 11.0, *)
        {
            contentYOffsetAdjusted = scrollView.adjustedContentInset.top + scrollView.contentOffset.y
        }
        else
        {
            contentYOffsetAdjusted = scrollView.contentOffset.y
        }
        var percentParalaxOffset = (contentYOffsetAdjusted/heightParallaxViewConstraint.constant).roundToDecimal(2)
        percentParalaxOffset = max(0, min(percentParalaxOffset, 1))
        print(percentParalaxOffset)
        let color = UIColor.blue.withAlphaComponent(percentParalaxOffset)
        let image = color.image(navigationBar.frame.size)
        navigationBar.setBackgroundImage(image, for: .default)
    }
}

extension ArticleViewController: WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    self.heightWebViewConstraint.constant = height as! CGFloat
                })
            }
            
        })
    }
}
