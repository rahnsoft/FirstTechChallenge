//
//  UIView.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 21/10/2021.
//

import Foundation
import UIKit
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func addBorder(edges: UIRectEdge, colour: UIColor = UIColor.themeColor, thickness: CGFloat = 1, leftPadding: CGFloat = 0, rightPadding: CGFloat = 0) {
        func border() -> UIView {
            let border = UIView()
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]", options: [], metrics: ["thickness": thickness], views: ["top": top]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|", options: [], metrics: nil, views: ["top": top]))
        }
    
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]", options: [], metrics: ["thickness": thickness], views: ["left": left]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|", options: [], metrics: nil, views: ["left": left]))
        }
    
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|", options: [], metrics: ["thickness": thickness], views: ["right": right]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|", options: [], metrics: nil, views: ["right": right]))
        }
    
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|", options: [], metrics: ["thickness": thickness], views: ["bottom": bottom]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(leftPadding)-[bottom]-(rightPadding)-|", options: [], metrics: ["leftPadding": leftPadding, "rightPadding": rightPadding], views: ["bottom": bottom]))
        }
    }
}

final class HavaRoundImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = bounds.size.width / 2.0
        layer.cornerRadius = radius
    }
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
