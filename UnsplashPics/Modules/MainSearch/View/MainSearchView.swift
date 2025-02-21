//
//  MainSearchView.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import UIKit

protocol MainSearchViewProtocol: AnyObject {
    func didTapCell(in view: UIView, photo: UnsplashPhoto)
    func loadMorePhotos()
}

final class MainSearchView: UIView {
    
    enum State {
        case error
        case loading(isLoading: Bool)
        case empty
        case normal(photos: [UnsplashPhoto])
    }
    
    weak var delegate: (any MainSearchViewProtocol)?
    
    private let customCollectionView = ReusableCollectionView()
    private let emptyStateView = EmptyStateView(message: "Фото не найдено")
    private let loadingIndicator = LoadingIndicator()
    private let suggestionTextField = SuggestionTextField()
    private let menu = CustomMenu()
    
    init() {
        super.init(frame: .zero)
        initialize()
        customCollectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegate(_ delegate: SuggestionTextFieldDelegate) {
        suggestionTextField.searchDelegate = delegate
    }
    
    func configureNavBar(with navItem: UINavigationItem) {
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: setupMenu())
    }
    
    func update(photos: [UnsplashPhoto]) {
        customCollectionView.update(with: photos)
    }
    
    func appendPhotos(photos: [UnsplashPhoto]) {
        customCollectionView.appendPhotos(photos)
    }
    
    func set(state: State) {
        switch state {
        case .error:
            print("error")
        case .loading(let isLoading):
            emptyStateView.isHidden = true
            loadingIndicator.animate(isLoading: isLoading)
        case .empty:
                self.customCollectionView.isHidden = true
                self.loadingIndicator.animate(isLoading: false)
            DispatchQueue.main.async { self.emptyStateView.isHidden = false }
        case .normal(let photos):
            customCollectionView.isHidden = false
            emptyStateView.isHidden = true
            loadingIndicator.animate(isLoading: false)
            update(photos: photos)
            customCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), position: .top)
        }
    }
}

private extension MainSearchView {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
    }
    
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func embedViews() {
        addSubviews(customCollectionView, emptyStateView, suggestionTextField, loadingIndicator)
        emptyStateView.isHidden = true
    }
    
    func configureConstraints() {
        customCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(suggestionTextField.snp.bottom).offset(10)
        }
        
        suggestionTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(safeAreaLayoutGuide).offset(5)
            make.height.equalTo(50)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(suggestionTextField.snp.bottom)
        }
    }
    
    func setupMenu() -> UIMenu {
        menu.onOrderChangeTap = { self.customCollectionView.toggleItemSize() }
        return menu.createMenu()
    }
}

extension MainSearchView: ReusableCollectionViewDelegate {
    func didTapCell(with photo: UnsplashPhoto) {
        delegate?.didTapCell(in: self, photo: photo)
    }
    
    func fetchMorePhotos() {
        delegate?.loadMorePhotos()
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }
}
