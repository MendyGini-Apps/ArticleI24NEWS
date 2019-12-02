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
    
    var dataController: ArticlesCollectionDataController!
    
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
    
    func reuseIdentifier(at indexPath: IndexPath) -> String
    {
        return "\(ArticleCollectionViewCell.self)"
    }
    
    func configure(cell: UICollectionViewCell, at indexPath: IndexPath)
    {
        guard let articleCell = cell as? ArticleCollectionViewCell else { return }
        
        let article = dataController.item(at: indexPath)
        
        articleCell.titleLabel.text = article.title
        articleCell.descriptionLabel.text = article.excerpt
        
        articleCell.webView.loadHTMLString(article.bodyHTML, baseURL: nil)
        guard let imageURL = article.images.first?.imageURL else { return }
        articleCell.headerImageView.sd_setImage(with: imageURL)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataController.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataController.numberOfItems(in: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier(at: indexPath), for: indexPath)
    
        // Configure the cell
        configure(cell: cell, at: indexPath)
    
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = collectionView.bounds.size
//        size.height -= (view.layoutMargins.top + view.layoutMargins.bottom)
        return size
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
}

extension ArticlesCollectionViewController: ArticlesCollectionDataControllerDelegate
{
    func dataController(_ dataController: ArticlesCollectionDataController, taskStateDidChange state: Bool) {
        collectionView.reloadData()
    }
}
