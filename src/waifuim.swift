import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}


public class Waifuim {
    private let api = "https://api.waifu.im"
    private var headers: [String: String]
    
    public init() {
        self.headers = [
        "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "Host":"api.waifu.im",
        "Connection":"keep-alive",
        "Accept-Encoding":"deflate, zstd",
        "Accept-Language":"en-US,en;q=0.9",
        "User-Agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36"
        ]

    }
    
    private func fetchJSON(from urlString: String,method: HTTPMethod = .get,body: Data? = nil,queryParameters: [String: String]? = nil) async throws -> Any {
        var urlComponents = URLComponents(string: urlString)
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents?.url else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func getStats() async throws -> Any {
        return try await fetchJSON(from: "\(api)/stats/public")
    }
    
    public func getArtists(size: Int) async throws -> Any {
        return try await fetchJSON(from: "\(api)/artists?pageSize=\(size)")
    }
    
    public func getTags(size: Int) async throws -> Any {
        return try await fetchJSON(from: "\(api)/tags?pageSize=\(size)")
    }
    
    public func getImagesFromCatalog(id: Int) async throws -> Any {
        return try await fetchJSON(from: "\(api)/images/\(id)")
    }
    
    public func getImagesList(pageSize: Int = 30,isNsfw: Bool=false,artistId: Int? = nil,tag: String? = nil,orderBy: String = "Random") async throws -> Any {
        let urlString = "\(api)/images"
        
        var queryParameters: [String: String] = [
           "isNsfw": String(isNsfw),
            "orderBy": orderBy,
            "page": "1",
            "pageSize": String(pageSize)
        ]
    
        if let artistId = artistId {
            queryParameters["includedArtists"] = String(artistId)
        }
    
        if let tag = tag {
            queryParameters["includedTags"] = tag
        }
    
        return try await fetchJSON(from: urlString,method: .get,queryParameters: queryParameters)
    }
}
