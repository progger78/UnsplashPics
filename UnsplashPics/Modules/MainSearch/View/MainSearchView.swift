//
//  MainSearchView.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import UIKit

final class MainSearchView: UIView {
    
    enum Section {
        case main
    }
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = setupCollectionView()
    lazy var dataSource: UICollectionViewDiffableDataSource<Section, UnsplashPhoto> = setupDataSource()
    private let spacing: CGFloat = 10
    
    private func setupCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        cell.configure(with: photo)
        return cell
    }
    
    func update(with photos: [UnsplashPhoto]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UnsplashPhoto>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos)
        dataSource.apply(snapshot, animatingDifferences: true)
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
        addSubview(collectionView)
    }
    
    func configureConstraints() {
        collectionView.equalToSuperview(view: self)
    }
}


extension MainSearchView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let sectionInsets: CGFloat = 10 * 2
        
        let totalSpacing = spacing * (itemsPerRow - 1) + sectionInsets
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = availableWidth / itemsPerRow
        
        return CGSize(width: itemWidth, height: 200)
    }
}
