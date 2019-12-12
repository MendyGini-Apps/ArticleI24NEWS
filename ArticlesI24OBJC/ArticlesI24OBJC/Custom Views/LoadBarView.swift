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
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var progress: CGFloat = 0.0
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var hidesWhenFinishProgress: Bool = false
    
    override func draw(_ rect: CGRect)
    {
        guard (0.0...1.0) ~= progress else { isHidden = true; return }
        
        isHidden = false
        
        var loadedRect = rect
        loadedRect.size.width *= progress
        
        let path = UIBezierPath(rect: loadedRect)
        
        fillColor.setFill()
        path.fill()
        
        if hidesWhenFinishProgress && progress == 1.0
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.isHidden = true
            }
        }
    }
}
