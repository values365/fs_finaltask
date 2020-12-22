//
//  CompletedTasksViewController.swift
//  Rush It!
//
//  Created by Владислав Банков on 22.12.2020.
//

import UIKit
import RealmSwift

final class CompletedTasksViewController: UIViewController {

	// MARK: - Properties

	private var tasks: Results<Task> {
		TaskManager.shared.taskList
	}

	private var sortedDates: [String] = []


	// MARK: - UI Components

	private let completedTasksView = CompletedTasksView()

	// MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
		prepareDateSet()
    }

	override func loadView() {
		view = completedTasksView
		completedTasksView.tableViewDelegate = self
		completedTasksView.tableViewDataSource = self
	}
}

// MARK: - Internal Methods

private extension CompletedTasksViewController {
	func prepareDateSet() {
		var set: Set<String> = []
		for task in tasks {
			if task.isCompleted == true {
				set.insert(task.date)
			}
		}
		sortedDates = set.sorted { $0 > $1 }
	}

	func tasksForDate(date: String) -> Results<Task> {
		let query = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "date == %@", date),
																   NSPredicate(format: "isCompleted == true")])
		return TaskManager.shared.taskList.filter(query)
	}

	func showHumanDate(_ date: String) -> String {
		let dateFormatterGet = DateFormatter()
		dateFormatterGet.dateFormat = "yyyy-MM-dd"

		let dateFormatterPrint = DateFormatter()
		dateFormatterPrint.dateFormat = "MMM dd, yyyy"

		return dateFormatterPrint.string(from: dateFormatterGet.date(from: date)!)
	}
}

// MARK: - Table View Data Source

extension CompletedTasksViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return sortedDates.count > 0 ? sortedDates.count : 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sortedDates.count > 0 ? tasksForDate(date: sortedDates[section]).count : 0
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sortedDates.count > 0 ? showHumanDate(sortedDates[section]) : "Empty"
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SomeDayListCell.identifier, for: indexPath) as! SomeDayListCell
		let tasks = tasksForDate(date: sortedDates[indexPath.section])
		cell.configureCell(with: tasks[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Constants.cellRowHeight.rawValue
	}
}

// MARK: - Table View Delegate

extension CompletedTasksViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == .delete) {
			let task = tasks[indexPath.row]
			TaskManager.shared.delete(task)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
}
