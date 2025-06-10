//
//  UIViewController.swift
//  Bidly
//
//  Created by Baytik  on 30/5/25.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, button: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button, style: .default))
        present(alert, animated: true)
    }
    
    func showLoader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...\n\n", preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        alert.view.addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            indicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20)
        ])
        present(alert, animated: true)
        return alert
    }
}
