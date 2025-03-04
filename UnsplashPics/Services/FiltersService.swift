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
        section.caseIterableCount
    }
    
    func createQueryForFilter(in section: FilterModel.Section, indexPath: IndexPath) -> String {
        return section.queryValue(at: indexPath.item) ?? ""
    }
    
    func section(for index: Int) -> FilterModel.Section? {
        guard let section = FilterModel.Section(rawValue: index) else { return nil }
        
        return section
    }
    
    func configure(section: FilterModel.Section, for index: Int) -> FilterModel {
        let title = section.stringValue(at: index) ?? ""
        print(title)
        let color = section == .colors ? section.colorValue(at: index) : nil
        
        return FilterModel(title: title, color: color)
    }
}
