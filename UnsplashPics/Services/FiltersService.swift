//
//  FiltersService.swift
//  UnsplashPics
//
//  Created by 1 on 12.02.2025.
//

import UIKit


class FiltersService {
    
    var filtersCount: Int {
        FilterModel.Section.allCases.count
    }
    
    func filtersCount(in section: FilterModel.Section) -> Int {
        switch section {
        case .topics: return FilterModel.Topics.allCases.count
        case .order: return FilterModel.Order.allCases.count
        case .orientation: return FilterModel.Orientation.allCases.count
        case .colors: return FilterModel.Colors.allCases.count
        }
    }

    func createQueryItemsForFilters(section: FilterModel.Section, value: String?) -> URLQueryItem? {
        guard let value = value else { return nil }
        
        let key: String
        
        switch section {
        case .topics: key = "query"
        case .order: key = "order_by"
        case .orientation: key = "orientation"
        case .colors: key = "color"
        }
        
        return URLQueryItem(name: key, value: value)
    }

    
    func section(for index: Int) -> FilterModel.Section? {
        guard let section = FilterModel.Section(rawValue: index) else { return nil }
        
        return section
    }
    
    func configure(section: FilterModel.Section, for index: Int) -> FilterModel {
        switch section {
        case .topics:
            return FilterModel(title: FilterModel.Topics.allCases[index].description, isSelected: false)
        case .order:
            return FilterModel(title: FilterModel.Order.allCases[index].description, isSelected: false)
        case .orientation:
            return FilterModel(title: FilterModel.Orientation.allCases[index].description, isSelected: false)
        case .colors:
            let colorCase = FilterModel.Colors.allCases[index]
            return FilterModel(title: colorCase.description, color: colorCase.color, isSelected: false)
        }
    }
}
