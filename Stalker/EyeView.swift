//
//  EyeView.swift
//  Stalker
//
//  Created by Michael Simard on 5/8/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import UIKit

class EyeView: UIView {

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var eyeLidShapeLayer: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        drawEye()
        self.animate()
        self.backgroundColor = .clear
    }

    func drawEye() {
        self.layer.addSublayer(createEyeOutlineShapeLayer())
        self.layer.addSublayer(createPupilShapeLayer())
        eyeLidShapeLayer = createEyelidShapeLayer()
        self.layer.addSublayer(eyeLidShapeLayer!)
    }

    func animate () {
        if let eyeLidShape = eyeLidShapeLayer {
            let animationGroup = CAAnimationGroup()
            animationGroup.repeatCount = .greatestFiniteMagnitude
            animationGroup.duration = 4
            animationGroup.animations = [blinkAnimation(beginTime: 1.0),
                                         blinkAnimation(beginTime: 1.9)
            ]
            eyeLidShape.add(animationGroup, forKey: "blinks")
        }
    }

    func blinkAnimation(beginTime: CFTimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = CGPath(rect: CGRect(x: 0,
                                                y: 0,
                                                width: bounds.width,
                                                height: bounds.height),
                                   transform: &transform)
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.duration = 0.3
        animation.beginTime = beginTime
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut) //
        return animation
    }

    func delayAnimation(duration: Double) -> CAAnimationGroup {
        let animation =  CAAnimationGroup()
        animation.duration = duration
        return animation
    }

    func createEyeOutlineShapeLayer() -> CAShapeLayer {
        let eyeOutlineShapeLayer = CAShapeLayer()
        eyeOutlineShapeLayer.frame = CGRect(x: 0,
                                            y: bounds.height * 0.1 ,
                                            width: bounds.width,
                                            height: bounds.height * 0.8)

        let eyePath = CGPath(ellipseIn: CGRect(x: 0,
                                              y: 0,
                                              width: eyeOutlineShapeLayer.bounds.width,
                                              height: eyeOutlineShapeLayer.bounds.height),
                             transform: &transform)
        eyeOutlineShapeLayer.path = eyePath
        eyeOutlineShapeLayer.strokeColor = UIColor.black.cgColor
        eyeOutlineShapeLayer.fillColor = UIColor.white.cgColor
        eyeOutlineShapeLayer.lineWidth = 10
        return eyeOutlineShapeLayer
    }

    func createPupilShapeLayer() -> CAShapeLayer {
        let pupilShapeLayer = CAShapeLayer()
        pupilShapeLayer.frame = CGRect(x: 0, y: 0,
                                       width: frame.width, height: frame.height)
        let pupilPath = CGPath(ellipseIn: CGRect(x: frame.width * 0.425,
                                                 y: frame.height * 0.425,
                                                 width: frame.width * 0.15,
                                                 height: frame .height * 0.25),
                               transform: &transform)
        pupilShapeLayer.path = pupilPath
        pupilShapeLayer.strokeColor = UIColor.black.cgColor
        pupilShapeLayer.fillColor = UIColor.black.cgColor
        pupilShapeLayer.lineWidth = 10
        return pupilShapeLayer
    }

    func createEyelidShapeLayer() -> CAShapeLayer {
        let eyelidShapeLayer = CAShapeLayer()
        eyelidShapeLayer.frame = CGRect(x: 0,
                                        y: 0,
                                        width: bounds.width,
                                        height: bounds.height)

        let eyelidPath = CGPath(rect: CGRect(x: 0,
                                             y: 0,
                                             width: bounds.width,
                                             height: bounds.height * 0.2),
                                transform: &transform)

        eyelidShapeLayer.path = eyelidPath
        eyelidShapeLayer.strokeColor = UIColor.black.cgColor
        eyelidShapeLayer.fillColor = UIColor.black.cgColor
        eyelidShapeLayer.lineWidth = 1
        eyelidShapeLayer.mask = createEyeOutlineShapeLayer()
        return eyelidShapeLayer
    }

    override func draw(_ rect: CGRect) {

    }
}
