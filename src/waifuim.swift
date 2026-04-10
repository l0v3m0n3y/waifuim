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
    
    public func get_stats() async throws -> Any {
        guard let url = URL(string: "\(api)/stats/public") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return  try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_artists(size: Int) async throws -> Any {
        guard let url = URL(string: "\(api)/artists?pageSize=\(size)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return  try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_tags(size: Int) async throws -> Any {
        guard let url = URL(string: "\(api)/tags?pageSize=\(size)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return  try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_images_from_catalog(id: Int) async throws -> Any {
        guard let url = URL(string: "\(api)/images/\(id)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return  try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_images_list(pageSize: Int = 30,isNsfw: Bool=false,artistId: Int? = nil,tag: String? = nil,orderBy: String = "Random") async throws -> Any {
        var urlString = "\(api)/images?isNsfw=\(isNsfw)&orderBy=\(orderBy)&page=1&pageSize=\(pageSize)"
        if let artistId = artistId {
            urlString += "&includedArtists=\(artistId)"
        }
        if let tag = tag {
            urlString += "&includedTags=\(tag)"
        }
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return  try JSONSerialization.jsonObject(with: data)
    }
}
