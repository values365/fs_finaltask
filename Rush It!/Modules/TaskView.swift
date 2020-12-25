//
//  TaskView.swift
//  Rush It!
//
//  Created by Владислав Банков on 18.12.2020.
//

import UIKit

final class TaskView: UIView {


	// MARK: - UI Components

	// scroll view for ipod touch and same API's (horizontal view)
	private let scrollView = UIScrollView()
	private let titleField = UITextField()
	private let notesField = UITextField()
	private let dateIcon = UIImageView()
	private let datePicker = UIDatePicker()
	private let rushLabel = UILabel()
	private let isItRushTaskSwitch = UISwitch()
	private let explainingLabel = UILabel()
	private let hourField = UITextField()
	private let dotsLabel = UILabel()
	private let minuteField = UITextField()

	// MARK: - View Init

	init() {
		super.init(frame: .zero)

		prepareSomeBehaviours()
		setupAllAppearances()
		setupAllLayouts()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func getTitle() -> String {
		return titleField.text ?? ""
	}

	func getNotes() -> String {
		return notesField.text ?? ""
	}

	func getDate() -> Date {
		return datePicker.date
	}

	func getTimeToComplete() -> (String, String) {
		return (hourField.text ?? "", minuteField.text ?? "")
	}

	func configure(with task: Task) {
		titleField.text = task.title
		notesField.text = task.notes
		datePicker.date = TaskManager.shared.stringToDate(string: task.date)
		if task.minutes == 0 && task.hours == 0 {
			isItRushTaskSwitch.isOn = false
			hideRushTaskSubComponents(true)
			return
		}
		isItRushTaskSwitch.isOn = true
		hideRushTaskSubComponents(false)
		hourField.text = String(task.hours)
		minuteField.text = String(task.minutes)
	}

	func setDatePicker(with date: Date) {
		datePicker.date = date
	}
}

// MARK: - Internal Methods

private extension TaskView {
	func prepareSomeBehaviours() {
		isItRushTaskSwitch.addTarget(self, action: #selector(switchStateDidChanged), for: .valueChanged)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
											   name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
											   name: UIResponder.keyboardWillShowNotification, object: nil)
		let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		addGestureRecognizer(tap)
		hideRushTaskSubComponents(true)
	}

	func hideRushTaskSubComponents(_ bool: Bool) {
		explainingLabel.isHidden = bool
		hourField.isHidden = bool
		dotsLabel.isHidden = bool
		minuteField.isHidden = bool
	}

	@objc func switchStateDidChanged(_ sender: UISwitch) {
		if sender.isOn == true {
			hideRushTaskSubComponents(false)
		} else {
			hourField.text = ""
			minuteField.text = ""
			hideRushTaskSubComponents(true)
		}
	}

	@objc func dismissKeyboard() {
		endEditing(true)
	}

	@objc func keyboardWillShow(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		let keyboardFrame = keyboardSize.cgRectValue
		scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -keyboardFrame.height)
			.isActive = true
	}

	@objc func keyboardWillHide(notification: NSNotification) {
		scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
		setNeedsLayout()
	}
}

// MARK: - Appearance

private extension TaskView {
	func setupAllAppearances() {
		backgroundColor = .systemBackground
		setupLabelAppearances()
		setupFieldAppearances()
		setupIconAppearance()
		setupSwitchAppearance()
	}

	func setupLabelAppearances() {
		rushLabel.text = StringConstants.rushLabelText.rawValue
		rushLabel.font = .systemFont(ofSize: Constants.textSize.rawValue)

		explainingLabel.text = StringConstants.explainingLabelText.rawValue
		explainingLabel.font = .systemFont(ofSize: Constants.textSize.rawValue)

		dotsLabel.text = StringConstants.dotsLabel.rawValue
		dotsLabel.font = .boldSystemFont(ofSize: Constants.textSize.rawValue)
	}

	func setupIconAppearance() {
		dateIcon.image = Images.date.image
	}

	func setupFieldAppearances() {
		titleField.borderStyle = .roundedRect
		titleField.placeholder = StringConstants.titlePlaceholder.rawValue

		notesField.borderStyle = .roundedRect
		notesField.placeholder = StringConstants.notesPlaceholder.rawValue

		datePicker.datePickerMode = .date

		hourField.borderStyle = .roundedRect
		minuteField.borderStyle = .roundedRect
		hourField.placeholder = StringConstants.hourPlaceholder.rawValue
		minuteField.placeholder = StringConstants.minutePlaceholder.rawValue
		hourField.textAlignment = .center
		minuteField.textAlignment = .center
		hourField.keyboardType = .asciiCapableNumberPad
		minuteField.keyboardType = .asciiCapableNumberPad
	}

	func setupSwitchAppearance() {
		isItRushTaskSwitch.setOn(false, animated: false)
	}
}

// MARK: - Layout

private extension TaskView {
	func setupAllLayouts() {

		addSubview(scrollView)
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		])

		// title field setting
		scrollView.addSubview(titleField)
		titleField.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			titleField.topAnchor.constraint(equalTo: scrollView.topAnchor,
											constant: Constants.regularSpacing.rawValue),
			titleField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
												constant: Constants.regularSpacing.rawValue),
			titleField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
												 constant: -Constants.regularSpacing.rawValue),
			titleField.heightAnchor.constraint(equalToConstant: Constants.standardSize.rawValue)

		])

		// notes field setting
		scrollView.addSubview(notesField)
		notesField.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			notesField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: Constants.regularSpacing.rawValue),
			notesField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
												constant: Constants.regularSpacing.rawValue),
			notesField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
												 constant: -Constants.regularSpacing.rawValue),
			notesField.heightAnchor.constraint(equalToConstant: Constants.standardSize.rawValue)
		])

		// date icon setting
		scrollView.addSubview(dateIcon)
		dateIcon.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			dateIcon.topAnchor.constraint(equalTo: notesField.bottomAnchor, constant: Constants.regularSpacing.rawValue),
			dateIcon.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
											  constant: Constants.regularSpacing.rawValue),
			dateIcon.heightAnchor.constraint(equalToConstant: Constants.standardSize.rawValue),
			dateIcon.widthAnchor.constraint(equalToConstant: Constants.standardSize.rawValue)
		])

		// date picker setting
		scrollView.addSubview(datePicker)
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			datePicker.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor),
			datePicker.leadingAnchor.constraint(equalTo: dateIcon.trailingAnchor, constant: Constants.defaultSpacing.rawValue)
		])

		// rush switch setting
		scrollView.addSubview(isItRushTaskSwitch)
		isItRushTaskSwitch.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			isItRushTaskSwitch.topAnchor.constraint(equalTo: dateIcon.bottomAnchor, constant: Constants.regularSpacing.rawValue),
			isItRushTaskSwitch.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.regularSpacing.rawValue)
		])

		// rush label setting
		scrollView.addSubview(rushLabel)
		rushLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			rushLabel.centerYAnchor.constraint(equalTo: isItRushTaskSwitch.centerYAnchor),
			rushLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.regularSpacing.rawValue)
		])

		// explaining label setting
		scrollView.addSubview(explainingLabel)
		explainingLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			explainingLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
													 constant:Constants.regularSpacing.rawValue),
			explainingLabel.topAnchor.constraint(equalTo: isItRushTaskSwitch.bottomAnchor,
												 constant: Constants.regularSpacing.rawValue)
		])

		// hour, minute fields and dots label setting
		scrollView.addSubview(hourField)
		scrollView.addSubview(dotsLabel)
		scrollView.addSubview(minuteField)
		hourField.translatesAutoresizingMaskIntoConstraints = false
		dotsLabel.translatesAutoresizingMaskIntoConstraints = false
		minuteField.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			hourField.centerYAnchor.constraint(equalTo: explainingLabel.centerYAnchor),
			hourField.trailingAnchor.constraint(equalTo: dotsLabel.leadingAnchor, constant: -Constants.defaultSpacing.rawValue / 2),
			hourField.widthAnchor.constraint(equalToConstant: Constants.standardSize.rawValue),
			hourField.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: -Constants.regularSpacing.rawValue),

			dotsLabel.centerYAnchor.constraint(equalTo: explainingLabel.centerYAnchor),
			dotsLabel.trailingAnchor.constraint(equalTo: minuteField.leadingAnchor, constant: -Constants.defaultSpacing.rawValue / 2),
			dotsLabel.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: -Constants.regularSpacing.rawValue),

			minuteField.centerYAnchor.constraint(equalTo: explainingLabel.centerYAnchor),
			minuteField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.regularSpacing.rawValue),
			minuteField.widthAnchor.constraint(equalToConstant: Constants.standardSize.rawValue),
			minuteField.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: -Constants.regularSpacing.rawValue),
		])
	}
}
