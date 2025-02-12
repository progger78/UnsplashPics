//
//  FilterCollectionViewCell.swift
//  UnsplashPics
//
//  Created by 1 on 12.02.2025.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    static let reuseId = "FilterCollectionViewCell"
    
    private let filterBadge = FilterBadge(mainColor: .systemTeal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(label: String?, with color: UIColor = .systemGray4) {
        filterBadge.set(label, color: color)
    }
}

private extension FilterCollectionViewCell {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
        
    }
    
    func configureView() {
       
    }
    
    func embedViews() {
        contentView.addSubview(filterBadge)
    }
    
    func configureConstraints() {
        filterBadge.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
