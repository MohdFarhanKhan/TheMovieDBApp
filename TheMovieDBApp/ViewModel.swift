//
//  ViewModel.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 02/12/1444 AH.
//

import Foundation
class  ViewModel:ObservableObject{
   
    @Published var movieArray:[[String: String]]?
    var timer = Timer()
    func getMovies(){
        HttpUtility.shared.callMovieUrl {
            
            DispatchQueue.main.async {
                self.movieArray = HttpUtility.shared.movieArray
            }
           
            
            if HttpUtility.shared.currentPage < HttpUtility.shared.totalPage{
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.5) {
                    self.getMovies()
                        }
            }
        }
    }
    
}
