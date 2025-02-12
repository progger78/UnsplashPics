//
//  UICollectionView+Ext.swift
//  UnsplashPics
//
//  Created by 1 on 12.02.2025.
//

import UIKit

extension UICollectionView {
    func deque<T: UIView>(in collectionView: UICollectionView,
                          of type: T.Type,
                          kind: String? = nil,
                          reuseId: String,
                          indexPath: IndexPath) -> T {
        if let kind {
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                          withReuseIdentifier: reuseId,
                                                                                          for: indexPath) as? T
            else {
                return .init()
            }
            
            return supplementaryView
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId,
                                                                for: indexPath) as? T else {
                return .init()
            }
            return cell
        }
    }
}
