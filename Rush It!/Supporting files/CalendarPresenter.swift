//
//  CalendarPresenter.swift
//  Rush It!
//
//  Created by Владислав Банков on 21.12.2020.
//

import Foundation

protocol ICalendarPresenter {
	func viewDidLoad(with viewController: ICalendarViewController)
}

final class CalendarPresenter: ICalendarPresenter {

	private weak var viewController: ICalendarViewController?

	func viewDidLoad(with viewController: ICalendarViewController) {
		self.viewController = viewController
		viewController.tapDateHandler = { [weak self] date in
			guard let self = self else {
				return assertionFailure("weak self link is nil")
			}
			let nextVC = Assembly.makeSomeDayListModule()
			nextVC.configure(with: date)
			self.viewController?.navigationController?.pushViewController(nextVC, animated: true)
		}
	}
}
