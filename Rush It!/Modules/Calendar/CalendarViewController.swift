//
//  CalendarViewController.swift
//  Rush It!
//
//  Created by Владислав Банков on 21.12.2020.
//

import UIKit
import RealmSwift
import FSCalendar

protocol ICalendarViewController: UIViewController {
	var tapDateHandler: ((Date) -> Void)? { get set }
}

final class CalendarViewController: UIViewController {

	// MARK: - Properties

	var tapDateHandler: ((Date) -> Void)?

	private var presenter: ICalendarPresenter
	private var calendarView = CalendarView()
	private var selectedDate = ""

	private var tasks: Results<Task> {
		return TaskManager.shared.taskList
	}

	// MARK: - Init

	init(presenter: ICalendarPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		self.presenter.viewDidLoad(with: self)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
		calendarView.delegate = self
		calendarView.dataSource = self
    }

	override func loadView() {
		view = calendarView
	}
}

// MARK: - Calendar Data Source

extension CalendarViewController: FSCalendarDataSource {
	func minimumDate(for calendar: FSCalendar) -> Date {
		return Date()
	}

	func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
		let date = TaskManager.shared.dateToString(date: date)
		let dateArray = tasks.filter("date == %@", date)
		return dateArray.count
	}
}

// MARK: - Calendar Delegate

extension CalendarViewController: FSCalendarDelegate {
	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		tapDateHandler?(date)
	}
}

extension CalendarViewController: ICalendarViewController {}
