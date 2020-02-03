import UIKit
import Combine

class MovieListViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var failureView: UIView!
    
    private var movies: [MoviesResponse.Movie] = []
    private var viewModel: MovieListViewModel = MovieListViewModel()
    private var disposables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.nextPage()
    }
    
    private func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.stateDidChange($0) }
        .store(in: &disposables)
    }
    
    private func stateDidChange(_ state: MovieListViewModel.State) {
        loadingView.isHidden = true
        failureView.isHidden = true
        switch state {
        case .failed:
            failureView.isHidden = false
        case .loading:
            if viewModel.dataSource.isEmpty {
                loadingView.isHidden = false
            }
        case .loaded:
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
    
    @IBAction private func retryButtonPressed(_ sender: UIButton) {
        viewModel.nextPage()
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.dataSource.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.identifier,
            for: indexPath
            ) as? MovieCell else { return UICollectionViewCell() }
        cell.configure(viewModel: viewModel.dataSource[indexPath.row])
        return cell
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        .init(
            width: (collectionView.bounds.width - 6) / 2,
            height: (collectionView.bounds.width) * 0.8
        )
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset: CGFloat = 500
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge + offset >= scrollView.contentSize.height {
            viewModel.nextPage()
        }
    }
}
