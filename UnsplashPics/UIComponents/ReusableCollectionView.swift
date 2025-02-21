//
//  ReusableCollectionView.swift
//  UnsplashPics
//
//  Created by 1 on 20.02.2025.
//

import UIKit

protocol ReusableCollectionViewDelegate: AnyObject {
    func didTapCell(with photo: UnsplashPhoto)
    func fetchMorePhotos()
    func dismissKeyboard()
}

class ReusableCollectionView: UIView {

    weak var delegate: ReusableCollectionViewDelegate?
    
    enum Section {
        case main
    }
    
    enum ItemSize {
        case big
        case small
    }
    
    enum State {
        case loading
        case error
        case loaded
    }
    
    private let spacing: CGFloat = 10
    private lazy var collectionView: UICollectionView = setupCollectionView()
    private lazy var paginationHandler = PaginationHandler(threshold: 140) { self.delegate?.fetchMorePhotos() }
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, UnsplashPhoto> = setupDataSource()
    private var itemSize: ItemSize = .small
    var isLoading = false
    
    init() {
        super.init(frame: .zero)
        initialize()
        collectionView.dataSource = dataSource
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
    
    func toggleItemSize() {
        itemSize = (itemSize == .small) ? .big : .small
        collectionView.reloadData()
    }
    
    func appendPhotos(_ newPhotos: [UnsplashPhoto]) {
        var snapshot = dataSource.snapshot()
        let existingIds = Set(snapshot.itemIdentifiers.map { $0.id })
        let uniquePhotos = newPhotos.filter { !existingIds.contains($0.id) }
        guard !uniquePhotos.isEmpty else { return }
        
        snapshot.appendItems(uniquePhotos)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func update(with photos: [UnsplashPhoto]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UnsplashPhoto>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
  
    func scrollToItem(at indexPath: IndexPath, position: UICollectionView.ScrollPosition) {
        collectionView.scrollToItem(at: indexPath, at: position, animated: true)
    }
}

extension ReusableCollectionView: UICollectionViewDelegateFlowLayout {
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
            delegate?.didTapCell(with: photo)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.dismissKeyboard()
        
        paginationHandler.handleScroll(for: scrollView, isLoading: isLoading, hasMore: true)
    }
}

private extension ReusableCollectionView {
    func initialize() {
        embedViews()
        configureConstraints()
        
    }
    
    func embedViews() {
        addSubview(collectionView)
    }
    
    func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
