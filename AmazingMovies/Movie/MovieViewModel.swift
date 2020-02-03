import UIKit
import Combine

class MovieViewModel {
    
    enum State {
        case failed
        case loading
        case loaded(image: UIImage)
    }
    
    @Published var state: State
    @Published var isFavourite: Bool
    
    var title: String {
        movie.title ?? "---"
    }
    
    var rating: String {
        movie.voteAverage.map { "\(Int( $0 * 10))%" } ?? "-"
    }
    
    var releaseDate: String {
        movie.releaseDate ?? "---"
    }
    
    private let movie: MoviesResponse.Movie
    
    private var disposables = Set<AnyCancellable>()
    
    init(movie: MoviesResponse.Movie) {
        self.movie = movie
        self.isFavourite = DataManager.shared.favourites["\(movie.id)"] ?? false
        self.state = .failed
    }
    
    func didAppear() {
        guard let posterPath = movie.posterPath else {
            state = .failed
            return
        }
        if let cachedImage = ImageCacheManager.shared.getImage(with: posterPath) {
            state = .loaded(image: cachedImage)
        } else {
            state = .loading
            downloadImage(with: posterPath)
        }
    }
    
    func toggleFavourite() {
        isFavourite = !isFavourite
        DataManager.shared.favourites["\(movie.id)"] = isFavourite ? true : nil
    }
    
    private func downloadImage(with path: String) {
        NetworkManager.shared.getImage(path: path)
        .sink(receiveCompletion: { [weak self] response in
            switch response {
            case .failure(let error):
                self?.state = .failed
                print(error)
            case .finished:
                break
            }
        }, receiveValue: { [weak self] data in
            guard let image = UIImage(data: data) else { return }
            self?.state = .loaded(image: image)
            ImageCacheManager.shared.setImage(image, path: path)
        })
        .store(in: &disposables)
    }
    
}

