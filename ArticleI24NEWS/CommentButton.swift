//
//  CommentButton.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 10/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit

class CommentButton: UIButton
{
    @IBInspectable var numberOfComment: UInt = 0
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    let textLayer = VerticalAlignedTextLayer()
    
    override var isHighlighted: Bool
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        configureView()
    }
    
    override func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
        configureView()
    }
    
    override func draw(_ rect: CGRect)
    {
        textLayer.string = numberOfComment > 0 ? "\(numberOfComment)" : ""
        textLayer.foregroundColor = isHighlighted ? currentTitleColor.withAlphaComponent(0.3).cgColor : currentTitleColor.cgColor
        textLayer.frame = rect
    }
    
    private func configureView()
    {
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.font = self.titleLabel?.font
        textLayer.fontSize = self.titleLabel?.font.pointSize ?? textLayer.fontSize
        textLayer.masksToBounds = true
        textLayer.contentsScale = UIScreen.main.scale
        setImage(#imageLiteral(resourceName: "article_comment_icon"), for: .normal)
        layer.addSublayer(textLayer)
    }
}

class VerticalAlignedTextLayer : CATextLayer
{
    override func draw(in context: CGContext)
    {
        let height = bounds.size.height
        let yDiff = (height-fontSize)/2 - fontSize/4
        
        context.saveGState()
        context.translateBy(x: 0, y: yDiff)
        super.draw(in: context)
        context.restoreGState()
    }
}
