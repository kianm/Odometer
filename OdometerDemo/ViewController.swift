//
//  ViewController.swift
//  OdometerDemo
//
//  Created by Kian Mehravaran on 5/12/20.
//  Copyright © 2020 kian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var miles = 0.0
    private lazy var odometerView = Odometer(font: UIFont(name: "Helvetica", size: 64)!)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        title = "Odometer"
        setupViews(inside: view)
        startRolling()
    }

    private func startRolling() {
        odometerView.goto(miles: miles, animationTime: 0.09)
        miles += 0.02
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.startRolling()
        }
    }
}

extension ViewController {
    private func setupViews(inside containingView: UIView) {
        let label = UILabel()
        let dicts = ["containingView": containingView, "label": label, "odometerView": odometerView]

        let formats = ["V:|-120-[label]-25-[odometerView]",
                       "H:|-12-[label]-12-|",
                       "V:[containingView]-(<=0)-[odometerView]"]
        containingView.addVFL(dicts: dicts, formats: formats)

        label.numberOfLines = 0
        label.textColor = .orange
        label.font = UIFont(name: "Helvetica", size: 24)
        label.text = "Run on device for smooth animations!"
    }
}
