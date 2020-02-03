import Foundation
import Combine

enum ApiError: Error {
  case parsing(description: String)
  case network(description: String)
}

final class NetworkManager {
    
    static let shared: NetworkManager = NetworkManager()
    
    private let session: URLSession
    
    private init() {
        session = URLSession.shared
    }
    
    func getMovies(page: Int) -> AnyPublisher<MoviesResponse, ApiError> {
        return startTask(request: .movies(page: page))
    }
    
    func getImage(path: String) -> AnyPublisher<Data, ApiError> {
        guard let url = ApiRequest.image(path: path).url else {
            return Fail(error: ApiError.network(description: "Couldn't create URL"))
                .eraseToAnyPublisher()
        }
        return session.downloadTask(with: url)
    }
    
    private func startTask<T: Decodable>(request: ApiRequest) -> AnyPublisher<T, ApiError> {
        guard let url = request.url else {
            return Fail(error: ApiError.network(description: "Couldn't create URL"))
                .eraseToAnyPublisher()
        }
        return session.codableTask(with: url)
    }
}

extension URLSession {
    
    fileprivate func codableTask<T: Decodable>(
        with request: URL
    ) -> AnyPublisher<T, ApiError> {
        return self.dataTaskPublisher(for: request)
            .mapError { error in
                .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { pair in
            pair.data.decode()
        }
        .eraseToAnyPublisher()
    }
    
    fileprivate func downloadTask(
        with request: URL
    ) -> AnyPublisher<Data, ApiError> {
        return self.dataTaskPublisher(for: request)
            .mapError { error in
                .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { pair in
            Just(pair.data)
            .mapError { error in
                    .parsing(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}


extension Data {
    
    func decode<T: Decodable>() -> AnyPublisher<T, ApiError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return Just(self)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
}
