//
//  UIButton+.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/2/24.
//

import UIKit

extension UIButton {
    func setUI(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .black
        layer.cornerRadius = 10
    }
}
