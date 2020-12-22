//
//  RushView.swift
//  Rush It!
//
//  Created by Владислав Банков on 21.12.2020.
//

import UIKit

final class RushView: UIView {

	// MARK: - Properties

	var delegate: RushViewController!

	private var isLayoutCompact = true
	private var sharedConstraints: [NSLayoutConstraint] = []
	private var compactConstraints: [NSLayoutConstraint] = []
	private var regularConstraints: [NSLayoutConstraint] = []

	// MARK: - UI Components

	private let headerLabel = UILabel()
	private let timeLabel = UILabel()
	private let doneButton = UIButton()
	private let pauseButton = UIButton()

	// MARK: - Init

	init() {
		super.init(frame: .zero)

		setTargets()
		setupAppearances()
		setupLayouts()
		changeViewsLayout(traitCollection: traitCollection)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Change Cycle

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		changeViewsLayout(traitCollection: traitCollection)
	}

	// MARK: - Public Methods

	func setLabel(_ time: String) {
		timeLabel.text = time
	}

	func updateAppearance() {
		pauseButton.setTitle(delegate.isTimerOn ? "Pause" : "Resume", for: .normal)
		setNeedsLayout()
	}
}

// MARK: - Internal Methods

private extension RushView {
	func setTargets() {
		doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
		pauseButton.addTarget(self, action: #selector(toggle), for: .touchUpInside)
	}

	@objc func toggle() {
		delegate.startTimer()
	}

	@objc func done() {
		delegate.makeTaskDone()
	}
}

// MARK: - Appearance

private extension RushView {
	func setupAppearances() {
		backgroundColor = Color.someLightTurquoiseColor
		headerLabel.font = .boldSystemFont(ofSize: Constants.timeHeaderSize.rawValue)
		headerLabel.textColor = .white
		headerLabel.text = StringConstants.timeHeaderLabelText.rawValue
		timeLabel.font = .boldSystemFont(ofSize: Constants.timerSize.rawValue)
		timeLabel.textColor = .white

		doneButton.setTitle("Done", for: .normal)
		doneButton.backgroundColor = Color.someDarkTurquoiseColor
		pauseButton.setTitle("Pause", for: .normal)
		pauseButton.backgroundColor = Color.someDarkTurquoiseColor
		doneButton.layer.cornerRadius = Constants.standardButtonSize.rawValue / 2
		pauseButton.layer.cornerRadius = Constants.standardButtonSize.rawValue / 2

	}
}

// MARK: - Shared Layout

private extension RushView {
	func changeViewsLayout(traitCollection: UITraitCollection) {
		switch(traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {
		case (.compact, .regular):
			isLayoutCompact = true
			NSLayoutConstraint.deactivate(regularConstraints)
			NSLayoutConstraint.activate(compactConstraints)
		default:
			guard isLayoutCompact != false else { return }
			isLayoutCompact = false
			NSLayoutConstraint.deactivate(compactConstraints)
			NSLayoutConstraint.activate(regularConstraints)
		}
	}

	func setupLayouts() {
		setupSharedLayout()
		setupCompactLayout()
		setupRegularLayout()
	}

	func setupSharedLayout() {
		addSubview(headerLabel)
		headerLabel.translatesAutoresizingMaskIntoConstraints = false
		sharedConstraints.append(contentsOf: [
			headerLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
		])

		addSubview(timeLabel)
		timeLabel.translatesAutoresizingMaskIntoConstraints = false
		sharedConstraints.append(contentsOf: [
			timeLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
		])

		addSubview(doneButton)
		addSubview(pauseButton)
		doneButton.translatesAutoresizingMaskIntoConstraints = false
		pauseButton.translatesAutoresizingMaskIntoConstraints = false
		sharedConstraints.append(contentsOf: [
			doneButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.regularSpacing.rawValue),
			doneButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.largeSpacing.rawValue),
			doneButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor,
											  multiplier: Constants.standardButtonWidthMultiplier.rawValue),
			doneButton.heightAnchor.constraint(equalToConstant: Constants.standardButtonSize.rawValue),

			pauseButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.regularSpacing.rawValue),
			pauseButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.largeSpacing.rawValue),
			pauseButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor,
											   multiplier: Constants.standardButtonWidthMultiplier.rawValue),
			pauseButton.heightAnchor.constraint(equalToConstant: Constants.standardButtonSize.rawValue)
		])

		NSLayoutConstraint.activate(sharedConstraints)
	}
}

// MARK: - Compact Layout

private extension RushView {
	func setupCompactLayout() {
		compactConstraints.append(contentsOf: [

			// header label
			headerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.bigSpacing.rawValue),

			// time label
			timeLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -Constants.largeSpacing.rawValue)
		])
	}
}

// MARK: - Regular Layout

private extension RushView {
	func setupRegularLayout() {
		regularConstraints.append(contentsOf: [

			// header label
			headerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.regularSpacing.rawValue),

			// time label
			timeLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
		])
	}
}
