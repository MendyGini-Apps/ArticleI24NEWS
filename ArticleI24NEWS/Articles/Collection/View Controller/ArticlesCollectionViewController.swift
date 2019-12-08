//
//  ArticlesCollectionViewController.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 01/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit
import SDWebImage

class ArticlesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    // MARK: - Properties
    private var dataController: ArticlesPageDataController!
    
    // MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        collectionView.register(UINib(nibName: "\(ArticleCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(ArticleCollectionViewCell.self)")
        
        dataController.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier(at: indexPath), for: indexPath)
    
        configure(cell: cell, at: indexPath)
    
        return cell
    }
    
    private func reuseIdentifier(at indexPath: IndexPath) -> String
    {
        return "\(ArticleCollectionViewCell.self)"
    }
    
    private func configure(cell: UICollectionViewCell, at indexPath: IndexPath)
    {
        guard let articleCell = cell as? ArticleCollectionViewCell else { return }
        
//        let htmlArticleModel = dataController.item(at: indexPath)
//
//        articleCell.titleLabel.text = htmlArticleModel.base.title
//        articleCell.descriptionLabel.text = htmlArticleModel.base.excerpt
//        articleCell.authorNameLabel.text = htmlArticleModel.base.authorName
//        articleCell.webView.loadHTMLString(htmlArticleModel.formatted, baseURL: nil)
//
//        articleCell.categoryLabel.text = htmlArticleModel.base.category.uppercased(with: VersionManager.shared.locale)
//
//        if var articleCreatedAtAsString = stringFor(date: htmlArticleModel.base.createdAt)
//        {
//            if htmlArticleModel.base.createdAt!.compare(htmlArticleModel.base.updatedAt!) == .orderedAscending, let articleUpdateAtAsString = stringFor(date: htmlArticleModel.base.updatedAt)
//            {
//                // TODO: - Localization "UPD"
//                articleCreatedAtAsString += " | UPD \(articleUpdateAtAsString)"
//            }
//            articleCell.dateLabel.text = articleCreatedAtAsString
//        }
//
//        guard let imageURL = htmlArticleModel.base.images.first?.imageURL else { return }
//        articleCell.headerImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "logo_article"))
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
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return collectionView.bounds.size
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

extension ArticlesCollectionViewController
{
    func bindData(_ articles: [Article])
    {
        dataController = ArticlesPageDataController(articles: articles, delegate: self)
    }
}

// MARK: - ArticlesPageDataControllerDelegate Implementation
extension ArticlesCollectionViewController: ArticlesPageDataControllerDelegate
{
    func dataController(_ dataController: ArticlesPageDataController, taskStateDidChange state: Bool) {
        collectionView.reloadData()
    }
}
