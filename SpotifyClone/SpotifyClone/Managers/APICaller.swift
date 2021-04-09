//
//  APICaller.swift
//  SpotifyClone
//
//  Created by Диана Мансурова on 21.03.2021.
//

import Foundation

final class APICaller {
    static let shared = APICaller()

    private init() {}

    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1/"
    }

    enum APIError: Error {
        case failedToGetData
    }

    // MARK: - Albums
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(
                with: URL(string: Constants.baseAPIURL + "albums/\(album.id)"),
                type: .GET
        ) { request in self.makeRequest(request: request, completion: completion) }
    }

    // MARK: - Playlists
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        createRequest(
                with: URL(string: Constants.baseAPIURL + "playlists/\(playlist.id)"),
                type: .GET
        ) { request in self.makeRequest(request: request, completion: completion) }
    }

    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(
                with: URL(string: Constants.baseAPIURL + "me/"),
                type: .GET
        ) { request in self.makeRequest(request: request, completion: completion) }
    }

    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "browse/new-releases?limit=50"), type: .GET) {
            request in self.makeRequest(request: request, completion: completion)
        }
    }

    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistResponse, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "browse/featured-playlists?limit=50"), type: .GET) {
            request in self.makeRequest(request: request, completion: completion)
        }
    }

    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void)) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "recommendations?seed_genres=\(seeds)"), type: .GET) {
            request in self.makeRequest(request: request, completion: completion)
        }
    }

    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>) -> Void)) {
        createRequest(
                with: URL(string: Constants.baseAPIURL + "recommendations/available-genre-seeds"),
                type: .GET
        ) { request in self.makeRequest(request: request, completion: completion) }
    }

    private func makeRequest<T: Codable>(request: URLRequest, completion: @escaping ((Result<T, Error>) -> Void)) {
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            }
            catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        task.resume()
    }

    enum HTTPMethod: String {
        case GET
        case POST
    }

    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
