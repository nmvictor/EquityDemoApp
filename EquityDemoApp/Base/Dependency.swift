//
//  Dependency.swift
//  EquityDemoApp
//
//  Created by Moin' Victor on 02/05/2025.
//


import Foundation

protocol DependencyDelegate: AnyObject {
    func appDependencyDidUpdate()
}

protocol Dependency {
    var delegate: DependencyDelegate? { get set }
    var coin: Coin? { get set }
    
    func updated()
}

final class AppDependency: Dependency {
    
    var delegate: DependencyDelegate?
    var coin: Coin? = nil

    func updated() {
        delegate?.appDependencyDidUpdate()
    }
}
