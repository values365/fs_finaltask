//
//  Assembly.swift
//  Rush It!
//
//  Created by Владислав Банков on 18.12.2020.
//

import UIKit

enum Assembly {
	static func makeSomeDayListModule() -> SomeDayListViewController {
		return SomeDayListViewController(with: SomeDayListPresenter())
	}

	static func makeTaskModule() -> TaskViewController {
		return TaskViewController()
	}

	static func makeRushModule() -> RushViewController {
		return RushViewController()
	}

	static func makeCalendarModule() -> CalendarViewController {
		return CalendarViewController(presenter: CalendarPresenter())
	}

	static func makeCompletedTasksModule() -> CompletedTasksViewController {
		return CompletedTasksViewController()
	}
}
