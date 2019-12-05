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
    var dataController: ArticlesCollectionDataController!
    
    // MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        collectionView.register(UINib(nibName: "\(ArticleCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(ArticleCollectionViewCell.self)")
        
        dataController = ArticlesCollectionDataController(delegate: self)
        dataController.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return dataController.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataController.numberOfItems(in: section)
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
        
        let article = dataController.item(at: indexPath)
        
        articleCell.titleLabel.text = article.title
        articleCell.descriptionLabel.text = article.excerpt
        articleCell.authorNameLabel.text = article.authorName
        articleCell.webView.loadHTMLString(article.HTMLString, baseURL: nil)
        
        // TODO: - current app local (EN, FR, AR)
        articleCell.categoryLabel.text = article.category.uppercased(with: Locale.current)
        
        if var articleCreatedAtAsString = stringFor(date: article.createdAt)
        {
            if article.createdAt!.compare(article.updatedAt!) == .orderedAscending, let articleUpdateAtAsString = stringFor(date: article.updatedAt)
            {
                // TODO: - Localization "UPD"
                articleCreatedAtAsString += " | UPD \(articleUpdateAtAsString)"
            }
            articleCell.dateLabel.text = articleCreatedAtAsString
        }
        
        guard let imageURL = article.images.first?.imageURL else { return }
        articleCell.headerImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "logo_article"))
    }
    
    func stringFor(date: Date?) -> String?
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

// MARK: - ArticlesCollectionDataControllerDelegate Implementation
extension ArticlesCollectionViewController: ArticlesCollectionDataControllerDelegate
{
    func dataController(_ dataController: ArticlesCollectionDataController, taskStateDidChange state: Bool) {
        collectionView.reloadData()
    }
}
