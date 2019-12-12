//
//  ExtensionUIViewController.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 10/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit

extension UIViewController
{
    @IBAction func popViewControllerWithAnimation()
    {
        navigationController?.popViewController(animated: true)
    }
}
