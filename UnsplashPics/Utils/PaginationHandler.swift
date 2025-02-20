//
//  PaginationHandler.swift
//  CryptoInfo
//
//  Created by 1 on 04.12.2024.
//

import UIKit

class PaginationHandler {
    
    private let threshold: CGFloat
    private let onFetchMore: () -> Void
    private var isLoading: Bool = false
    
    init(threshold: CGFloat = 140, onFetchMore: @escaping () -> Void) {
        self.threshold = threshold
        self.onFetchMore = onFetchMore
    }
    
    func handleScroll(for scrollView: UIScrollView, isLoading: Bool, hasMore: Bool) {
        guard !isLoading, hasMore else { return }
        
        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height + 200
        let visibleHeight = scrollView.frame.size.height
        
        guard totalContentHeight > visibleHeight else { return }
        
        if offset >= (totalContentHeight - visibleHeight - threshold) {
            self.onFetchMore()
        }
    }
}
