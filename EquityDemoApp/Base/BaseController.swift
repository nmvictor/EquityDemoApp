//
//  BaseController.swift
//  EquityDemoApp
//
//  Created by Moin' Victor on 02/05/2025.
//
import UIKit

protocol BaseController: AnyObject {
    var view: UIView! { get set }
    var progressView: ProgressView { get set }

    func startActivityIndicator()
    func stopActivityIndicator()
}

extension BaseController {
    func startActivityIndicator() {
        DispatchQueue.main.async {
            self.view.addSubview(self.progressView)
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            if self.view.subviews.contains(self.progressView) {
                self.progressView.removeFromSuperview() // Remove it
            }
        }
    }
}
