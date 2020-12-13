//
//  RollView.swift
//  OdometerDemo
//
//  Created by Kian Mehravaran on 5/12/20.
//  Copyright © 2020 kian. All rights reserved.
//

import UIKit

class RollView: UIView {
    private let polygon = CATransformLayer()
    private var numberSides = 0
    private var radius: CGFloat = 0
    private var angle: CGFloat = 0
    private var texts: [String] = []
    private var size = CGSize(width: 0, height: 0)
    private var font: UIFont!
    private var colors = [UIColor]()
    private var currentReading: CGFloat = 0

    required convenience init(texts: [String], colors: [UIColor], font: UIFont) {
        self.init(frame: .zero)
        self.font = font
        numberSides = texts.count
        self.texts = texts
        self.colors = colors
        angle = .pi * CGFloat(2) / CGFloat(numberSides)
        size = RollView.calcSize(texts: texts, font: self.font)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        radius = 0.5 * size.height / tan(.pi / CGFloat(numberSides))

        for side in 0 ..< numberSides {
            var transform = CATransform3DMakeRotation(CGFloat(side) * angle, 1, 0, 0)
            transform = CATransform3DTranslate(transform, 0, 0, radius)
            let _face = face(color: colors[side], text: texts[side])
            _face.transform = transform
            polygon.addSublayer(_face)
        }
        polygon.position = CGPoint(x: 0.5 * size.width, y: 0.5 * size.height)
        layer.masksToBounds = true
        layer.addSublayer(polygon)
    }

    override var intrinsicContentSize: CGSize {
        return size
    }

    func goto(digit: CGFloat, animationTime: TimeInterval) {
        let anim = CABasicAnimation(keyPath: "transform")

        var transformFrom = CATransform3DMakeRotation(currentReading * angle, 1, 0, 0)
        var transformTo = CATransform3DMakeRotation(digit * angle, 1, 0, 0)
        transformFrom.m34 = -1.0 / 1000.0
        transformTo.m34 = -1.0 / 1000.0
        anim.fromValue = transformFrom
        anim.toValue = transformTo
        currentReading = digit
        anim.duration = animationTime
        anim.isCumulative = true
        anim.repeatCount = .zero
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        polygon.add(anim, forKey: "transform")
    }

    var currentDigit: CGFloat {
        currentReading
    }

    func face(color: UIColor, text: String) -> CALayer {
        let face = CALayer()
        face.frame = CGRect(x: -0.5 * size.width, y: -0.5 * size.height, width: size.width, height: size.height)
        face.isDoubleSided = false
        face.backgroundColor = color.cgColor
        let textlayer = CATextLayer()
        let attributes = [
            .font: font,
            .foregroundColor: UIColor.black,
        ] as [NSAttributedString.Key: Any]

        let attributedString = NSAttributedString(string: text, attributes: attributes)
        textlayer.frame = CGRect(x: 0, y: -0.1 * size.height, width: size.width, height: size.height)
        textlayer.alignmentMode = .center
        textlayer.string = attributedString
        textlayer.isWrapped = true
        textlayer.truncationMode = .end
        textlayer.foregroundColor = UIColor.black.cgColor
        face.addSublayer(textlayer)
        return face
    }

    private static func calcSize(texts: [String], font: UIFont) -> CGSize {
        let attributes = [
            .font: font,
            .foregroundColor: UIColor.blue,
        ] as [NSAttributedString.Key: Any]

        var maxWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        for text in texts {
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            let textWidth = attributedString.size().width
            let textHeight = attributedString.size().height
            if textWidth > maxWidth {
                maxWidth = textWidth
            }
            if textHeight > maxHeight {
                maxHeight = textHeight
            }
        }
        return CGSize(width: maxWidth, height: maxHeight * 0.9)
    }
}

