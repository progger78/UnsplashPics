//
//  SuggestionTextField.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import UIKit

class SuggestionTextField: UITextField{
    
    private let tableView = UITableView()
    private var suggestions: [String] = []
    private let allSuggestions: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let superview else { return }
        
        superview.addSubview(tableView)
        updateTableViewFrame()
    }
    
    @objc private func didChangeText() {
        guard let text, !text.isEmpty else {
            suggestions = []
            tableView.isHidden = true
            return
        }
        suggestions = allSuggestions.filter({ $0.lowercased().contains(text.lowercased()) })
        tableView.isHidden = suggestions.isEmpty
        tableView.reloadData()
        updateTableViewFrame()
    }
    
    private func setupTextField() {
        setLayer(for: self, maskerCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        delegate = self
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "suggestionCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        setLayer(for: tableView, maskerCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
    
    private func setLayer(for view: UIView, maskerCorners: CACornerMask) {
        let layer = view.layer
        layer.borderWidth = 1
        layer.cornerRadius = 6
        layer.borderColor = UIColor.systemGray2.cgColor
        layer.maskedCorners = maskerCorners
    }
    
    private func updateTableViewFrame() {
        guard let superview else { return }
        
        tableView.frame = CGRect(x: frame.origin.x,
                                 y: frame.maxY,
                                 width: frame.width,
                                 height: min(150, CGFloat(suggestions.count * 44)))
        superview.bringSubviewToFront(tableView)
    }
}


extension SuggestionTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tableView.isHidden = true
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
    }
}

extension SuggestionTextField: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.text = suggestions[indexPath.row]
        tableView.isHidden = true
    }
}

extension SuggestionTextField: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath)
        cell.textLabel?.text = suggestions[indexPath.row]
        return cell
    }
}
