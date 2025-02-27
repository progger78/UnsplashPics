//
//  UserCollectionsViewController.swift
//  UnsplashPics
//
//  Created by 1 on 24.02.2025.
//

import UIKit

protocol UserCollectionsViewControllerDelegate: AnyObject {
    func loadMoreCollections()
    func didTapCell(with collection: UserCollection)
}

class UserCollectionsViewController: UIViewController {

    weak var delegate: UserCollectionsViewControllerDelegate?
    
    private lazy var tableView = setupTableView()
    private lazy var paginationHandler = PaginationHandler { self.delegate?.loadMoreCollections() }
    private var collections: [UserCollection] = []
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    func update(with collections: [UserCollection]) {
        self.collections = collections
    }
    
    func append(_ collections: [UserCollection]) {
        let startIndex = self.collections.count
        let endIndex = startIndex + collections.count
        let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        
        self.collections.append(contentsOf: collections)
        
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func setupTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCollectionTableViewCell.self,
                           forCellReuseIdentifier: UserCollectionTableViewCell.reuseId)
        
        return tableView
    }
}

private extension UserCollectionsViewController {
    func initialize() {
        embedViews()
        configureConstraints()
    }
    
    func embedViews() {
        view.addSubview(tableView)
    }
    
    func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension UserCollectionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userCollection = collections[indexPath.row]
        delegate?.didTapCell(with: userCollection)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserCollectionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCollectionTableViewCell.reuseId, 
                                                       for: indexPath) as? UserCollectionTableViewCell
        else {
            return .init()
        }
        
        let collection = collections[indexPath.row]
        cell.configure(with: collection)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        paginationHandler.handleScroll(for: scrollView, isLoading: isLoading, hasMore: true)
    }
}
