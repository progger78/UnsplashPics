//
//  FiltersService.swift
//  UnsplashPics
//
//  Created by 1 on 12.02.2025.
//

import UIKit


class FiltersService {
    enum Colors: String, CaseIterable {
        case blackAndWhite, white, yellow, orange, red, purple, magenta, green, teal, blue

        var description: String {
            switch self {
            case .blackAndWhite: return "Чёрно-белый"
            case .white: return "Белый"
            case .yellow: return "Жёлтый"
            case .orange: return "Оранжевый"
            case .red: return "Красный"
            case .purple: return "Фиолетовый"
            case .magenta: return "Малиновый"
            case .green: return "Зелёный"
            case .teal: return "Бирюзовый"
            case .blue: return "Синий"
            }
        }

        var color: UIColor {
            switch self {
            case .blackAndWhite: return UIColor(white: 0.5, alpha: 1.0)
            case .white: return .white
            case .yellow: return .yellow
            case .orange: return .orange
            case .red: return .red
            case .purple: return .purple
            case .magenta: return .magenta
            case .green: return .green
            case .teal: return .systemTeal
            case .blue: return .blue
            }
        }
    }

    enum Order: String, CaseIterable {
        case relevant, latest

        var description: String {
            switch self {
            case .relevant: return "Актуальные"
            case .latest: return "Последние"
            }
        }
    }

    enum Orientation: String, CaseIterable {
        case landscape, portrait, squarish

        var description: String {
            switch self {
            case .landscape: return "Альбомная"
            case .portrait: return "Портретная"
            case .squarish: return "Квадратная"
            }
        }
    }

    enum Topics: String, CaseIterable {
        case nature, cars, people, art

        var description: String {
            switch self {
            case .nature: return "Природа"
            case .cars: return "Автомобили"
            case .people: return "Люди"
            case .art: return "Искусство"
            }
        }
    }

    enum Section: Int, CaseIterable {
        case topics = 0
        case order
        case orientation
        case colors
    }
    
    var filtersCount: Int {
        Section.allCases.count
    }
    
    var topicsCount: Int {
        Topics.allCases.count
    }
    
    var orientationCount: Int {
        Orientation.allCases.count
    }
    
    var colorsCount: Int {
        Colors.allCases.count
    }
    
    var orderCount: Int {
        Order.allCases.count
    }
    
    func section(for index: Int) -> Section? {
        guard let section = Section(rawValue: index) else { return nil }
        
        return section
    }
    
    func configure(section: Section, for index: Int) -> (title: String, color: UIColor?) {
        switch section {
        case .topics:
            let title = Topics.allCases[index].description
            return (title: title, color: nil)
        case .order:
            let title = Order.allCases[index].description
            return (title: title, color: nil)
        case .orientation:
            let title = Orientation.allCases[index].description
            return (title: title, color: nil)
        case .colors:
            let title = Colors.allCases[index].description
            let color = Colors.allCases[index].color
            return (title: title, color: color)
        }
    }
}
