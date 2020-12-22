//
//  Images.swift
//  Rush It!
//
//  Created by Владислав Банков on 19.12.2020.
//

import UIKit

enum Images: String {
	case date

	var image: UIImage {
		guard let image = UIImage(named: self.rawValue) else {
			assertionFailure("can't get image asset")
			return UIImage()
		}
		return image
	}
}

