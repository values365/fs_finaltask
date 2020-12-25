//
//  SomeDayListView.swift
//  Rush It!
//
//  Created by Владислав Банков on 18.12.2020.
//

import UIKit

final class SomeDayListView: UIView {

	// MARK: - Properties

	var tableViewDataSource: UITableViewDataSource? {
		get { tableView.dataSource }
		set (dataSource) { tableView.dataSource = dataSource }
	}

	var tableViewDelegate: UITableViewDelegate? {
		get { tableView.delegate }
		set (delegate) { tableView.delegate = delegate }
	}

	var delegate: ISomeDayListViewController? {
		didSet {
			delegate?.navigationController?.navigationBar.backgroundColor = Color.halfAlphaTurquoiseColor
		}
	}

	var isSlideMenuPresented = false

	// MARK: - UI Components

	private let tableView = UITableView()
	private let containerView = UIView()

	private let todayButton = UIButton()
	private let tomorrowButton = UIButton()
	private let calendarButton = UIButton()
	private let completedTasksButton = UIButton()

	private lazy var menuView: UIView = {
		let view = UIView()
		configureMenuView(view)
		return view
	}()

	 private lazy var slideMenuPadding = frame.width * (1 - Constants.slideMenuWidthMultiplier.rawValue)


	// MARK: - View Init

	init() {
		super.init(frame: .zero)

		setupTableViewAppearance()
		setupTableViewLayout()
		setupTargets()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func reloadData() {
		tableView.reloadData()
	}

	func prepareSlideMenu() {
		menuView.pinMenuTo(self, with: Constants.slideMenuWidthMultiplier.rawValue)
		tableView.edgeTo(self)
	}

	func menuBarButtonItemTapped() {
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) { [weak self] in
			guard let self = self else {
				return assertionFailure("weak self link is nil")
			}
			self.tableView.frame.origin.x = self.isSlideMenuPresented ? 0 : self.tableView.frame.width - self.slideMenuPadding
		} completion: { [weak self] flag in
			guard let self = self else {
				return assertionFailure("weak self link is nil")
			}
			self.isSlideMenuPresented.toggle()
		}
	}

	func hideMenuView() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return assertionFailure("weak self link is nil") }
			sleep(1)
			self.tableView.frame.origin.x = self.isSlideMenuPresented ? 0 : self.tableView.frame.width - self.slideMenuPadding
			self.isSlideMenuPresented.toggle()
		}
	}
}

// MARK: - Internal Methods

private extension SomeDayListView {
	func configureMenuView(_ view: UIView) {
		view.backgroundColor = Color.halfAlphaDarkTurquoiseColor
		setupMenuButtonAppearances()
		setupMenuButtonLayouts(view)
	}

	func setupTargets() {
		todayButton.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)
		tomorrowButton.addTarget(self, action: #selector(tomorrowButtonTapped), for: .touchUpInside)
		calendarButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
		completedTasksButton.addTarget(self, action: #selector(completedTasksButtonTapped), for: .touchUpInside)
	}

	@objc func todayButtonTapped() {
		delegate?.tapTodayMenuButtonHandler?()
		hideMenuView()
	}

	@objc func tomorrowButtonTapped() {
		delegate?.tapTomorrowMenuButtonHandler?()
		hideMenuView()
	}

	@objc func calendarButtonTapped() {
		delegate?.tapCalendarMenuButtonHandler?()
		hideMenuView()
	}

	@objc func completedTasksButtonTapped() {
		delegate?.tapCompletedTasksMenuButtonHandler?()
		hideMenuView()
	}
}

// MARK: - Appearance

private extension SomeDayListView {

	func setupMenuButtonAppearances() {

		// today button
		guard let delegate = self.delegate else {
			return assertionFailure("delegate assigning missing error")
		}
		todayButton.setTitle("Today (\(delegate.shortDisplayingDate))", for: .normal)
		todayButton.backgroundColor = .none
		todayButton.titleLabel?.font = .systemFont(ofSize: Constants.headerSize.rawValue)
		todayButton.setTitleColor(.white, for: .normal)

		// tomorrow button
		tomorrowButton.setTitle("Plan tomorrow", for: .normal)
		tomorrowButton.backgroundColor = .none
		tomorrowButton.titleLabel?.font = .systemFont(ofSize: Constants.headerSize.rawValue)
		tomorrowButton.setTitleColor(.white, for: .normal)

		// calendar buttom
		calendarButton.setTitle("Calendar", for: .normal)
		calendarButton.backgroundColor = .none
		calendarButton.titleLabel?.font = .systemFont(ofSize: Constants.headerSize.rawValue)
		calendarButton.setTitleColor(.white, for: .normal)

		// completed tasks button
		completedTasksButton.setTitle("Completed tasks", for: .normal)
		completedTasksButton.backgroundColor = .none
		completedTasksButton.titleLabel?.font = .systemFont(ofSize: Constants.headerSize.rawValue)
		completedTasksButton.setTitleColor(.white, for: .normal)

	}

	func setupTableViewAppearance() {
		backgroundColor = Color.brightTurquoiseColor
		tableView.register(SomeDayListCell.self, forCellReuseIdentifier: SomeDayListCell.identifier)
	}
}

// MARK: - Layout

private extension SomeDayListView {

	func setupMenuButtonLayouts(_ view: UIView) {
		view.addSubview(containerView)
		containerView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9),
			containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])

		// today button
		containerView.addSubview(todayButton)
		todayButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			todayButton.topAnchor.constraint(equalTo: containerView.topAnchor),
			todayButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			todayButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			todayButton.heightAnchor.constraint(equalToConstant: Constants.standardButtonSize.rawValue)
		])

		// tomorrow button
		containerView.addSubview(tomorrowButton)
		tomorrowButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tomorrowButton.topAnchor.constraint(equalTo: todayButton.bottomAnchor),
			tomorrowButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			tomorrowButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			tomorrowButton.heightAnchor.constraint(equalToConstant: Constants.standardButtonSize.rawValue)
		])

		// calendar button
		containerView.addSubview(calendarButton)
		calendarButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			calendarButton.topAnchor.constraint(equalTo: tomorrowButton.bottomAnchor),
			calendarButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			calendarButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			calendarButton.heightAnchor.constraint(equalToConstant: Constants.standardButtonSize.rawValue)
		])

		// completed tasks button
		containerView.addSubview(completedTasksButton)
		completedTasksButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			completedTasksButton.topAnchor.constraint(equalTo: calendarButton.bottomAnchor),
			completedTasksButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			completedTasksButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			completedTasksButton.heightAnchor.constraint(equalToConstant: Constants.standardButtonSize.rawValue)
		])
	}

	func setupTableViewLayout() {
		addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		])
	}
}
