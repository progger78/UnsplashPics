//
//  UIViewController+Ext.swift
//  UnsplashPics
//
//  Created by 1 on 19.02.2025.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyView = EmptyStateView(message: message)
        emptyView.frame = view.bounds
        view.addSubview(emptyView)
        
    }
    
    func openSafari(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func presentSnackBar(message: String,
                         in view: UIView,
                         type: CustomSnackBar.SnackBarType,
                         actionTitle: String? = nil,
                         actionHandler: @escaping(() -> Void) = {}) {
        let snackbar = CustomSnackBar(message: message,
                                      actionTitle: actionTitle,
                                      type: type,
                                      actionHandler: actionHandler)
        snackbar.show(in: view, duration: 3.0)
    }
    
    func showErrorAlert(with message: String) {
        let action = UIAlertAction(title: "Ok", style: .default)
        let alert = UIAlertController(title: "Error occured", message: message, preferredStyle: .alert)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
