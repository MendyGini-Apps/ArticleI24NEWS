//
//  ArticleViewController.swift
//  ArticleI24NEWS
//
//  Created by Mendy Barouk on 08/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController
{
    var htmlArticle: HTMLArticleModel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let colors: [UIColor] = [.black,.blue,.brown,.cyan,.darkGray,.magenta,.orange,.purple]
        view.backgroundColor = colors.randomElement()
        view.tag = colors.firstIndex(of: view.backgroundColor!)!
    }
}

extension ArticleViewController
{
    func bindData(htmlArticle: HTMLArticleModel)
    {
        self.htmlArticle = htmlArticle
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
}
