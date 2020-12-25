//
//  Constants.swift
//  Rush It!
//
//  Created by Владислав Банков on 18.12.2020.
//

import UIKit

enum Constants: CGFloat {
	case cellRowHeight = 78

	case headerSize = 21
	case textSize = 17
	case standardSize = 44
	case timeHeaderSize = 33
	case timerSize = 56

	case appleSpacing = 8
	case defaultSpacing = 16
	case regularSpacing = 32
	case bigSpacing = 64
	case largeSpacing = 90
	case oneHundredPoints = 100

	case standardButtonSize = 70
	case regularButtonSize = 110
	case standardButtonWidthMultiplier = 0.3

	case slideMenuWidthMultiplier = 0.55
	case menuButtonCornerRadius = 25
	case menuButtonHeightMultiplier = 0.22
	case calendarHeight = 300

}

enum StringConstants: String {
	case headerText = "New Task"
	case titlePlaceholder = "Title"
	case notesPlaceholder = "Notes"
	case rushLabelText = "🔥 Rush Task"
	case explainingLabelText = "⏱ Complete in"
	case hourPlaceholder = "HH"
	case minutePlaceholder = "MM"
	case dotsLabel = ":"

	case timeHeaderLabelText = "Concentrate now"
	case completedTasksViewTitle = "All time completed tasks"
}
