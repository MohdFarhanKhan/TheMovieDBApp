//
//  FavoriteMovies+CoreDataProperties.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 06/05/1445 AH.
//
//

import Foundation
import CoreData


extension FavoriteMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovies> {
        return NSFetchRequest<FavoriteMovies>(entityName: "FavoriteMovies")
    }

    @NSManaged public var backdropPath: String?
    @NSManaged public var genreIDS: [Int]?
    @NSManaged public var id: Int32
    @NSManaged public var isAdult: Bool
    @NSManaged public var isVideo: Bool
    @NSManaged public var originalLanguage: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int32
    @NSManaged public var id1: Int32
    @NSManaged public var isVideo1: Bool

}

extension FavoriteMovies : Identifiable {

}
