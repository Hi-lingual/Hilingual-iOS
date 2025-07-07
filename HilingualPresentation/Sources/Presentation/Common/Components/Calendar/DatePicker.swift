//
//  DatePicker.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/8/25.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        if #available(iOS 17.4, *) {
            datePicker.datePickerMode = .yearAndMonth
        }
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.center = view.center
        view.addSubview(datePicker)
    }
}

@available(iOS 17.0, *)
#Preview {
    ViewController()
}

