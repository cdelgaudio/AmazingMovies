import Foundation

enum ApiRequest {
    case movies(page: Int)
    case image(path: String)
    
    var url: URL? {
        var urlComponents: URLComponents = .init()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = params
        return urlComponents.url
    }
    
    private var scheme: String { "https" }
    
    private var host: String {
        switch self {
        case .movies:
            return "api.themoviedb.org"
        case .image:
            return "image.tmdb.org"
        }
    }
    
    private var path: String {
        switch self {
        case .movies:
            return "/3/movie/popular"
        case .image(let imagePath):
            return "/t/p/w500" + imagePath
        }
    }
    
    private var params: [URLQueryItem]? {
        switch self {
        case .movies(let page):
            return [
            .init(name: "api_key", value: apiKey),
            .init(name: "language", value: "en-US"),
            .init(name: "page", value: String(page))
            ]
        case .image:
            return nil
        }
    }
    
    private var apiKey: String {
        Bundle.main.object(forInfoDictionaryKey: "API_Key") as? String ?? ""
    }
}
