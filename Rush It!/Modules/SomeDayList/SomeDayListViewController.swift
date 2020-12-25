//
//  SomeDayListViewController.swift
//  Rush It!
//
//  Created by Владислав Банков on 18.12.2020.
//

import UIKit
import RealmSwift

protocol ISomeDayListViewController: UIViewController {
	var tapAddButtonHandler: (() -> Void)? { get set }
	var tapCellHandler: ((Task) -> Void)? { get set }
	var tapRushButtonHandler: ((Task) -> Void)? { get set }
	var tapTodayMenuButtonHandler: (() -> Void)? { get set }
	var tapTomorrowMenuButtonHandler: (() -> Void)? { get set }
	var tapCalendarMenuButtonHandler: (() -> Void)? { get set }
	var tapCompletedTasksMenuButtonHandler: (() -> Void)? { get set }

	var shortDisplayingDate: String { get }
	var viewControllerDate: Date { get }
	func reloadData()
}

final class SomeDayListViewController: UIViewController {

	var tapAddButtonHandler: (() -> Void)?
	var tapCellHandler: ((Task) -> Void)?
	var tapRushButtonHandler: ((Task) -> Void)?
	var tapTodayMenuButtonHandler: (() -> Void)?
	var tapTomorrowMenuButtonHandler: (() -> Void)?
	var tapCalendarMenuButtonHandler: (() -> Void)?
	var tapCompletedTasksMenuButtonHandler: (() -> Void)?

	// MARK: - Properties

	private var tasks: Results<Task> {
		TaskManager.shared.taskList.filter("date == %@", desiredDate)
	}

	private var desiredDate = ""

	private var currentDate: String {
		TaskManager.shared.dateToString(date: Date())
	}

	private var displayingDate: String {
		let dateFormatterGet = DateFormatter()
		dateFormatterGet.dateFormat = "yyyy-MM-dd"

		let dateFormatterPrint = DateFormatter()
		dateFormatterPrint.dateFormat = "MMM dd, yyyy"

		return dateFormatterPrint.string(from: dateFormatterGet.date(from: desiredDate)!)
	}

	var shortDisplayingDate: String {
		let dateFormatterGet = DateFormatter()
		dateFormatterGet.dateFormat = "yyyy-MM-dd"

		let dateFormatterPrint = DateFormatter()
		dateFormatterPrint.dateFormat = "dd.MM"

		return dateFormatterPrint.string(from: dateFormatterGet.date(from: currentDate)!)
	}

	var viewControllerDate: Date {
		TaskManager.shared.stringToDate(string: desiredDate)
	}

	lazy var menuBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading")?.withRenderingMode(.alwaysOriginal),
												 style: .done,  target: self, action: #selector(menuBarButtonItemTapped))

	private var presenter: ISomeDayListPresenter
	private var addButton: UIBarButtonItem!
	private let someDayListView = SomeDayListView()

	// MARK: - Init

	init(with presenter: ISomeDayListPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		self.desiredDate = currentDate
		addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
		presenter.viewDidLoad(with: self)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Life Cycle

	override func loadView() {
		view = someDayListView
		someDayListView.tableViewDataSource = self
		someDayListView.tableViewDelegate = self
		someDayListView.delegate = self
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		prepareNavigationController()
		someDayListView.prepareSlideMenu()
	}

	// MARK: - Public Methods

	func configure(with date: Date) {
		desiredDate = TaskManager.shared.dateToString(date: date)
	}

}

// MARK: - Internal Methods

private extension SomeDayListViewController {
	func prepareNavigationController() {
		navigationItem.title = displayingDate
		addButton.tintColor = .systemRed
		menuBarButtonItem.tintColor = .systemRed
		navigationItem.rightBarButtonItem = addButton
		navigationItem.leftBarButtonItem = menuBarButtonItem
	}

	@objc func addNewTask() {
		tapAddButtonHandler?()
	}

	@objc func menuBarButtonItemTapped() {
		someDayListView.menuBarButtonItemTapped()
	}
}

// MARK: - Table View Data Source

extension SomeDayListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tasks.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SomeDayListCell.identifier, for: indexPath) as! SomeDayListCell
		cell.configureCell(with: tasks[indexPath.row])
		if cell.isItRushTaskCell {
			cell.tapButtonHandler = tapRushButtonHandler
		}
		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Constants.cellRowHeight.rawValue
	}
}

// MARK: - Table View Delegate

extension SomeDayListViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tapCellHandler?(tasks[indexPath.row])
	}

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

// MARK: - ISomeDayListViewController

extension SomeDayListViewController: ISomeDayListViewController {
	func reloadData() {
		someDayListView.reloadData()
	}
}
