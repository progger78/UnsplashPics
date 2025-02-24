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

    func createQueryForFilter(in section: FilterModel.Section, indexPath: IndexPath) -> String {
        var queryValue: String
        
        switch section {
        case .topics:
            queryValue = FilterModel.Topics.allCases[indexPath.item].rawValue
        case .order:
            queryValue = FilterModel.Order.allCases[indexPath.item].rawValue
        case .orientation:
            queryValue = FilterModel.Orientation.allCases[indexPath.item].rawValue
        case .colors:
            queryValue = FilterModel.Colors.allCases[indexPath.item].rawValue
        }
        
        return queryValue
    }
    
    func section(for index: Int) -> FilterModel.Section? {
        guard let section = FilterModel.Section(rawValue: index) else { return nil }
        
        return section
    }
    
    func configure(section: FilterModel.Section, for index: Int) -> FilterModel {
        switch section {
        case .topics:
            return FilterModel(title: FilterModel.Topics.allCases[index].description)
        case .order:
            return FilterModel(title: FilterModel.Order.allCases[index].description)
        case .orientation:
            return FilterModel(title: FilterModel.Orientation.allCases[index].description)
        case .colors:
            let colorCase = FilterModel.Colors.allCases[index]
            return FilterModel(title: colorCase.description, color: colorCase.color)
        }
    }
}
