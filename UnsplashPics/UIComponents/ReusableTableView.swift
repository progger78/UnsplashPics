//
//  ReusableTableView.swift
//  UnsplashPics
//
//  Created by 1 on 03.03.2025.
//

import UIKit

protocol ReusableTableViewDelegate: AnyObject {
    func loadMoreData()
    func didTapCell(with user: UserForPhoto)
}

class ReusableTableView: UIView {
    
    weak var delegate: (any ReusableTableViewDelegate)?
    
    private lazy var tableView = setupTableView()
    private lazy var paginationHandler = PaginationHandler { self.delegate?.loadMoreData() }
    private var users: [UserForPhoto] = []
    var isLoading = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with users: [UserForPhoto]) {
        self.users = users
        tableView.reloadData()
    }
    
    func append(_ users: [UserForPhoto]) {
        let startIndex = self.users.count
        let endIndex = startIndex + users.count
        let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        
        self.users.append(contentsOf: users)
        
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    private func setupTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseId)
        return tableView
    }
    
    private func initialize() {
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

// MARK: - UITableViewDelegate
extension ReusableTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = users[indexPath.row]
        delegate?.didTapCell(with: item) // Теперь передаем правильную модель
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ReusableTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseId,
                                                       for: indexPath) as? UserTableViewCell
        else {
            return .init()
        }
        
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        paginationHandler.handleScroll(for: scrollView, isLoading: isLoading, hasMore: true)
    }
}
