//
//  UIViewController+.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/2/24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, okText: String, completionHander: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: okText, style: .default) { _ in
            completionHander()
        }
        
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    // 만나이 계산기 (17세 기준)
    func getDifferenceDays(year: Int, month: Int, day: Int) -> Bool {
        let dateComponents = DateComponents(year: year, month: month, day: day)
        if let startDate = Calendar.current.date(from: dateComponents) {
            let diffBetweenTwoDates = Calendar.current.dateComponents([.day], from: startDate, to: Date())
            if let differenceDay = diffBetweenTwoDates.day {
                return differenceDay >= 365 * 17
            }
        }
        
        return false
    }
}
