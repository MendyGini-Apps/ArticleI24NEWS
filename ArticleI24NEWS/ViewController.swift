//
//  ViewController.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 28/11/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func showArticleViewController(_ sender: UIBarButtonItem) {
        let articlesCollectionViewController = ArticlesCollectionViewController(nibName: "\(ArticlesCollectionViewController.self)", bundle: nil)
        show(articlesCollectionViewController, sender: self)
    }
}

