//
//  MainTableViewController.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 05/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit
import ProcedureKit

class MainTableViewController: UITableViewController {
    
    @IBOutlet weak var showArticlesButton: UIBarButtonItem!
    @IBOutlet weak var arabicSwitch: UISwitch!
    @IBOutlet weak var localeControls: UISegmentedControl!
    
    var enArticles: [Article]!
    var arArticles: [Article]!
    let queue = ProcedureQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arabicSwitch.sendActions(for: .valueChanged)
        localeControls.sendActions(for: .valueChanged)
        fetchArticles()
    }
    
    func fetchArticles()
    {
        let articleENURL = Bundle.main.url(forResource: "articlesEN", withExtension: "json")!
        let bringLocaleENArticlesOperation = BringJSONDataLocaleFileOperation(url: articleENURL, outputType: [Article].self)
        
        bringLocaleENArticlesOperation.addDidFinishBlockObserver(synchronizedWith: DispatchQueue.main) { [weak self] (networkOpration, error) in
            guard let strongSelf = self else { return }
            
            guard let articles = networkOpration.output.value?.value else { return }
            
            strongSelf.enArticles = articles
            
            if strongSelf.queue.operationCount == 0
            {
                strongSelf.showArticlesButton.isEnabled = true
            }
        }
        
        let articleARURL = Bundle.main.url(forResource: "articlesAR", withExtension: "json")!
        let bringLocaleARArticlesOperation = BringJSONDataLocaleFileOperation(url: articleARURL, outputType: [Article].self)
        
        bringLocaleARArticlesOperation.addDidFinishBlockObserver(synchronizedWith: DispatchQueue.main) { [weak self] (networkOpration, error) in
            guard let strongSelf = self else { return }
            
            guard let articles = networkOpration.output.value?.value else { return }
            
            strongSelf.arArticles = articles
            
            if strongSelf.queue.operationCount == 0
            {
                strongSelf.showArticlesButton.isEnabled = true
            }
        }
        
        queue.addOperations(bringLocaleENArticlesOperation, bringLocaleARArticlesOperation)
    }

    @IBAction func arabicSwitchValueChanged(_ sender: UISwitch) {
        VersionManager.shared.isArabic = sender.isOn
    }
    
    @IBAction func localeControlsValueChanged(_ sender: UISegmentedControl) {
        let identifiers = ["en_UK","fr_FR","ar_SA"]
        let identifier = identifiers[sender.selectedSegmentIndex]
        VersionManager.shared.locale = Locale(identifier: identifier)
    }
    
    @IBAction func showArticlesAction(_ sender: Any) {
        guard let articles = VersionManager.shared.isArabic ? arArticles : enArticles else { return }

        let articlesCollectionViewController = ArticlesCollectionViewController(nibName: "\(ArticlesCollectionViewController.self)", bundle: nil)
        articlesCollectionViewController.bindData(articles)
        show(articlesCollectionViewController, sender: self)
    }
}
