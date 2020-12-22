//
//  CompletedTasksView.swift
//  Rush It!
//
//  Created by Владислав Банков on 22.12.2020.
//

import UIKit

final class CompletedTasksView: UIView {

	// MARK: - Properties

	var tableViewDataSource: UITableViewDataSource? {
		get { tableView.dataSource }
		set (dataSource) { tableView.dataSource = dataSource }
	}

	var tableViewDelegate: UITableViewDelegate? {
		get { tableView.delegate }
		set (delegate) { tableView.delegate = delegate }
	}

	// MARK: - UI Components

	private let tableView = UITableView(frame: .zero, style: .insetGrouped)

	// MARK: - Init

	init() {
		super.init(frame: .zero)

		setupAppearance()
		setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - Appearance

private extension CompletedTasksView {
	func setupAppearance() {
		tableView.register(SomeDayListCell.self, forCellReuseIdentifier: SomeDayListCell.identifier)
	}
}

// MARK: - Layout

private extension CompletedTasksView {
	func setupLayout() {
		addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
