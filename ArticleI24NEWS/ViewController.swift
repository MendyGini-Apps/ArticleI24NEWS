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
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }


    @IBAction func showArticleViewController(_ sender: UIBarButtonItem) {
        let articleViewController = ArticleViewController(nibName: "\(ArticleViewController.self)", bundle: nil)
        show(articleViewController, sender: self)
    }
}

