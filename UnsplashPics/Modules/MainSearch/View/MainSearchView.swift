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
    func reloadData()
}

final class MainSearchView: UIView {
    
    enum State {
        case error(errorMessage: String)
        case loading(isLoading: Bool)
        case empty
        case normal(photos: [UnsplashPhoto])
    }
    
    weak var delegate: (any MainSearchViewProtocol)?
    
    private let customCollectionView = ReusableCollectionView()
    private let stateView = StateView()
    private let suggestionTextField = SuggestionTextField()
    private let menu = CustomMenu()
    
    init() {
        super.init(frame: .zero)
        initialize()
        customCollectionView.delegate = self
        stateView.onReloadTap = { self.delegate?.reloadData() }
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
        case .error(let errorMessage):
            stateView.configure(for: .error(errorText: errorMessage))
            customCollectionView.isHidden = true
        case .loading(let isLoading):
            stateView.configure(for: .loading(isLoading: isLoading))
        case .empty:
            stateView.configure(for: .empty(text: "Фото не найдены"))
            customCollectionView.isHidden = true
        case .normal(let photos):
            stateView.configure(for: .default)
            customCollectionView.isHidden = false
            update(photos: photos)
            customCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), position: .top)
        }
    }
    
    func focusTextFild() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { self.suggestionTextField.becomeFirstResponder() }
    }
}

private extension MainSearchView {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
        customCollectionView.dismissKeyboard = { self.endEditing(true) }
    }
    
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func embedViews() {
        stateView.addSubviews(customCollectionView)
        addSubviews(stateView, suggestionTextField)
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
        
        stateView.snp.makeConstraints { make in
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
}
