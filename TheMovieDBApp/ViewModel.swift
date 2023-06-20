//
//  ViewModel.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 02/12/1444 AH.
//

import Foundation
class  ViewModel:ObservableObject{
   
    @Published var movieArray:[[String: String]]?
   
    func getMovies(){
        HttpUtility.shared.callMovieUrl {
            self.movieArray = HttpUtility.shared.movieArray
        }
    }
    
}
