//
//  DatePickerInputView.swift
//  Bidly
//
//  Created by Baytik  on 19/4/25.
//

// DatePickerHandler.swift
import UIKit

protocol DatePickerHandlerDelegate: AnyObject {
    func didSelectDate(_ date: String)
}

final class DatePickerHandler: NSObject {
    private let textField: UITextField
    private weak var delegate: DatePickerHandlerDelegate?
    
    init(textField: UITextField, delegate: DatePickerHandlerDelegate) {
        self.textField = textField
        self.delegate = delegate
        super.init()
        
        setupDatePicker()
    }
    
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        
        if #available(iOS 13.4, *) {
            datePicker.locale = Locale(identifier: "ru_RU")
        }
        
        textField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(donePickingDate)
        )
        
        toolbar.setItems([doneButton], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func donePickingDate() {
        if let datePicker = textField.inputView as? UIDatePicker {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            let dateString = formatter.string(from: datePicker.date)
            textField.text = dateString
            delegate?.didSelectDate(dateString)
        }
        textField.resignFirstResponder()
    }
}
