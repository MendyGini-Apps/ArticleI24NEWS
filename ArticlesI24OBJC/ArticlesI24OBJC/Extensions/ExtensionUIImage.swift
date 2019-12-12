//
//  ExtensionUIImage.swift
//  PaArt
//
//  Created by Mendy Barouk on 30/12/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

extension UIImage
{
    func getHeightKeepingRatioByWidth(_ width: CGFloat, adjustedInset: UIEdgeInsets = UIEdgeInsets.zero) -> CGFloat
    {
        let ratio = size.width / size.height
        let height = width / ratio
        return height - (adjustedInset.top + adjustedInset.bottom)
    }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

extension CGFloat {
    func roundToDecimal(_ fractionDigits: Int) -> CGFloat {
        return CGFloat(Double(self).roundToDecimal(fractionDigits))
    }
}
