//
//  PersistenceManager.swift
//  GitHFollowers
//
//  Created by Afir Thes on 08.01.2023.
//

import Foundation

enum PersistenceActionType {
  case add
  case remove
}

enum PersistenceManager {
  private static let defaults = UserDefaults.standard

  enum Keys {
    static let favorites = "favorites"
  }

  static func updateWith(
    favorite: Follower,
    actionType: PersistenceActionType,
    completed: @escaping (GFError?) -> Void
  ) {
    self.retrieveFavorites { result in
      switch result {
      case let .success(favorites):
        var retrievedFavorites = favorites

        switch actionType {
        case .add:
          guard !retrievedFavorites.contains(favorite) else {
            completed(.alreadyInFavorites)
            return
          }
          retrievedFavorites.append(favorite)

        case .remove:
          retrievedFavorites.removeAll { $0.login == favorite.login }
        }

        completed(save(favorites: retrievedFavorites))

      case let .failure(error):
        completed(error)
      }
    }
  }

  static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
    guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
      // first time use
      completed(.success([]))
      return
    }

    do {
      let decoder = JSONDecoder()
      let favorites = try decoder.decode([Follower].self, from: favoritesData)
      completed(.success(favorites))
    } catch {
      completed(.failure(.unableToFavorite))
    }
  }

  static func save(favorites: [Follower]) -> GFError? {
    do {
      let encoder = JSONEncoder()
      let encodedFavorites = try encoder.encode(favorites)
      self.defaults.set(encodedFavorites, forKey: Keys.favorites)
      return nil
    } catch {
      return .unableToFavorite
    }
  }
}
