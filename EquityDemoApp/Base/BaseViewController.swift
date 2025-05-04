//
//  BaseViewController.swift
//  EquityDemoApp
//
//  Created by Moin' Victor on 02/05/2025.
//


import UIKit

class BaseViewController: UIViewController, BaseController {
    
    lazy var progressView = ProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCommon()
    }
    
    private func setupCommon() {
        view.backgroundColor = .systemBackground
    }
}
