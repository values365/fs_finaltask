//
//  Balloon.swift
//  Rush It!
//
//  Created by Владислав Банков on 22.12.2020.
//

import UIKit

final class Balloon: UIView {

	init() {
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		let balloonColor = UIColor.green
		let cordColor = UIColor.black

		let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 66, height: 93))
		balloonColor.setFill()
		ovalPath.fill()

		let trianglePath = UIBezierPath()
		trianglePath.move(to: CGPoint(x: 33, y: 81.5))
		trianglePath.addLine(to: CGPoint(x: 42.96, y: 98.75))
		trianglePath.addLine(to: CGPoint(x: 23.04, y: 98.75))
		trianglePath.close()
		balloonColor.setFill()
		trianglePath.fill()

		let cordPath = UIBezierPath()
		cordPath.move(to: CGPoint(x: 33.29, y: 98.5))
		cordPath.addCurve(to: CGPoint(x: 33.29, y: 126.5),
						  controlPoint1: CGPoint(x: 33.29, y: 98.5),
						  controlPoint2: CGPoint(x: 27.01, y: 114.06))
		cordPath.addCurve(to: CGPoint(x: 33.29, y: 157.61),
						  controlPoint1: CGPoint(x: 39.57, y: 138.94),
						  controlPoint2: CGPoint(x: 39.57, y: 145.17))
		cordPath.addCurve(to: CGPoint(x: 33.29, y: 182.5),
						  controlPoint1: CGPoint(x: 27.01, y: 170.06),
						  controlPoint2: CGPoint(x: 33.29, y: 182.5))
		cordColor.setStroke()
		cordPath.lineWidth = 1
		cordPath.stroke()
	}
}

