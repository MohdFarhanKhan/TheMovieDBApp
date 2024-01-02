//
//  Movie.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 06/05/1445 AH.
//

import Foundation

struct ProfileStructure{
    let name: String
    let age: Int
    let genre: String
    let movie: String
}
struct Movie: Decodable {
 let id: Int!
let isAdult: Bool
 let posterPath: String?
 let title: String
 let releaseDate: String?
 let voteAverage: Double
 let overview: String
 let voteCount:Int!
 let backdropPath: String?
 let genreIDS: [Int]
 let originalLanguage, originalTitle: String
 let popularity: Double
 let isVideo: Bool
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case isAdult = "adult"
        case posterPath = "poster_path"
        case title = "title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case overview = "overview"
        case voteCount = "vote_count"
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case popularity = "popularity"
        case isVideo = "video"
    }
    func getBackdropURL()->URL?{
        if backdropPath != nil{
            return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
        }
        else  if posterPath != nil{
            
            return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
        }
        return nil
    }
    func getPosterURL()->URL?{
        if posterPath != nil{
          
            return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
        }
        else if backdropPath != nil{
            return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
        }
        return nil
    }
    func getReleasedYear()->String{
        var yearString = "Not provided"
        if releaseDate?.isEmpty == false{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.date(from: releaseDate!)
            formatter.dateFormat = "yyyy"
            yearString = formatter.string(from: date!)
        }
        return yearString
    }
    
}
