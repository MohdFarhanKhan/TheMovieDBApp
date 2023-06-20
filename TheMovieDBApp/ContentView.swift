//
//  ContentView.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 02/12/1444 AH.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel:ViewModel = ViewModel()
   
    var body: some View {
        VStack {
            Text("Movie List")
            List {
                if viewModel.movieArray?.count ?? 0 > 0{
                    ForEach(viewModel.movieArray!, id: \.self) { item in
                       
                       
                       
                        VStack{
                            Text("Overview->\(item["overview"]  ?? "")")
                            
                            Text("Backdrop path->\(item["backdrop_path"]  ?? "")")
                            
                            Text("Original language->\(item["original_language"]  ?? "")")
                            
                            Text("Original title->\(item["original_title"]  ?? "")")
                            
                            Text("Popularity->\(item["popularity"]  ?? "")")
                            
                            Text("Poster path->\(item["poster_path"]  ?? "")")
                            
                            Text("Release_date->\(item["release_date"]  ?? "")")
                            
                            Text("Title->\(item["title"]  ?? "")")
                            
                            Text("vote_average->\(item["vote_average"]  ?? "")")
                            
                            Text("vote_count->\(item["vote_count"]  ?? "")")
                           
                        }
                        .background(.white)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                        
                       
                           }
                }
               
                   }
            
            
        }
        .padding()
        .onAppear(){
            viewModel.getMovies()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
