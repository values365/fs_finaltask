//
//  Task.swift
//  Rush It!
//
//  Created by Владислав Банков on 20.12.2020.
//

import Foundation
import RealmSwift

final class Task: Object {
	@objc dynamic var title = ""
	@objc dynamic var notes = ""
	@objc dynamic var date = ""
	@objc dynamic var hours = 0
	@objc dynamic var minutes = 0
	@objc dynamic var isCompleted = false

	convenience init(title: String, notes: String, date: String, timeToComplete: (Int, Int)) {
		self.init()
		self.title = title
		self.notes = notes
		self.date = date
		self.hours = timeToComplete.0
		self.minutes = timeToComplete.1
	}
}
