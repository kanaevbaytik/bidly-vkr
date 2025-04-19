//
//  DropdownSelector.swift
//  Bidly
//
//  Created by Baytik  on 19/4/25.
//

import UIKit

protocol DropdownHandlerDelegate: AnyObject {
    func didSelectItem(_ item: String)
}

final class DropdownHandler: NSObject {
    private let textField: UITextField
    private let tableView = UITableView()
    private let items: [String]
    private weak var delegate: DropdownHandlerDelegate?
    private weak var parentView: UIView?
    private let dropdownArrow = UIImageView()
    
    private var isDropdownVisible = false
    
    init(textField: UITextField,
         items: [String],
         parentView: UIView,
         delegate: DropdownHandlerDelegate) {
        self.textField = textField
        self.items = items
        self.parentView = parentView
        self.delegate = delegate
        super.init()
        
        setupDropdown()
        setupDropdownArrow()
    }
    
    private func setupDropdown() {
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        parentView?.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            tableView.heightAnchor.constraint(equalToConstant: 0)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        textField.addGestureRecognizer(tapGesture)
        textField.isUserInteractionEnabled = true
    }
    
    private func setupDropdownArrow() {
        dropdownArrow.image = UIImage(systemName: "chevron.right")
        dropdownArrow.tintColor = .gray
        dropdownArrow.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(dropdownArrow)
        
        NSLayoutConstraint.activate([
            dropdownArrow.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            dropdownArrow.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -12),
            dropdownArrow.widthAnchor.constraint(equalToConstant: 12),
            dropdownArrow.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    @objc private func handleTap() {
        toggleDropdown()
    }
    
    func toggleDropdown() {
        isDropdownVisible.toggle()
        
        if isDropdownVisible {
            tableView.isHidden = false
            rotateArrow(down: true)
            UIView.animate(withDuration: 0.3) {
                self.tableView.constraints.first { $0.firstAttribute == .height }?.constant = CGFloat(self.items.count * 44)
                self.parentView?.layoutIfNeeded()
            }
        } else {
            hideDropdown()
        }
    }
    
    private func hideDropdown() {
        isDropdownVisible = false
        rotateArrow(down: false)
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.constraints.first { $0.firstAttribute == .height }?.constant = 0
            self.parentView?.layoutIfNeeded()
        }) { _ in
            self.tableView.isHidden = true
        }
    }
    
    private func rotateArrow(down: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.dropdownArrow.transform = down ? CGAffineTransform(rotationAngle: .pi/2) : .identity
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DropdownHandler: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        textField.text = selectedItem
        delegate?.didSelectItem(selectedItem)
        hideDropdown()
    }
}
