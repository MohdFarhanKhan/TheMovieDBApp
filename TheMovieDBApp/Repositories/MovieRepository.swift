//
//  MovieRepository.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 06/05/1445 AH.
//

import Foundation
import CoreData

final class MovieRepository
{

    private init(){}
    static let shared = MovieRepository()
    
func isFavorite(id: Int, completionHandler:@escaping(_ result: Bool)-> Void){
    let fetchRequest: NSFetchRequest<FavoriteMovies>
    fetchRequest = FavoriteMovies.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@ ",
                                         id as NSNumber)
    let context = PersistentStorage.shared.context
    do{
        let likeFavorite = try context.fetch(fetchRequest)
        if likeFavorite.count >= 1{
            completionHandler(true)
        }
        else{
            completionHandler(false)
        }
       
    }
    catch{
        completionHandler(false)
    }
   
}
    func saveMovie(movie: Movie,completionHandler:@escaping (_ result: String) -> ()){
        isFavorite(id: movie.id) { result in
            if result == true{
                completionHandler("Already saved  to favorite")
            }
            else{
                var favoriteCoreData = FavoriteMovies(context: PersistentStorage.shared.context)
                favoriteCoreData.id = Int32(movie.id)
                favoriteCoreData.isAdult = movie.isAdult
                favoriteCoreData.posterPath = movie.posterPath
                favoriteCoreData.title = movie.title
                favoriteCoreData.releaseDate = movie.releaseDate
                favoriteCoreData.voteAverage = movie.voteAverage
                favoriteCoreData.overview = movie.overview
                favoriteCoreData.voteCount = Int32(movie.voteCount)
                favoriteCoreData.backdropPath = movie.backdropPath
                favoriteCoreData.genreIDS = movie.genreIDS.map { $0 }
                favoriteCoreData.originalLanguage = movie.originalLanguage
                favoriteCoreData.originalTitle = movie.originalTitle
                favoriteCoreData.popularity = movie.popularity
                favoriteCoreData.isVideo = movie.isVideo
                do{
                    try PersistentStorage.shared.context.save()
                    
                    completionHandler("Successfully Saved")
                }
                catch{
                    completionHandler("Unable to save")
                }
                
            }
        }
    }
   
    private func getFavoriteMovie(withId: Int)->FavoriteMovies?{
        let fetchRequest = NSFetchRequest<FavoriteMovies>(entityName: "FavoriteMovies")
        let fetchById = NSPredicate(format: "id==%@", withId as CVarArg)
        fetchRequest.predicate = fetchById

        let result = try! PersistentStorage.shared.context.fetch(fetchRequest)
        guard result.count != 0 else {return nil}

        return result.first
    }
    func getAllFavoriteMovie(completionHandler:@escaping (_ result: [Movie]?) -> ()){
        let fetchRequest = NSFetchRequest<FavoriteMovies>(entityName: "FavoriteMovies")
       

        let result = try! PersistentStorage.shared.context.fetch(fetchRequest)
        if result.count == 0 { completionHandler(nil)}
        var movies = [Movie]()
        for watchMovie in result{
            movies.append(Movie(id: Int(watchMovie.id), isAdult: watchMovie.isAdult, posterPath: watchMovie.posterPath, title: watchMovie.title!, releaseDate: watchMovie.releaseDate, voteAverage: watchMovie.voteAverage, overview: watchMovie.overview!, voteCount: Int(watchMovie.voteCount), backdropPath: watchMovie.backdropPath, genreIDS: watchMovie.genreIDS!, originalLanguage: watchMovie.originalLanguage!, originalTitle: watchMovie.originalTitle!, popularity: watchMovie.popularity, isVideo: watchMovie.isVideo))
        }
        completionHandler(movies)
       
    }
    func getAllWatchlistMovies(completionHandler:@escaping (_ result: [Movie]?) -> ()){
        let fetchRequest = NSFetchRequest<WatchListMovies>(entityName: "WatchListMovies")
       
        let result = try! PersistentStorage.shared.context.fetch(fetchRequest)
        if result.count == 0 { completionHandler(nil)}
        var movies = [Movie]()
        for watchMovie in result{
            movies.append(Movie(id: Int(watchMovie.id), isAdult: watchMovie.isAdult, posterPath: watchMovie.posterPath, title: watchMovie.title!, releaseDate: watchMovie.releaseDate, voteAverage: watchMovie.voteAverage, overview: watchMovie.overview!, voteCount: Int(watchMovie.voteCount), backdropPath: watchMovie.backdropPath, genreIDS: watchMovie.genreIDS!, originalLanguage: watchMovie.originalLanguage!, originalTitle: watchMovie.originalTitle!, popularity: watchMovie.popularity, isVideo: watchMovie.isVideo))
        }
        completionHandler(movies)
      
    }
    func deleteMovie(movie: Movie,completionHandler:@escaping (_ result: Bool) -> ()){
        isFavorite(id: movie.id) { [self] result in
            if result == true{
                do{
                    let favoriteMoview = getFavoriteMovie(withId: movie.id)
                    try PersistentStorage.shared.context.delete(favoriteMoview!)
                   try PersistentStorage.shared.saveContext()
                    
                    completionHandler(true)
                }
                catch{
                    completionHandler(false)
                }
                completionHandler(false)
            }
            else{
               
                completionHandler(false)
                
            }
        }
    }
    func getProfile(completionHandler:@escaping (_ result: ProfileStructure?) -> ()){
        let fetchRequest = NSFetchRequest<UserProfile>(entityName: "UserProfile")
        let result = try! PersistentStorage.shared.context.fetch(fetchRequest)
        if result.count > 0{
            let userProfile = result[0]
            let userProfileInfo = ProfileStructure(name: userProfile.profileName!, age: Int(userProfile.age), genre: userProfile.movieGenre!, movie: userProfile.movieName!)
            completionHandler(userProfileInfo)
        }
        else{
            completionHandler(nil)
        }
    }
    func saveProfile(profile: ProfileStructure,completionHandler:@escaping (_ result: Bool) -> ()){
        let fetchRequest = NSFetchRequest<UserProfile>(entityName: "UserProfile")
        let result = try! PersistentStorage.shared.context.fetch(fetchRequest)
        if result.count > 0{
            do{
                let userProfile = result[0]
                userProfile.profileName = profile.name
                userProfile.age = Int32(profile.age)
                userProfile.movieGenre = profile.genre
                userProfile.movieName = profile.movie
               
                try PersistentStorage.shared.saveContext()
                
                completionHandler(true)
            }
            catch{
                completionHandler(false)
            }
        }
        else{
            var profileCoreData = UserProfile(context: PersistentStorage.shared.context)
           
            profileCoreData.profileName = profile.name
            profileCoreData.age = Int32(profile.age)
            profileCoreData.movieGenre = profile.genre
            profileCoreData.movieName = profile.movie
           
            do{
                try PersistentStorage.shared.context.save()
                
                completionHandler(true)
            }
            catch{
                completionHandler(false)
            }
        }
       
    }
    func deleteWatchList(completionHandler:@escaping (_ result: Bool) -> ()){
        let fetchRequest = NSFetchRequest<WatchListMovies>(entityName: "WatchListMovies")
        let result = try! PersistentStorage.shared.context.fetch(fetchRequest)
        if result.count > 0{
            for watchMovie in result{
                do{
                  
                    try PersistentStorage.shared.context.delete(watchMovie)
                   try PersistentStorage.shared.saveContext()
                   
                }
                catch{
                    print(error)
                    //completionHandler(false)
                }
            }
            completionHandler(true)
        }
        else{
            completionHandler(true)
        }
    }
    func saveWatchMovie(movie:Movie){
        var watchListMoviesCoreData = WatchListMovies(context: PersistentStorage.shared.context)
        watchListMoviesCoreData.id = Int32(movie.id)
        watchListMoviesCoreData.isAdult = movie.isAdult
        watchListMoviesCoreData.posterPath = movie.posterPath
        watchListMoviesCoreData.title = movie.title
        watchListMoviesCoreData.releaseDate = movie.releaseDate
        watchListMoviesCoreData.voteAverage = movie.voteAverage
        watchListMoviesCoreData.overview = movie.overview
        watchListMoviesCoreData.voteCount = Int32(movie.voteCount)
        watchListMoviesCoreData.backdropPath = movie.backdropPath
        watchListMoviesCoreData.genreIDS = movie.genreIDS.map { $0 }
        watchListMoviesCoreData.originalLanguage = movie.originalLanguage
        watchListMoviesCoreData.originalTitle = movie.originalTitle
        watchListMoviesCoreData.popularity = movie.popularity
        watchListMoviesCoreData.isVideo = movie.isVideo
        do{
            try PersistentStorage.shared.context.save()
            
            
        }
        catch{
            print(error)
        }
    }
    func saveWatchList(list:[Movie],completionHandler:@escaping (_ result: Bool) -> ()){
        deleteWatchList { [self] result in
            for movie in list{
                saveWatchMovie(movie: movie)
            }
            completionHandler(true)
        }
       // completionHandler(true)
    }
}
