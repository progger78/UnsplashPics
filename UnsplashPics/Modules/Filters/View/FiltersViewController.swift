//
//  FiltersViewController.swift
//  UnsplashPics
//
//  Created by 1 on 12.02.2025.
//

import UIKit
import SnapKit

protocol FiltersViewControllerProtocol: AnyObject {
    func didSelectOptions(_ options: [FilterModel.Section: URLQueryItem])
}

class FiltersViewController: UIViewController {
    
    
    let filtersService = FiltersService()
    let confirmButton = CustomButton(type: .iconWithText,
                                     title: "Подтвердить",
                                     icon: .checkmark,
                                     mainColor: .systemPink)
    
    weak var delegate: FiltersViewControllerProtocol?
    lazy var collectionView = setupCollectionView()

    var selectedFilters: [FilterModel.Section: URLQueryItem] = [:] {
        didSet {
            if selectedFilters.isEmpty {
                confirmButton.state = .disabled
            } else {
                confirmButton.state = .normal
            }
        }
    }
    
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
        collectionView.allowsMultipleSelection = true
        
        collectionView.register(FilterCollectionViewCell.self,
                                forCellWithReuseIdentifier: FilterCollectionViewCell.reuseId)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderView.reuseId)
        return collectionView
    }
    
    func setupButton() {
        confirmButton.onTap = {
            self.delegate?.didSelectOptions(self.selectedFilters)
            self.dismiss(animated: true)
        }
        confirmButton.state = selectedFilters.isEmpty ? .disabled : .normal
    }
}

private extension FiltersViewController {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
        setupButton()
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    func embedViews() {
        view.addSubviews(collectionView, confirmButton)
    }
    
    func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
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
        
        return filtersService.filtersCount(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = filtersService.section(for: indexPath.section) else { return .init() }
        
        let cell = collectionView.deque(in: collectionView,
                                        of: FilterCollectionViewCell.self,
                                        reuseId: FilterCollectionViewCell.reuseId,
                                        indexPath: indexPath)
        
        
        let viewModel = filtersService.configure(section: section, for: indexPath.item)
        
        if section == .colors, let color = viewModel.color {
            cell.configure(label: nil, with: color)
        } else {
            cell.configure(label: viewModel.title)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = filtersService.section(for: indexPath.section) else { return }
        
        var value: String
        switch section {
        case .topics:
            value = FilterModel.Topics.allCases[indexPath.item].rawValue
        case .order:
            value = FilterModel.Order.allCases[indexPath.item].rawValue
        case .orientation:
            value = FilterModel.Orientation.allCases[indexPath.item].rawValue
        case .colors:
            value = FilterModel.Colors.allCases[indexPath.item].rawValue
        }
        
        selectedFilters[section] = URLQueryItem(name: section.queryKey, value: value)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let section = filtersService.section(for: indexPath.section) else { return }
        
        selectedFilters[section] = nil
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?
            .filter { $0.section == indexPath.section }
            .forEach { collectionView.deselectItem(at: $0, animated: false) }
        return true
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
