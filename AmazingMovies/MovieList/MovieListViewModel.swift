import Foundation
import Combine

class MovieListViewModel {
    
    enum State {
        case failed, loading, loaded
    }
    
    @Published var state: State
    
    var dataSource: [MovieViewModel]
    
    private var page: Int
    
    private var disposables = Set<AnyCancellable>()

    init() {
        page = 0
        dataSource = []
        state = .failed
    }
    
    func nextPage() {
        switch state {
        case .failed, .loaded:
            getMovies(page: page + 1)
        case .loading:
            break
        }
    }
    
    private func getMovies(page: Int) {
        state = .loading
        NetworkManager.shared.getMovies(page: page)
            .filter { [weak self] in $0.page - 1 == self?.page }
            .map { ($0.page, $0.results.map { MovieViewModel(movie: $0) }) }
            .sink(receiveCompletion: { [weak self] in
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self?.state = .failed
                }
            }, receiveValue: { [weak self]  page, movies in
                guard let self = self else { return }
                self.dataSource += movies
                self.page = page
                self.state = .loaded
            })
        .store(in: &disposables)
    }
}
