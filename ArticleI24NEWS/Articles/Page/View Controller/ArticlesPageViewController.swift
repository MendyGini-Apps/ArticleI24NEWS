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
    // MARK: - Properties
    private var dataController: ArticlesPageDataController!
    
    // MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        dataController.fetchData()
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
}
