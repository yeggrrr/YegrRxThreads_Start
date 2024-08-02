//
//  UIDatePicker+.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/2/24.
//

import UIKit

extension UIDatePicker {
    func setUI() {
        datePickerMode = .date
        preferredDatePickerStyle = .wheels
        locale = Locale(identifier: "ko-KR")
        maximumDate = Date()
    }
}
