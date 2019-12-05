//
//  ExtensionUIView.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 05/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit

extension UIView
{
    var insetLayoutSafeArea: UIEdgeInsets
    {
        let edgeInset: UIEdgeInsets
        if #available(iOS 11.0, *)
        {
            edgeInset = safeAreaInsets
        }
        else
        {
            edgeInset = layoutMargins
        }
        return edgeInset
    }
    
    func decideDirection()
    {
        if VersionManager.shared.isArabic
        {
            setDirectionRTL()
        }
    }
    
    func setDirectionRTL()
    {
        self.semanticContentAttribute = .forceRightToLeft
        if self is UILabel && ((self as! UILabel).textAlignment == .left || (self as! UILabel).textAlignment == .natural)
        {
            (self as! UILabel).textAlignment = .right
        }
        else if self is UITextView && ((self as! UITextView).textAlignment == .left || (self as! UITextView).textAlignment == .natural)
        {
            (self as! UITextView).textAlignment = .right
        }
        
        if subviews.isEmpty
        {
            return
        }
        
        for subview in subviews
        {
            subview.setDirectionRTL()
        }
    }
}
