import UIKit

final class ExchangeDetailViewController: UIViewController {
  
  // MARK: - Properties
  private let viewModel: ExchangeDetailViewModel
  private let customView = ExchangeDetailView()
  weak var coordinator: ExchangeCoordinator?
  
  // MARK: - UI Components
  private let loadingIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = .systemGray
    indicator.hidesWhenStopped = true
    indicator.translatesAutoresizingMaskIntoConstraints = false
    return indicator
  }()
  
  // MARK: - Init
  init(viewModel: ExchangeDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) { nil }
  
  // MARK: - Lifecycle
  override func loadView() {
    self.view = customView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBindings()
    setupLoadingIndicator()
    setupConstraints()
    customView.configure(with: viewModel)
  }
  
  private func setupBindings() {
    customView.onWebsiteTapped = { [weak self] in
      guard let self = self else { return }
      
      let urlPath = self.viewModel.websiteUrl ?? ""
      self.coordinator?.openWebsite(urlPath: urlPath)
    }
    
    viewModel.onLoadingStatusChanged = { [weak self] isLoading in
      DispatchQueue.main.async {
        if isLoading {
          self?.loadingIndicator.startAnimating()
        } else {
          self?.loadingIndicator.stopAnimating()
        }
      }
    }
  }
  
  private func setupLoadingIndicator() {
    view.addSubview(loadingIndicator)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
}
