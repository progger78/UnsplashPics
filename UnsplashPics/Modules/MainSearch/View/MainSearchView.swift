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
    let spacing: CGFloat = 10
    
    func setupCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        return collectionView
    }
    
    private func setupDataSource() -> UICollectionViewDiffableDataSource<Section, UnsplashPhoto> {
        return UICollectionViewDiffableDataSource<Section, UnsplashPhoto>(collectionView: collectionView) { collectionView, indexPath, photo in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
            cell.backgroundColor = .green
            return cell
        }
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
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}


extension MainSearchView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let sectionInsets: CGFloat = 10 * 2
        
        let totalSpacing = spacing * (itemsPerRow - 1) + sectionInsets
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = availableWidth / itemsPerRow
        
        return CGSize(width: itemWidth, height: 160)
        
    }
}
