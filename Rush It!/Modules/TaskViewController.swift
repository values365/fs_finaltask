//
//  TaskViewController.swift
//  Rush It!
//
//  Created by Владислав Банков on 18.12.2020.
//

import UIKit
import RealmSwift

final class TaskViewController: UIViewController {

	// MARK: - Properties

	var delegate: ISomeDayListViewController?

	private let taskView = TaskView()

	private var currentTask = Task()
	private var currentDate: String {
		return TaskManager.shared.dateToString(date: Date())
	}
	private var isItEditingMode = false

	// MARK: - Init

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
		prepareNavigationController()
    }

	override func loadView() {
		view = taskView
		guard let delegate = delegate else { return assertionFailure("couldn't get delegate(taskViewController)") }
		taskView.setDatePicker(with: delegate.viewControllerDate)
	}

	func configure(with task: Task) {
		isItEditingMode = true
		currentTask = task
		taskView.configure(with: currentTask)
	}
}

// MARK: - Internal Methods

private extension TaskViewController {
	func prepareNavigationController() {
		navigationItem.title = StringConstants.headerText.rawValue
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveTask))
		navigationController?.navigationBar.backgroundColor = Color.halfAlphaTurquoiseColor
	}

	@objc func saveTask() {
		guard let task = buildTask() else {
			return
		}
		if isItEditingMode {
			updateCurrentTask(with: task)
		} else {
			TaskManager.shared.save(task)
		}
		dismissView()
		delegate?.reloadData()
	}

	func updateCurrentTask(with task: Task) {
		guard let index = TaskManager.shared.taskList.index(of: currentTask) else {
			assertionFailure("realm ejecting object error")
			return
		}
		TaskManager.shared.update(at: index, with: task)
	}

	func buildTask() -> Task? {
		let title = taskView.getTitle()
		let notes = taskView.getNotes()
		let date = taskView.getDate()
		let time = taskView.getTimeToComplete()
		var actualTime: (Int, Int)

		if time.0.isEmpty && time.1.isEmpty {
			actualTime.0 = 0
			actualTime.1 = 0
			return Task(title: title, notes: notes, date: TaskManager.shared.dateToString(date: date), timeToComplete: actualTime)
		}
		if time.0.isEmpty { actualTime.0 = 0 } else { actualTime.0 = Int(time.0) ?? -1 }
		if time.1.isEmpty { actualTime.1 = 0 } else { actualTime.1 = Int(time.1) ?? -1 }

		if actualTime.1 > 60 || actualTime.1 < 0 || actualTime.0 > 24 || actualTime.0 < 0 {
			showWarning()
			return nil
		}

		return Task(title: title, notes: notes, date: TaskManager.shared.dateToString(date: date), timeToComplete: actualTime)
	}

	func showWarning() {
		let alert = UIAlertController(title: "Error", message: "Time value is incorrect (hour can't be more than 24)", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .cancel)
		alert.addAction(okAction)
		self.present(alert, animated: true)
	}

	@objc func dismissView() {
		dismiss(animated: true)
	}
}

