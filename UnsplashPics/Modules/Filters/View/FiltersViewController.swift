//
//  FiltersViewController.swift
//  UnsplashPics
//
//  Created by 1 on 12.02.2025.
//

import UIKit
import SnapKit

class FiltersViewController: UIViewController {
   
    lazy var collectionView = setupCollectionView()
    
    let filtersService = FiltersService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func setupCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return FiltersLayoutFabric.createFilterSection()
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(FilterCollectionViewCell.self,
                                forCellWithReuseIdentifier: FilterCollectionViewCell.reuseId)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderView.reuseId)
        
        return collectionView
    }
}

private extension FiltersViewController {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
        
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    func embedViews() {
        view.addSubview(collectionView)
    }
    
    func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension FiltersViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filtersService.filtersCount
    }
}

extension FiltersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = filtersService.section(for: section) else { return 0 }
        
        switch section {
        case .topics:
            return filtersService.topicsCount
        case .order:
            return filtersService.orderCount
        case .orientation:
            return filtersService.orientationCount
        case .colors:
            return filtersService.colorsCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = filtersService.section(for: indexPath.section) else { return .init() }
        
        let cell = collectionView.deque(in: collectionView,
                                        of: FilterCollectionViewCell.self,
                                        reuseId: FilterCollectionViewCell.reuseId,
                                        indexPath: indexPath)
        
        let data = filtersService.configure(section: section, for: indexPath.item)
        
        if section == .colors, let color = data.color {
            cell.configure(label: nil, with: color)
        } else {
            cell.configure(label: data.title)
        }
        return cell
    }
}

extension FiltersViewController {
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = filtersService.section(for: indexPath.section) else { return .init() }
        
        let header = collectionView.deque(in: collectionView,
                                          of: HeaderView.self,
                                          kind: UICollectionView.elementKindSectionHeader,
                                          reuseId: HeaderView.reuseId,
                                          indexPath: indexPath)
        switch section {
        case .topics:
            header.configure(with: "Темы")
        case .order:
            header.configure(with: "Порядок")
        case .orientation:
            header.configure(with: "Ориентация")
        case .colors:
            header.configure(with: "Цвета")
        }
        return header
    }
}
