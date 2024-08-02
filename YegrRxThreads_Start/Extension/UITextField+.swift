//
//  UITextField+.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/2/24.
//

import UIKit

extension UITextField {
    func setUI(placeholderText: String) {
        textColor = .black
        placeholder = placeholderText
        textAlignment = .center
        borderStyle = .none
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}


