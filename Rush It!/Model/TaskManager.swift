//
//  TaskManager.swift
//  Rush It!
//
//  Created by Владислав Банков on 20.12.2020.
//

import Foundation
import RealmSwift

final class TaskManager {

	static let shared = TaskManager()

	private var realm: Realm
	var taskList: Results<Task>

	private init() {
		do {
			realm = try Realm()
		} catch let error as NSError {
			fatalError("Unresolved error \(error), \(error.userInfo)")
		}
		taskList = realm.objects(Task.self)
	}

	func makeCompleted(_ task: Task) {
		do {
			try realm.write {
				task.isCompleted = true
			}
		} catch {
			assertionFailure("Realm object writing error")
		}
	}

	func save(_ task: Task) {
		do {
			try realm.write {
				realm.add(task)
			}
		} catch {
			assertionFailure("Realm object writing error")
		}
	}

	func delete(_ task: Task) {
		do {
			try realm.write {
				realm.delete(task)
			}
		} catch {
			assertionFailure("Realm object writing error")
		}
	}

	func deleteAll() {
		do {
			try realm.write {
				realm.deleteAll()
			}
		} catch {
			assertionFailure("Realm object writing error")
		}
	}

	func update(at index: Int, with task: Task) {
		do {
			try realm.write {
				taskList[index].title = task.title
				taskList[index].notes = task.notes
				taskList[index].date = task.date
				taskList[index].hours = task.hours
				taskList[index].minutes = task.minutes
			}
		} catch {
			assertionFailure("Realm object writing error")
		}
	}

	func dateToString(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.timeStyle = .none
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter.string(from: date)
	}

	func stringToDate(string: String) -> Date {
		let formatter = DateFormatter()
		formatter.timeStyle = .none
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter.date(from: string)!
	}
}

