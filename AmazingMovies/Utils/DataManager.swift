import Foundation

class DataManager {
    
    var favourites: [String: Bool] {
        didSet {
            try? PropertyListEncoder()
                .encode(favourites)
                .write(to: url, options: .noFileProtection)
        }
    }
    
    static let shared: DataManager = .init()
    
    private let url: URL

    private init () {
        
        self.url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(.fileName)
            .appendingPathExtension(.plist)
        
        if let data = try? Data(contentsOf: url),
            let dictionary = try? PropertyListDecoder().decode([String: Bool].self, from: data) {
            favourites = dictionary
        } else  {
            favourites = [:]
        }
    }
}


private extension String {
    static let fileName: String = "favourites"
    static let plist: String = "plist"
}
