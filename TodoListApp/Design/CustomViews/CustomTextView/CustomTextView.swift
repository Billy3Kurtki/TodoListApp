//
//  CustomTextView.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 27.05.2025.
//

import UIKit

final class CustomTextView: UITextView {
    
    // Properties
    var valueChanged: StringAction?
}

// MARK: - UITextViewDelegate

extension CustomTextView: UITextViewDelegate {
    
    func setupDelegate() {
        delegate = self
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        valueChanged?(textView.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        valueChanged?(textView.text)
    }
}

