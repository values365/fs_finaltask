//
//  CalendarView.swift
//  Rush It!
//
//  Created by Владислав Банков on 21.12.2020.
//

import UIKit
import FSCalendar

final class CalendarView: UIView {

	var delegate: FSCalendarDelegate! {
		get { calendar.delegate }
		set { calendar.delegate = newValue }
	}

	var dataSource: FSCalendarDataSource! {
		get { calendar.dataSource }
		set { calendar.dataSource = newValue }
	}

	private var calendar: FSCalendar

	init() {
		calendar = FSCalendar()
		super.init(frame: .zero)

		setupAppearance()
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

// MARK: - Appearance

private extension CalendarView {
	func setupAppearance() {
		backgroundColor = .white
		calendar.scrollDirection = .vertical
		calendar.scope = .month
		calendar.appearance.titleFont = .systemFont(ofSize: Constants.textSize.rawValue)
		calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: Constants.headerSize.rawValue)
		// calendar.a
	}
}

// MARK: - Layout

private extension CalendarView {
	func setupLayout() {
		addSubview(calendar)
		calendar.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			calendar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.regularSpacing.rawValue),
			calendar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.regularSpacing.rawValue),
			calendar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.regularSpacing.rawValue),
			calendar.heightAnchor.constraint(equalToConstant: Constants.calendarHeight.rawValue)
		])
	}
}
