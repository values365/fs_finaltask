//
//  UIViewExtension.swift
//  Rush It!
//
//  Created by Владислав Банков on 21.12.2020.
//

import UIKit

public extension UIView {
	func edgeTo(_ view: UIView) {
		view.addSubview(self)
		self.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.topAnchor.constraint(equalTo: view.topAnchor),
			self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		])
	}

	func pinMenuTo(_ view: UIView, with widthMultiplier: CGFloat) {
		view.addSubview(self)
		self.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.topAnchor.constraint(equalTo: view.topAnchor),
			self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier),
			self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}
