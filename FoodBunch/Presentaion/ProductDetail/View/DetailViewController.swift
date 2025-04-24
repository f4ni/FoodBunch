//
//  DetailViewController.swift
//  FoodBunch
//
//  Created by Furkan ic on 23.04.2025.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    
    private let viewModel: DetailViewModel
    
    private lazy var stackView = makeStackView()
    private var imageView = UIImageView()
    private lazy var titleLabel = makeTitleLabel()
    private var priceLabel = UILabel()
    private var descriptionLabel = UILabel()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        setupUI()
        viewModel.retrieveProduct()
    }
    
    func setupBinding() {
        viewModel.$product
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }
    
    func updateUI() {
        view.backgroundColor = .white
        guard let product = viewModel.product else { return }
        
        imageView.cacheImage(urlString: product.image)
        titleLabel.text = product.name
        priceLabel.text = "Price: $\(product.price)"
        descriptionLabel.text = "Description:\n\(product.description ?? "N/A")"
    }
    
    func setupUI() {
        view.addSubview(stackView)
        imageView.contentMode = .scaleAspectFit
        descriptionLabel.numberOfLines = 0
        [
            imageView,
            titleLabel,
            priceLabel,
            descriptionLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        setupUIConstraints()
    }
    
    func setupUIConstraints() {
        [
            stackView,
            imageView,
            titleLabel,
            priceLabel,
            descriptionLabel
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 160),
            imageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
    
    func makeStackView() -> UIStackView {
        let stack = UIStackView()
        stack.spacing = 12
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }
    
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }
}



#Preview {
    DetailViewController(viewModel: DetailViewModel(productID: "3"))
}
