//
//  GradientView.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 10/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import UIKit

class GradientView: UIView
{
    override class var layerClass: AnyClass
    {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer
    {
        return layer as! CAGradientLayer
    }
}
