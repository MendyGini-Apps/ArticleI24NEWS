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
        
        self.collectionView!.register(UINib(nibName: "\(ArticleCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(ArticleCollectionViewCell.self)")
        
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
        
        articleCell.webView.loadHTMLString(article.bodyHTML, baseURL: nil)
        guard let imageURL = article.images.first?.imageURL else { return }
        articleCell.headerImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "logo_article"))
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return collectionView.bounds.size
    }
    
    // MARK: - IBActions
    @IBAction func commentButtonDidTapped(sender: UIView, forEvent event: UIEvent)
    {
        
    }
    
    @IBAction func addCommentButtonDidTapped(sender: UIView, forEvent event: UIEvent)
    {
        
    }
}

// MARK: - ArticlesCollectionDataControllerDelegate Implementation
extension ArticlesCollectionViewController: ArticlesCollectionDataControllerDelegate
{
    func dataController(_ dataController: ArticlesCollectionDataController, taskStateDidChange state: Bool) {
        collectionView.reloadData()
    }
}
