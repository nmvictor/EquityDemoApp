//
//  FavoriteCoinsViewController.swift
//  EquityDemoApp
//
//  Created by Moin' Victor on 03/05/2025.
//

import UIKit
import Kingfisher

final class FavoriteCoinsViewController: BaseViewController {

    private var viewModel: CoinsViewModel
    private var favoriteCoins: [Coin]
    
    init(viewModel: CoinsViewModel) {
        self.viewModel = viewModel
        self.favoriteCoins = []
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.viewDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let tableView = UITableView()
    var refreshControl: UIRefreshControl!

    private lazy var showFavoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("All Coins", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showAllTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTable()
    }

    private func setupViews() {
        self.title = "Favorite Coins"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(showFavoritesButton)
        NSLayoutConstraint.activate([
            // Show Favorites button
            showFavoritesButton.widthAnchor.constraint(equalToConstant: 150),
            showFavoritesButton.heightAnchor.constraint(equalToConstant: 50),
            showFavoritesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showFavoritesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshTable), for: .valueChanged)
        self.refreshControl = refreshControl
        self.tableView.refreshControl = refreshControl
    }
    
    @objc
    func refreshTable() {
        refreshControl?.beginRefreshing()
        Task {
            Task {
            
                await viewModel.getFavoriteCoins(showLoader: true) { result in
                    switch result {
                    case .success(let coins):
                        self.favoriteCoins = coins
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        debugPrint(error)
                        // display the error
                        let alert = UIAlertController(title: "Error", message: "Something went wrong: \(error.localizedDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                        DispatchQueue.main.async { [weak self] in
                            self?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        refreshControl?.endRefreshing()
    }
    
    @objc
    private func showAllTapped() {
        viewModel.showAllTapped()
    }
}

// MARK: - HomeViewModelViewDelegate

extension FavoriteCoinsViewController: HomeViewModelViewDelegate {
    func viewModelTitlesDidUpdate(_ viewModel: CoinsViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
           
        }
    }
    
    func viewModelStartLoading(_ viewModel: CoinsViewModel) {
        startActivityIndicator()
    }
    
    func viewModelStopLoading(_ viewModel: CoinsViewModel) {
        stopActivityIndicator()
    }
}

extension FavoriteCoinsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coin = favoriteCoins[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
     
        cell.textLabel?.text = coin.name
        cell.detailTextLabel?.text = "Price: \(String(format: "%.4f", Double(coin.price)!))     24Hr Vol: \(coin._24hVolume) "
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIColor.lightGray.image(CGSize(width: 32, height: 32))
        cell.imageView?.layer.cornerRadius = 32 / 2
        if let url =  URL(string: coin.iconUrl) {
            cell.imageView?.kf.setImage(
                with: url,
                placeholder: UIColor.lightGray.image(CGSize(width: 32, height: 32)),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 2
            cell.imageView?.clipsToBounds = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = self.favoriteCoins[indexPath.row]
        self.viewModel.coinTapped(coin)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let coin = self.favoriteCoins[indexPath.row]
        
        let unfavorite = UIContextualAction(style: .destructive, title: "UnFavorite") { action, view, complete in
            print("UnFavorite")
           
            Task {
                await self.viewModel.unfavoriteTap(coin) { [weak self] result in
                    switch result {
                    case .success:
                        debugPrint("Removed favorite")
                        self?.favoriteCoins = (self?.favoriteCoins.filter({ cn in
                            cn.uuid != coin.uuid
                        }))!
                    case .failure(let error):
                        debugPrint(error)
                    }
                    DispatchQueue.main.async {
                        complete(true)
                        self?.refreshTable()
                    }
                }
            }
        }
        unfavorite.image?.withTintColor(.white)
        unfavorite.backgroundColor = .red
        
     
        return UISwipeActionsConfiguration(actions: [unfavorite])
    }
}

