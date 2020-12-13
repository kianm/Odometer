//
//  UIView+Subview.swift
//  OdometerDemo
//
//  Created by Kian Mehravaran on 5/12/20.
//  Copyright © 2020 kian. All rights reserved.
//

import UIKit

extension UIView {
    
    func addVFL(dicts: [String: Any], formats: [String]) {
        dicts.forEach { _, view in
            guard let view = view as? UIView else {
                return
            }
            if view != self {
                view.translatesAutoresizingMaskIntoConstraints = false
                addSubview(view)
            }
        }
        var constraints: [NSLayoutConstraint] = []
        formats.forEach { format in
            var options: NSLayoutConstraint.FormatOptions = []
            if isHorizontalCenter(format) {
                options = .alignAllCenterX
            }
            if isVerticalCenter(format) {
                options = .alignAllCenterY
            }
            constraints += NSLayoutConstraint.constraints(
                withVisualFormat: format,
                options: options,
                metrics: nil, views: dicts
            )
        }
        addConstraints(constraints)
    }

    func isHorizontalCenter(_ format: String) -> Bool {
         format.starts(with: "V:") && format.contains("-(<=0)-")
    }

    func isVerticalCenter(_ format: String) -> Bool {
         format.starts(with: "H:") && format.contains("-(<=0)-")
    }
}
