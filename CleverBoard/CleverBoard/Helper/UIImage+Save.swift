import UIKit

extension UIImage {
    
    public enum ErrorCode: Int {
        case noFileFound = 0
        case serialization = 1
        case deserialization = 2
        case invalidFileName = 3
        case couldNotAccessTemporaryDirectory = 4
        case couldNotAccessUserDomainMask = 5
        case couldNotAccessSharedContainer = 6
    }
    
    public static let errorDomain = "DiskErrorDomain"
    
    /// Create custom error that FileManager can't account for
    static func createError(_ errorCode: ErrorCode, description: String?, failureReason: String?, recoverySuggestion: String?) -> Error {
        let errorInfo: [String: Any] = [NSLocalizedDescriptionKey : description ?? "",
                                        NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion ?? "",
                                        NSLocalizedFailureReasonErrorKey: failureReason ?? ""]
        return NSError(domain: errorDomain, code: errorCode.rawValue, userInfo: errorInfo) as Error
    }
    
    /// Save image to disk
    ///
    /// - Parameters:
    ///   - fileName: user file name without extension
    /// - Throws: Error if there were any issues writing the image to disk
    func save(to fileName: String) throws {
        var fileName = fileName
        var data: Data?
        if let pngData = self.pngData() {
            data = pngData
            fileName += ".png"
        } else if let jpegData = self.jpegData(compressionQuality: 1) {
            data = jpegData
            fileName += ".jpeg"
        }
        if let imageData = data {
            do{
                let url = String.documentDirectoryURL.appendingPathComponent(fileName)
                try imageData.write(to: url, options: .atomic)
            } catch {
                throw error
            }
        } else {
            throw UIImage.createError(
                .serialization,
                description: "Could not serialize UIImage",
                failureReason: "Data conversion failed.",
                recoverySuggestion: nil
            )
        }
    }
    
    /// Retrieve image from disk
    ///
    /// - Parameters:
    ///   - fileName: fileName where image is stored
    /// - Returns: UIImage from disk
    static func retrieve(fileName: String) -> UIImage? {
        do {
            let url = String.documentDirectoryURL.appendingPathComponent(fileName)
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                return image
            }
        } catch {
        }
        return nil
    }
}
