//
//  CoinDetailsViewController.swift
//  EquityDemoApp
//
//  Created by Moin' Victor on 02/05/2025.
//


import UIKit
import SwiftUI

final class CoinDetailsViewController: BaseHostingController<CoinDetailsView> {

    override init(rootView: CoinDetailsView) {
        super.init(rootView: rootView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.viewModel.viewDelegate = self
        self.title = "Coin Details"
    }
}

// MARK: - SignInViewModelViewDelegate

extension CoinDetailsViewController: CoinDetailsViewModelViewDelegate {
    func viewModelStartLoading(_ viewModel: CoinDetailsViewModel) {
        startActivityIndicator()
    }
    
    func viewModelStopLoading(_ viewModel: CoinDetailsViewModel) {
        stopActivityIndicator()
    }
}
