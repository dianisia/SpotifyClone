//
//  AuthManager.swift
//  SpotifyClone
//
//  Created by Диана Мансурова on 21.03.2021.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let clientId = "a0e72a1c68054f889648a2e911192a6d"
        static let clientSecret = "afb62ddc632c4653bbd0bb6d137cfb2b"
    }

    private init() {}

    public var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let scopes = "user-read-private"
        let redirectURI = "https://www.iosacademy.io"
        let string =
                """
                \(baseURL)?response_type=code&client_id=\(Constants
                        .clientId)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE
                """
        return URL(string: string)

    }

    var isSignedIn: Bool {
        return false
    }

    private var accessToken: String? {
        return nil
    }

    private var refreshToken: String? {
        return nil
    }

    private var tokenExpirationDate: Date? {
        return nil
    }

    private var shouldRefreshToken: Bool {
        return false
    }

    public func exchangeCodeForToken(
            code: String,
            completion: @escaping ((Bool) -> Void)
    ) {

    }

    private func cacheToken() {

    }

    private func refreshAccessToken() {

    }
}
