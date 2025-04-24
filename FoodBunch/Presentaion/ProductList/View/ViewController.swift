//
//  ViewController.swift
//  FoodBunch
//
//  Created by Furkan ic on 18.04.2025.
//

import UIKit
import Combine

final class ViewController: UIViewController {
    
    lazy var collectionView = makeCollectionView()
    var viewModel = ProductListViewModel()
    private var cancellables = Set<AnyCancellable>()
    lazy var activityIndicatorView = makeActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        
        viewModel.retrieveProducts()
        
        setupUI()
    }
    
    func setupBinding() {
        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.handleAppState(appState: value)
            }.store(in: &cancellables)
    }

    
    func setupUI() {
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
        setupUIConstraints()
    }
    
    func setupUIConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func makeActivityIndicatorView() -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.largeContentTitle = "Loading..."
        return activityIndicatorView
    }
    
    func makeCollectionView() -> UICollectionView {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeColectionViewLayout())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: productlistCellIdentifier)
        
        return collectionView
    }
    
    func makeColectionViewLayout() -> UICollectionViewLayout {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return  UICollectionViewCompositionalLayout(
            section: section
        )
    }
    
    func showDetail(for productID: String) {
        let viewController = DetailViewController(
            viewModel: DetailViewModel(productID: productID)
        )
        viewController.modalPresentationStyle = .formSheet
        
        present(viewController, animated: true)
    }
    
    private func handleAppState(appState: AppState) {
        switch appState {
        case .idle:
            activityIndicatorView.stopAnimating()
        case .loading:
            activityIndicatorView.startAnimating()
        case .error(let error):
            activityIndicatorView.stopAnimating()
            showAlert(title: "Oops!", message: error.localizedDescription)
        }
    }
    
    func showAlert(title: String, message: String) {
        let action = UIAlertAction(title: "OK", style: .default)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

@available(iOS 17, *)
#Preview {
    ViewController()
}

