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
    static func generateImageFrom(cgColor: CGColor, _ rect: CGRect) -> UIImage?
    {
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func getHeightKeepingRatioByWidth(_ width: CGFloat, adjustedInset: UIEdgeInsets = UIEdgeInsets.zero) -> CGFloat
    {
        let ratio = size.width / size.height
        let height = width / ratio
        return height - (adjustedInset.top + adjustedInset.bottom)
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
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

extension DateFormatter
{
    static let i24APIArticleFormatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return formatter
    }()
    
    static let i24APINewsFormatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }()
    
    static let i24DayForArticleFormatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy"
        
        return formatter
    }()
    
    static let i24TimeForArticleFormatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        
        return formatter
    }()
    
    static let i24DateForeNewsFormatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.locale = Locale.current // TODO: - User From Version Manager
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        formatter.doesRelativeDateFormatting = true
        
        return formatter
    }()
    
    static let i24TimeForeNewsFormatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        return formatter
    }()
}

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
}
