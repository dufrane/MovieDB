//
//  UIView + Extensions.swift
//  testProject
//
//  Created by Dmytro Vasylenko on 10.02.2025.
//

import UIKit

extension UIView {
    
    func addShaddowOnView() {
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
    }
}
