//
//  FilterModel.swift
//  UnsplashPics
//
//  Created by 1 on 13.02.2025.
//

import UIKit

struct FilterModel {
    let title: String
    var color: UIColor? = nil
    var isSelected: Bool
    
    enum Colors: String, CaseIterable {
        case black_and_white, white, yellow, orange, red, purple, magenta, green, teal, blue

        var description: String {
            switch self {
            case .black_and_white: return "Чёрно-белый"
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
            case .black_and_white: return UIColor(white: 0.5, alpha: 1.0)
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
        
        var queryKey: String {
            switch self {
            case .topics:
                return "query"
            case .order:
                return "order_by"
            case .orientation:
                return "orientation"
            case .colors:
                return "color"
            }
        }
    }
}

