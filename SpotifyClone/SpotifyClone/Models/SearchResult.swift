//
//  UserProfile.swift
//  SpotifyClone
//
//  Created by Диана Мансурова on 21.03.2021.
//

import Foundation

enum SearchResult {
    case artists(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}