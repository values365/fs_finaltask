//
//  SomeDayListCell.swift
//  Rush It!
//
//  Created by Владислав Банков on 19.12.2020.
//

import UIKit

final class SomeDayListCell: UITableViewCell {

	// var delegate: ISomeDayListViewController?
	var tapButtonHandler: ((Task) -> Void)?

	// MARK: - Properties

	private(set) var isItRushTaskCell = true
	static let identifier = "task-cell"
	private var task: Task!

	// MARK: - UI Components

	private let titleLabel = UILabel()
	private let subLabel = UILabel()
	private let rushButton = UIButton()

	// MARK: - Life Cycle

	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		rushButton.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configureCell(with task: Task) {
		self.task = task
		titleLabel.text = task.title
		subLabel.text = task.notes
		if task.hours == 0 && task.minutes == 0 {
			isItRushTaskCell = false
		} else { isItRushTaskCell = true }
		setupViewsAppearances()
		setupViewsLayouts()
		if task.isCompleted { makeTaskDone() }
	}
}

// MARK: - Internal Methods

private extension SomeDayListCell {
	func makeTaskDone() {
		titleLabel.attributedText = NSAttributedString(string: titleLabel.text ?? "",
													   attributes: [.strikethroughStyle: 1])
		subLabel.attributedText = NSAttributedString(string: subLabel.text ?? "",
													 attributes: [.strikethroughStyle: 1])
		rushButton.isHidden = true
	}

	@objc func touchUpInside() {
		if isItRushTaskCell {
			tapButtonHandler?(task)
		} else {
			makeTaskDone()
			TaskManager.shared.makeCompleted(task)
		}
	}
}

// MARK: - Appearance

private extension SomeDayListCell {
	func setupViewsAppearances() {
		titleLabel.font = .boldSystemFont(ofSize: Constants.headerSize.rawValue)
		subLabel.font = .systemFont(ofSize: Constants.textSize.rawValue)

		// rush button setting
		rushButton.setTitle(isItRushTaskCell ? "Rush It!" : "Done", for: UIControl.State.normal)
		rushButton.setTitleColor(.white, for: .normal)
		rushButton.backgroundColor = isItRushTaskCell ? .systemPink : UIColor(red: 0.38, green: 0.72, blue: 0.81, alpha: 1.0)
		rushButton.layer.cornerRadius = Constants.standardButtonSize.rawValue / 3.2
	}
}

// MARK: - Layout

private extension SomeDayListCell {
	func setupViewsLayouts() {

		// button setting
		addSubview(rushButton)
		rushButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			rushButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultSpacing.rawValue),
			rushButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.defaultSpacing.rawValue),
			rushButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.defaultSpacing.rawValue),
			rushButton.widthAnchor.constraint(equalToConstant: Constants.standardButtonSize.rawValue)
		])

		// title label setting
		addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: topAnchor,
											constant: Constants.defaultSpacing.rawValue),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
												constant: Constants.defaultSpacing.rawValue),
			titleLabel.trailingAnchor.constraint(equalTo: rushButton.leadingAnchor, constant: -Constants.defaultSpacing.rawValue)
		])

		// sublabel setting
		addSubview(subLabel)
		subLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.appleSpacing.rawValue),
			subLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultSpacing.rawValue),
			subLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.appleSpacing.rawValue),
			subLabel.trailingAnchor.constraint(equalTo: rushButton.leadingAnchor, constant: -Constants.defaultSpacing.rawValue)
		])
	}
}
