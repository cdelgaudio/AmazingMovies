import UIKit

class ImageCacheManager {
    
    static let shared: ImageCacheManager = .init()
    
    private let imageCache: NSCache<NSString, UIImage>
    
    private init () {
        imageCache = .init()
    }
    
    func getImage(with path: String) -> UIImage? {
        imageCache.object(forKey: path as NSString)
    }
    
    func setImage(_ image: UIImage, path: String) {
        imageCache.setObject(image, forKey: path as NSString)
    }
    
}
