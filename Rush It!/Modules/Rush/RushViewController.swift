//
//  RushViewController.swift
//  Rush It!
//
//  Created by Владислав Банков on 21.12.2020.
//

import UIKit

final class RushViewController: UIViewController {

	var delegate: ISomeDayListViewController?

	private let rushView = RushView()

	private var timer = Timer()
	private(set) var isTimerOn = false
	private var timeRemaining = 0
	private var resetTime = 0
	private var task: Task!
	private var currentBackgroundDate = Date()

	init() {
		super.init(nibName: nil, bundle: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(pauseApp),
											   name: UIApplication.didEnterBackgroundNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(resumeApp),
											   name: UIApplication.didBecomeActiveNotification, object: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func loadView() {
		view = rushView
		rushView.delegate = self
		resetTimer()
		startTimer()
	}

	func configure(with task: Task) {
		self.task = task
		timeRemaining = task.hours * 60 * 60 + task.minutes * 60
		resetTime = timeRemaining
		rushView.setLabel(timeString(time: TimeInterval(timeRemaining)))
	}

	func makeTaskDone() {
		TaskManager.shared.makeCompleted(task)
		dismiss(animated: true)
		delegate?.reloadData()
	}

	func resetTimer() {
		timer.invalidate()
		timeRemaining = resetTime
		isTimerOn = false
	}

	@objc func startTimer() {
		if !isTimerOn {
			timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning),
										 userInfo: nil, repeats: true)
			isTimerOn = true
		} else {
			timer.invalidate()
			isTimerOn = false
		}
		rushView.updateAppearance()
	}
}

// MARK: - Internal Methods

private extension RushViewController {
	@objc func timerRunning() {
		if timeRemaining < 1 {
			timer.invalidate()
		} else {
			timeRemaining -= 1
			rushView.setLabel(timeString(time: TimeInterval(timeRemaining)))
		}
	}

	func timeString(time:TimeInterval) -> String {
		let hours = Int(time) / 3600
		let minutes = Int(time) / 60 % 60
		let seconds = Int(time) % 60
		return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
	}

	@objc func resumeApp() {
		let difference = round(currentBackgroundDate.timeIntervalSince(Date()))
		timeRemaining += Int(difference)
		rushView.setLabel(timeString(time: TimeInterval(timeRemaining)))
		isTimerOn = false
		startTimer()
	}

	@objc func pauseApp() {
		timer.invalidate()
		currentBackgroundDate = Date()
	}
}
