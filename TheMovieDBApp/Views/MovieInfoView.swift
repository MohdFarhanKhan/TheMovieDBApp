//
//  MovieInfoView.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 09/05/1445 AH.
//

import SwiftUI
import AVKit
struct MovieInfoView: View {
    @State var movie: Movie?
    @ObservedObject var viewModel: MovieViewModel = MovieViewModel()
    @State var isShowingVideo: Bool = false
    @State var isSavedToFavorite = false
    @State var isVideoAlter = false
    @State var videoSavingAlert = false
    @State var videoSavingMessage = ""
    @State var array:[String] = []
    @State var key: String = ""
    var body: some View {
        ZStack{
            VStack{
                NavigationLink(destination: YoutubePlayer(key: key,title: self.movie!.title), isActive: $isShowingVideo){
                                    EmptyView()
                                }
            }
            VStack{
                
                if let url = self.movie?.getPosterURL() {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    
                }
                VStack(alignment: .center) {
                    Text("Released: \(self.movie!.getReleasedYear())")
                    Text("VoteCount: \(self.movie!.voteCount)")
                    Text("Popularity: \(self.movie!.popularity)")
                }
                Spacer()
                Button {
                    viewModel.saveToFavorite(movie: self.movie!){ status in
                       videoSavingMessage = status
                       videoSavingAlert = true
                    }
                } label: {
                    Text("Add to favorite")
                    
                        .foregroundColor(.blue)
                        .background(
                            
                            RoundedRectangle(
                                
                                cornerRadius: 5,
                                style: .continuous
                            )
                            .stroke(.blue, lineWidth: 2)
                            
                        )
                }
            }
            .background(.white)
            
            .onAppear(){
                viewModel.isSavedToFavorite(movie: movie!) { [self] result in
                    isSavedToFavorite = result
                }
                HttpUtility.shared.fetchMovieVideos(id: movie!.id) { result in
                    if result.count >  0{
                        self.array = result
                        
                    }
                    else{
                        print("videos not available")
                    }
                }
            }
            .alert("Choose to watvh the video", isPresented: $isVideoAlter) {
                Button("OK", role: .cancel) { }
                ForEach(array, id:\.self){link in
                 
                    Button(link) {
                        self.key = link
                        self.isShowingVideo = true
                        
                        print(link)
                    }
                    
                }
            }
            .alert(videoSavingMessage, isPresented: $videoSavingAlert) {
               
                Button("OK", role: .cancel) { }
            }
            .navigationTitle(movie!.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if array.count > 0{
                    
                    Button {
                        isVideoAlter = true
                    } label: {
                        Text("Trailer Videos")
                        
                            .foregroundColor(.blue)
                            .background(
                                
                                RoundedRectangle(
                                    
                                    cornerRadius: 5,
                                    style: .continuous
                                )
                                .stroke(.blue, lineWidth: 2)
                                
                            )
                    }
                }
                
            }
        }
    }
}

#Preview {
    MovieInfoView( movie: nil)
}
