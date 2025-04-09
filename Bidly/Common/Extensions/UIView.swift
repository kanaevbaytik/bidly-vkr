//
//  UIView.swift
//  Bidly
//
//  Created by Baytik  on 3/3/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
