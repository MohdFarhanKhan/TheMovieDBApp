//
//  MovieViewModel.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 06/05/1445 AH.
//

import Foundation
import Combine
class MovieViewModel: ObservableObject {
    @Published   var movies: [APIResults] = []
    @Published var profileStructure: ProfileStructure?
    @Published var error : MovieError?
    @Published var movieSaveStatus = ""
    @Published var searhText = ""
    @Published var isLoading = false
    var cancellable: AnyCancellable?
     init() {
         cancellable = $searhText
             .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
             .removeDuplicates()
             .sink(receiveValue: { value in
                
                     self.search(query: value)
                
                
             })
     }
  
    
   
    func popularMovies( ) {
        self.movies.removeAll()
         error = nil
        self.isLoading = true
         HttpUtility.shared.PopulardMovie() {(result) in
             self.isLoading = false
             switch result{
             case .success(let response):
                 if !response.results.isEmpty {
                    
                     self.movies.append(response)
                     self.error = nil
                     
                 }
                 else{
                     self.error = .noData
                     
                 }
             case .failure(let error):
                 self.error = error
             }
         }
       
     }
    func topRatedMovies( ) {
         error = nil
        self.movies.removeAll()
        self.isLoading = true
         HttpUtility.shared.TopRatedMovies() {(result) in
             self.isLoading = false
             switch result{
             case .success(let response):
                 if !response.results.isEmpty {
                    
                     self.movies.append(response)
                     self.error = nil
                    
                 }
                 else{
                     self.error = .noData
                     
                 }
             case .failure(let error):
                 self.error = error
             }
         }
       
     }
    func upcomingMovies() {
         error = nil
        self.movies.removeAll()
        self.isLoading = true
         HttpUtility.shared.UpcomingMovie() {(result) in
             self.isLoading = false
             switch result{
             case .success(let response):
                 if !response.results.isEmpty {
                    
                     self.movies.append(response)
                     self.error = nil
                    
                 }
                 else{
                     self.error = .noData
                     
                 }
             case .failure(let error):
                 self.error = error
             }
         }
       
     }
    func nowPlaying() {
         error = nil
        self.movies.removeAll()
        self.isLoading = true
         HttpUtility.shared.nowPlayingMovie() {(result) in
             self.isLoading = false
             switch result{
             case .success(let response):
                 if !response.results.isEmpty {
                    
                     self.movies.append(response)
                     self.error = nil
                    
                 }
                 else{
                     self.error = .noData
                    
                 }
             case .failure(let error):
                 self.error = error
             }
         }
       
     }
   func search(query: String ) {
        error = nil
       
        
        if query.isEmpty  {
            error = .emptyString
            
        }
       self.movies.removeAll()
       self.isLoading = true
        HttpUtility.shared.searchMovie(query: query) {(result) in
            self.isLoading = false
            switch result{
            case .success(let response):
                if !response.results.isEmpty {
                    
                    self.movies.append(response)
                    self.error = nil
                    
                }
                else{
                    self.error = .noData
                   
                }
            case .failure(let error):
                self.error = error
            }
        }
      
    }
    func recentMovies( ) {
         error = nil
        self.movies.removeAll()
        self.isLoading = true
         HttpUtility.shared.recentMovies() {(result) in
             self.isLoading = false
             switch result{
             case .success(let response):
                 if !response.results.isEmpty {
                    
                     self.movies.append(response)
                     self.error = nil
                    
                 }
                 else{
                     self.error = .noData
                     
                 }
             case .failure(let error):
                 self.error = error
             }
         }
       
     }
    func randomMovie() {
         error = nil
        self.movies.removeAll()
        self.isLoading = true
         HttpUtility.shared.RandomMovie() {(result) in
             self.isLoading = false
             switch result{
             case .success(let response):
                 if !response.results.isEmpty {
                    
                     self.movies.append(response)
                     self.error = nil
                   
                 }
                 else{
                     self.error = .noData
                     
                 }
             case .failure(let error):
                 self.error = error
                 
             }
         }
       
     }
    func saveToFavorite(movie: Movie, completion:@escaping (_ result: String) -> ()) {
         error = nil
        MovieRepository.shared.saveMovie(movie: movie) { result in
            self.movieSaveStatus = result
            completion(result)
        }
       
     }
    func isSavedToFavorite(movie: Movie,completion:@escaping (_ result: Bool) -> () ) {
         error = nil
        MovieRepository.shared.isFavorite(id: movie.id) { result in
            completion(result)
            self.movieSaveStatus = "\(result)"
        }
       
     }
    func getUserProfileInfo() {
        MovieRepository.shared.getProfile { result in
            self.profileStructure = result
        }
    }
    func saveProfileInfo(profileInfo: ProfileStructure,completion:@escaping (_ result: String) -> () ) {
       
        MovieRepository.shared.saveProfile(profile: profileInfo) { result in
            if result == true{
                completion("Profile info successfully saved")
            }
            else{
                completion("Error in saving Profile info")
            }
           
        }
       
        
       
     }
    func saveWatchlist(list: [Movie],completion:@escaping (_ result: String) -> () ) {
      
        MovieRepository.shared.saveWatchList(list: list) { result in
            if result == true{
                completion("Watchlist successfully saved")
            }
            else{
                completion("Error in saving Watchlist")
            }
           
        }
       
        
       
     }
}
