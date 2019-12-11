//
//  ArticlesPageViewController.swift
//  ArticleI24NEWS
//
//  Created by Mendy Barouk on 08/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit

class ArticlesPageViewController: UIPageViewController
{
    @IBOutlet var backgroundNavigationBarView: GradientView!
    @IBOutlet weak var blueBackgroundNavigationBarView: UIView!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet weak var commentButton: CommentButton!
    
    // MARK: - Properties
    private var dataController: ArticlesPageDataController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureView()
        dataSource = self
        delegate = self
        
        dataController.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - IBActions
    @IBAction func commentButtonDidTapped(sender: UIView, forEvent event: UIEvent)
    {
        print(#function)
    }
    
    @IBAction func addCommentButtonDidTapped(sender: UIView, forEvent event: UIEvent)
    {
        print(#function)
    }
}

// MARK: - Public Methods
extension ArticlesPageViewController
{
    func bindData(_ articles: [Article])
    {
        dataController = ArticlesPageDataController(articles: articles, delegate: self)
    }
}

// MARK: - Private Methods
extension ArticlesPageViewController
{
    func configureView()
    {
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }
        let emptyImage = UIImage()
        navigationBar.setBackgroundImage(emptyImage, for: .default)
        navigationBar.shadowImage = emptyImage
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        
        backgroundNavigationBarView.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        backgroundNavigationBarView.gradientLayer.startPoint = CGPoint.zero
        backgroundNavigationBarView.gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        view.insertSubview(backgroundNavigationBarView, belowSubview: navigationBar)
        backgroundNavigationBarView.translatesAutoresizingMaskIntoConstraints = false
        backgroundNavigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundNavigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundNavigationBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundNavigationBarView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
    }
    
    private func getArticleViewController(with item: ArticlesPageDataController.Item) -> ArticleViewController
    {
        let articleViewController = storyboard!.instantiateViewController(withIdentifier: "\(ArticleViewController.self)") as! ArticleViewController
        articleViewController.bindData(htmlArticle: item)
        
        return articleViewController
    }
}

// MARK: - UIPageViewControllerDataSource Implementation
extension ArticlesPageViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let previousArticle = dataController.previousItem() else { return nil }
        
        let articleViewController = getArticleViewController(with: previousArticle)
        
        return articleViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let nextArticle = dataController.nextItem() else { return nil }
        
        let articleViewController = getArticleViewController(with: nextArticle)
        
        return articleViewController
    }
}

// MARK: - UIPageViewControllerDelegate Implementation
extension ArticlesPageViewController: UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        guard completed else { return }
        
        guard let articleViewController = pageViewController.viewControllers?.first as? ArticleViewController else { return }
        
        dataController.currentItem = articleViewController.dataController.htmlArticle
    }
}

// MARK: - ArticlesPageDataControllerDelegate Implementation
extension ArticlesPageViewController: ArticlesPageDataControllerDelegate
{
    func dataController(_ dataController: ArticlesPageDataController, taskStateDidChange state: Bool)
    {
        guard let currentArticle = dataController.currentItem else { return }
        
        let articleViewController = getArticleViewController(with: currentArticle)
        
        setViewControllers([articleViewController], direction: .forward, animated: false, completion: nil)
    }
    
    func dataController(_ dataController: ArticlesPageDataController, currentItemDidChanged item: ArticlesPageDataController.Item)
    {
        commentButton.numberOfComment = item.base.numberOfComments
    }
}

extension ArticlesPageViewController: FromArticleVCToArticlesPageVCProtocol
{
    func updateNavigationBarBackground(withScrollView scrollView: UIScrollView, heightParallaxView: CGFloat, animated: Bool)
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
        var percentParalaxOffset = (contentYOffsetAdjusted/(heightParallaxView - navigationBar.frame.maxY)).roundToDecimal(2)
        percentParalaxOffset = max(0, min(percentParalaxOffset, 1))
        if animated
        {
            UIView.animate(withDuration: 0.3) {
                self.blueBackgroundNavigationBarView.alpha = percentParalaxOffset
            }
        }
        else
        {
            blueBackgroundNavigationBarView.alpha = percentParalaxOffset
        }
    }
}
