//
//  LoadBarView.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 05/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit

@IBDesignable
class LoadBarView: UIView
{
    @IBInspectable var fillColor: UIColor = UIColor.systemRed
        {
        didSet {
            setNeedsDisplay()
        }
        
    }
    
    @IBInspectable var progress: CGFloat = 0.5
        {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        guard (0...1) ~= progress else { isHidden = true; return }
        
        isHidden = false
        
        var loadedRect = rect
        loadedRect.size.width *= progress
        
        let path = UIBezierPath(rect: loadedRect)
        
        fillColor.setFill()
        path.fill()
    }
}
