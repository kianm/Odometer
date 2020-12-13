//
//  Odometer.swift
//  OdometerDemo
//
//  Created by Kian Mehravaran on 5/12/20.
//  Copyright © 2020 kian. All rights reserved.
//

import UIKit

private struct Digits {
    let digit10th: Int
    let digit1: Int
    let digit10: Int
    let digit100: Int
    init(digit: CGFloat) {
        digit10th = Int(digit * 10) % 10
        digit1 = Int(digit) % 10
        digit10 = Int(digit / 10) % 10
        digit100 = Int(digit / 100) % 100
    }
}

class Odometer: UIView {
    private let texts = ["0", "9", "8", "7", "6", "5", "4", "3", "2", "1"]
    private let colors0: [UIColor] = [.red, .lightGray, .lightGray, .lightGray, .lightGray, .lightGray, .lightGray, .lightGray, .lightGray, .lightGray]
    private let colors: [UIColor] = [.white, .white, .white, .white, .white, .white, .white, .white, .white, .white]
    private var font: UIFont!

    private lazy var rollView0 = RollView(texts: texts, colors: colors0, font: font)
    private lazy var rollView1 = RollView(texts: texts, colors: colors, font: font)
    private lazy var rollView10 = RollView(texts: texts, colors: colors, font: font)
    private lazy var rollView100 = RollView(texts: texts, colors: colors, font: font)
    private var currentReading: CGFloat = 0

    required convenience init(font: UIFont) {
        self.init(frame: .zero)
        self.font = font
        let dicts: [String: Any] = [
            "rollView0": rollView0,
            "rollView1": rollView1,
            "rollView10": rollView10,
            "rollView100": rollView100,
        ]
        let formats = ["H:|-0-[rollView100]-1-[rollView10]-1-[rollView1]-1-[rollView0]-0-|",
                       "V:|-0-[rollView0]-0-|",
                       "V:|-0-[rollView1]-0-|",
                       "V:|-0-[rollView10]-0-|",
                       "V:|-0-[rollView100]-0-|"]
        addVFL(dicts: dicts, formats: formats)
        let width: CGFloat = 0.3
        let color: CGColor = UIColor.black.cgColor
        rollView0.layer.borderColor = color
        rollView1.layer.borderColor = color
        rollView10.layer.borderColor = color
        rollView100.layer.borderColor = color

        rollView0.layer.borderWidth = width
        rollView1.layer.borderWidth = width
        rollView10.layer.borderWidth = width
        rollView100.layer.borderWidth = width
    }

    func goto(miles: Double, animationTime: TimeInterval) {
        let digit = CGFloat(miles)
        let currentDigits = Digits(digit: currentReading)
        let newDigits = Digits(digit: digit)

        let afterDecimal = (digit - floor(digit)) * 10
        rollView0.goto(digit: afterDecimal, animationTime: animationTime)

        if currentDigits.digit1 != newDigits.digit1 {
            let digit_10 = 0.1 * digit
            let beforeDecimal = (digit_10 - floor(digit_10)) * 10
            rollView1.goto(digit: beforeDecimal, animationTime: animationTime)
        }
        if currentDigits.digit10 != newDigits.digit10 {
            let digit_100 = 0.01 * digit
            let beforeBeforeDecimal = (digit_100 - floor(digit_100)) * 10
            rollView10.goto(digit: beforeBeforeDecimal, animationTime: animationTime)
        }
        if currentDigits.digit100 != newDigits.digit100 {
            let digit_1000 = 0.001 * digit
            let beforeBeforeBeforeDecimal = (digit_1000 - floor(digit_1000)) * 10
            rollView100.goto(digit: beforeBeforeBeforeDecimal, animationTime: animationTime)
        }
        currentReading = digit
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

