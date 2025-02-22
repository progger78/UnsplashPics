//
//  FavoritesView.swift
//  UnsplashPics
//
//  Created by 1 on 22.02.2025.
//

import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func didTapSearchButton()
}

class FavoritesView: UIView {
 
    weak var delegate: FavoritesViewProtocol?
    
    enum State {
        case error(errorMessage: String)
        case loading(isLoading: Bool)
        case empty
        case normal(photos: [UnsplashPhoto])
    }
    
    private let customCollectionView = ReusableCollectionView()
    private let stateView = StateView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(state: State) {
        switch state {
        case .error:
            break
        case .loading:
            break
        case .empty:
            stateView.configure(for: .empty(text: "Нет избранных, добавьте что-нибудь"))
            customCollectionView.isHidden = true
        case .normal(let photos):
            stateView.configure(for: .default)
            customCollectionView.isHidden = false
            customCollectionView.update(with: photos)
            customCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), position: .top)
        }
    }
    
    func setDelegate(delegate: FavoritesViewController) {
        customCollectionView.delegate = delegate
    }
}

private extension FavoritesView {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
    }
    
    func configureView() {
        backgroundColor = .systemBackground
        stateView.onActionButtonTap = { self.delegate?.didTapSearchButton() }
    }
    
    func embedViews() {
        addSubview(stateView)
        stateView.addSubview(customCollectionView)
    }
    
    func configureConstraints() {
        customCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
