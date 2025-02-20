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
    
    weak var delegate: (any MainSearchViewProtocol)?
    
    enum Section {
        case main
    }
    
    enum ItemSize {
        case big
        case small
    }
    
    private let customCollectionView = ReusableCollectionView(state: .loading)
    private let loadingIndicator = LoadingIndicator()
    private let suggestionTextField = SuggestionTextField()
    private let menu = CustomMenu()
    
    var isLoading = false {
        didSet {
            loadingIndicator.animate(isLoading: isLoading)
        }
    }
    private let spacing: CGFloat = 10
    private lazy var collectionView: UICollectionView = setupCollectionView()
    private lazy var paginationHandler = PaginationHandler { self.fetchMorePhotos() }
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, UnsplashPhoto> = setupDataSource()
    private var itemSize: ItemSize = .small
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MainSearchCollectionViewCell.self,
                                forCellWithReuseIdentifier: MainSearchCollectionViewCell.reuseId)
        collectionView.delegate = self
        return collectionView
    }
    
    private func setupDataSource() -> UICollectionViewDiffableDataSource<Section, UnsplashPhoto> {
        return UICollectionViewDiffableDataSource<Section, UnsplashPhoto>(collectionView: collectionView) {
            collectionView,
            indexPath,
            photo in
            return self.createCell(for: collectionView, indexPath: indexPath, with: photo)
        }
    }
    
    private func createCell(for collectionView: UICollectionView,
                            indexPath: IndexPath,
                            with photo: UnsplashPhoto) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSearchCollectionViewCell.reuseId,
                                                            for: indexPath) as? MainSearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        let photoHeight: CGFloat = (itemSize == .big) ? 250 : 150
        cell.configure(with: photo, photoHeight: photoHeight)
        return cell
    }
    
    private func dismissKeyboard() {
        endEditing(true)
    }
    
    func fetchMorePhotos() {
        delegate?.loadMorePhotos()
    }
    
    func appendPhotos(_ newPhotos: [UnsplashPhoto]) {
        var snapshot = dataSource.snapshot()
        
        let uniquePhotos = newPhotos.filter { !snapshot.itemIdentifiers.contains($0) }
        guard !uniquePhotos.isEmpty else { return }
        
        snapshot.appendItems(newPhotos, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func update(with photos: [UnsplashPhoto]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UnsplashPhoto>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setDelegate(_ delegate: SuggestionTextFieldDelegate) {
        suggestionTextField.searchDelegate = delegate
    }
    
    func configureNavBar(with navItem: UINavigationItem) {
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: setupMenu())
    }
}

private extension MainSearchView {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
        collectionView.dataSource = dataSource
    }
    
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func embedViews() {
        addSubviews(collectionView, suggestionTextField, loadingIndicator)
    }
    
    func configureConstraints() {
        collectionView.snp.makeConstraints { make in
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
    }
    
    func setupMenu() -> UIMenu {
        menu.onOrderChangeTap = { self.toggleItemSize() }
        return menu.createMenu()
    }
    
    
    func toggleItemSize() {
        itemSize = (itemSize == .small) ? .big : .small
        collectionView.reloadData()
    }
}
//
//extension MainSearchView: ReusableCollectionViewDelegate {
//    func didTapCell(with photo: UnsplashPhoto) {
//        delegate?.didTapCell(in: self, photo: photo)
//    }
//}

extension MainSearchView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemsPerRow: CGFloat
        var height: CGFloat
        
        switch itemSize {
        case .small:
            itemsPerRow = 2
            height = 250
        case .big:
            itemsPerRow = 1
            height = 350
        }
        let sectionInsets: CGFloat = 10 * 2
        
        let totalSpacing = spacing * (itemsPerRow - 1) + sectionInsets
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = availableWidth / itemsPerRow
        
        return CGSize(width: itemWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let photo = dataSource.itemIdentifier(for: indexPath) {
            delegate?.didTapCell(in: self, photo: photo)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard()
        
        paginationHandler.handleScroll(for: scrollView, isLoading: isLoading, hasMore: true)
    }
    
}
