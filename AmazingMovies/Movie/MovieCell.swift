import UIKit
import Combine

class MovieCell: UICollectionViewCell {
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var favouriteButton: UIButton!
    
    private var disposables = Set<AnyCancellable>()
    private var viewModel: MovieViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let buttonImage = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        favouriteButton.setImage(buttonImage, for: .normal)
        favouriteButton.tintColor = .white
        addShadows()
    }
    
    func configure(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        releaseDateLabel.text = viewModel.releaseDate
        ratingLabel.text = viewModel.rating
        titleLabel.text = viewModel.title
        favouriteButton.tintColor = viewModel.isFavourite ? .red : .white
        setupBindings(viewModel)
        viewModel.didAppear()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        loadingIndicatorView.stopAnimating()
        favouriteButton.tintColor = .white
        disposables.forEach { $0.cancel() }
    }
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        viewModel?.toggleFavourite()
        animateButton()
    }
    
    private func setupBindings(_ viewModel: MovieViewModel) {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.stateDidChange(state: $0) }
            .store(in: &disposables)
        viewModel.$isFavourite
            .map { $0 ? UIColor.red : UIColor.white }
            .receive(on: DispatchQueue.main)
            .assign(to: \.tintColor, on: favouriteButton)
            .store(in: &disposables)
    }
    
    private func stateDidChange(state: MovieViewModel.State) {
        loadingIndicatorView.stopAnimating()
        posterImageView.contentMode = .scaleAspectFill
        switch state {
        case .failed:
            posterImageView.image = UIImage(named: "imageBroken")
            posterImageView.contentMode = .center
        case .loading:
            posterImageView.image = nil
            loadingIndicatorView.startAnimating()
        case .loaded(let image):
            posterImageView.image = image
        }
    }

    private func addShadows() {
        ratingLabel.layer.shadowColor = UIColor.black.cgColor
        ratingLabel.layer.shadowOpacity = 0.5
        ratingLabel.layer.shadowOffset = .init(width: 0, height: 1)
        ratingLabel.layer.shadowRadius = 2
        
        favouriteButton.layer.shadowColor = UIColor.gray.cgColor
        favouriteButton.layer.shadowOpacity = 0.5
        favouriteButton.layer.shadowOffset = .zero
        favouriteButton.layer.shadowRadius = 4
    }
    
    private func animateButton() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: [.autoreverse],
            animations: { [weak self] in
                self?.favouriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
            completion: { [weak self] _ in
                self?.favouriteButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
