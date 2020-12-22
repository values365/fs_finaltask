//
//  SomeDayListPresenter.swift
//  Rush It!
//
//  Created by Владислав Банков on 18.12.2020.
//

import UIKit

protocol ISomeDayListPresenter {
	func viewDidLoad(with viewController: ISomeDayListViewController)
}

final class SomeDayListPresenter: ISomeDayListPresenter {
	private weak var viewController: ISomeDayListViewController?

	func viewDidLoad(with viewController: ISomeDayListViewController) {
		self.viewController = viewController

		viewController.tapCellHandler = { [weak self] task in
			guard let self = self else {
				return assertionFailure("weak self link is nil")
			}
			let nextVC = Assembly.makeTaskModule()
			nextVC.delegate = self.viewController
			nextVC.configure(with: task)
			let navigationController = UINavigationController(rootViewController: nextVC)
			self.viewController?.present(navigationController, animated: true)
		}

		viewController.tapAddButtonHandler = { [weak self] in
			guard let self = self else {
				return assertionFailure("weak self link is nil")
			}
			let nextVC = Assembly.makeTaskModule()
			nextVC.delegate = self.viewController
			let navigationController = UINavigationController(rootViewController: nextVC)
			self.viewController?.present(navigationController, animated: true)
		}

		viewController.tapRushButtonHandler = { [weak self] task in
			guard let self = self else {
				return assertionFailure("weak self link is nil")
			}
			let nextVC = Assembly.makeRushModule()
			nextVC.delegate = self.viewController
			nextVC.configure(with: task)
			self.viewController?.present(nextVC, animated: true)
		}

		viewController.tapTodayMenuButtonHandler = { [weak self] in
			guard let self = self else {
				return assertionFailure("weak self link is nil")
			}
			let nextVC = Assembly.makeSomeDayListModule()
			nextVC.configure(with: Date())
			self.viewController?.navigationController?.pushViewController(nextVC, animated: true)
		}

		viewController.tapTomorrowMenuButtonHandler = { [weak self] in
			guard let self = self else {
				return assertionFailure("weak self link is nil")
			}
			guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else {
				return assertionFailure("couldn't configure tomorrow")
			}
			let nextVC = Assembly.makeSomeDayListModule()
			nextVC.configure(with: tomorrow)
			self.viewController?.navigationController?.pushViewController(nextVC, animated: true)
		}

		viewController.tapCalendarMenuButtonHandler = { [weak self] in
			guard let self = self else {
				return assertionFailure("weak self link is nil")
			}
			let nextVC = Assembly.makeCalendarModule()
			self.viewController?.navigationController?.pushViewController(nextVC, animated: true)
		}

		viewController.tapCompletedTasksMenuButtonHandler = { [weak self] in
			guard let self = self else {
				return assertionFailure("weak self link is nil")
			}
			let nextVC = Assembly.makeCompletedTasksModule()
			self.viewController?.navigationController?.pushViewController(nextVC, animated: true)
		}
	}
}
