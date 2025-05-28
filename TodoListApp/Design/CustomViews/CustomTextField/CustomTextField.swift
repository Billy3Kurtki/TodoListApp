//
//  CustomTextField.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 27.05.2025.
//

import UIKit

typealias StringAction = (String) -> Void

final class CustomTextField: UITextField {
    
    // Properties
    var valueChanged: StringAction?
}

extension CustomTextField: UITextFieldDelegate {
    
    func setupDelegate() {
        delegate = self
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        valueChanged?(string)
        return true
    }
}
