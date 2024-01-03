//
//  HomeView.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 06/05/1445 AH.
//

import SwiftUI
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
struct MovieCell:View{
    @ObservedObject var viewModel : MovieViewModel = MovieViewModel()
    @State var movie: Movie?
    @State var movieSize: CGSize = CGSize(width: 100, height: 100)
   @State var favIcon = "star"
   @State private var showingAlert = false
   @State private var alertMsg:String = ""
    @State private var imgURL: URL?
    @State var pushActive = false
    var body: some View {
        ZStack{
            if let url = self.movie?.getPosterURL() {
                AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
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
            
            Spacer()
            VStack(alignment: .center){
                Spacer()
                Text(movie!.title)
                    .foregroundStyle(.white)
                    .font(.headline)
                    
                    
            }
            .padding(.bottom, 25)
        }
        .frame(width:self.movieSize.width, height: self.movieSize.height)
        .background(Color.black.opacity(0.8))
          .cornerRadius(15)
          .contextMenu {
             
                 Button {
                     viewModel.saveToFavorite(movie: movie!) { result in
                         showingAlert = true
                         alertMsg = result
                     }
                 } label: {
                     Label("Favorite", systemImage: favIcon)
                 }
                

                
          } preview: {
              VStack{
                  if let url = self.imgURL {
                      AsyncImage(url: url) { phase in
                                      switch phase {
                                      case .empty:
                                          ProgressView()
                                      case .success(let image):
                                          image
                                              .resizable()
                                              .scaledToFill()
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
                  Text(movie!.title)
                      .foregroundStyle(.black)
                      .font(.headline)
                 
              }
             
          }
         
          .alert("Movie Status", isPresented: $showingAlert) {
                    Text(alertMsg)
                      Button("OK", role: .cancel) {
                          showingAlert = false
                      }
                     
                  }
          .onAppear(){
              self.imgURL = self.movie?.getPosterURL()
              viewModel.isSavedToFavorite(movie: movie!) { result in
                  if result == true{
                      favIcon = "star.fill"
                  }
                  else{
                      favIcon = "star"
                  }
              }
          }
    }
}
struct HomeView: View {
    //@State private var orientation = UIDeviceOrientation.unknown
    @ObservedObject var viewModel: MovieViewModel = MovieViewModel()
   
    @State var columns: [GridItem] = []
    @State  var title = "Home"
    @State var isWatchlistSavingAlert = false
    @State var watchlistSavingStatus = ""
    var body: some View {
        NavigationView {
            VStack{
                
                HStack(spacing: 2){
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search  by name or symbol here..", text: $viewModel.searhText)
                }
                
                
                
                if viewModel.isLoading{
                    ProgressView()
                }
                if  self.viewModel.movies != nil, !self.viewModel.movies.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(0...(viewModel.movies[0].results.count-1), id: \.self) { index in
                                NavigationLink (destination: MovieInfoView(movie:viewModel.movies[0].results[index])){
                                    MovieCell(movie: viewModel.movies[0].results[index])
                                        .scenePadding(.all)
                                                              }

                               
                                
                            }
                        }
                    }
                }
                Spacer()
                HStack{
                    ScrollView(.horizontal){
                        HStack{
                            Button {
                                title = "Recent Movies"
                                
                                self.viewModel.recentMovies()
                            } label: {
                                VStack{
                                    ZStack {
                                        Circle()
                                            .stroke(.white, lineWidth: 4.0)
                                        
                                            .frame(width: 90, height: 90)
                                        Image(systemName: "clock.arrow.circlepath")
                                            .resizable()
                                            .foregroundColor(.white)
                                        
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                    }
                                    
                                    Text("Recent")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding(.top,-15)
                                }
                                //  .padding(.top,10)
                                // .frame(width: 70)
                            }
                            
                            Button {
                                title = "PlayingNow Movies"
                                
                                self.viewModel.nowPlaying()
                            } label: {
                                VStack{
                                    ZStack {
                                        Circle()
                                            .stroke(.white, lineWidth: 4.0)
                                        
                                            .frame(width: 90, height: 90)
                                        Image(systemName: "arrowtriangle.right.circle.fill")
                                            .resizable()
                                            .foregroundColor(.white)
                                        
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                    }
                                    
                                    Text("Playing Now")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding(.top,-15)
                                }
                                
                            }
                            Button {
                                title = "Upcoming Movies"
                                
                                self.viewModel.upcomingMovies()
                            } label: {
                                VStack{
                                    ZStack {
                                        Circle()
                                            .stroke(.white, lineWidth: 4.0)
                                        
                                            .frame(width: 90, height: 90)
                                        Image(systemName: "arrow.clockwise.circle")
                                            .resizable()
                                            .foregroundColor(.white)
                                        
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                    }
                                    
                                    Text("Upcoming")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding(.top,-15)
                                }
                                
                            }
                            
                            Button {
                                title = "Top Rated Movies"
                                
                                self.viewModel.topRatedMovies()
                            } label: {
                                VStack{
                                    ZStack {
                                        Circle()
                                            .stroke(.white, lineWidth: 4.0)
                                        
                                            .frame(width: 90, height: 90)
                                        Image(systemName: "star.circle.fill")
                                            .resizable()
                                            .foregroundColor(.white)
                                        
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                    }
                                    
                                    Text("TopRated")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding(.top,-15)
                                }
                                
                            }
                            Spacer()
                            Button {
                                title = "Popular Movies"
                                
                                self.viewModel.popularMovies()
                            } label: {
                                VStack{
                                    ZStack {
                                        Circle()
                                            .stroke(.white, lineWidth: 4.0)
                                        
                                            .frame(width: 90, height: 90)
                                        Image(systemName: "star.square.on.square")
                                            .resizable()
                                            .foregroundColor(.white)
                                        
                                            .scaledToFit()
                                            .frame(width: 75, height: 75)
                                    }
                                    
                                    Text("Popular")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding(.top,-15)
                                    
                                }
                                
                            }
                            Button {
                                title = "Random Movies"
                                
                                
                                self.viewModel.randomMovie()
                            } label: {
                                VStack{
                                    ZStack {
                                        Circle()
                                            .stroke(.white, lineWidth: 4.0)
                                        
                                            .frame(width: 90, height: 90)
                                        Image(systemName: "questionmark.folder")
                                            .resizable()
                                            .foregroundColor(.white)
                                        
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                    }
                                    
                                    Text("Random")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding(.top,-15)
                                    
                                }
                                
                            }
                            Button {
                                viewModel.saveWatchlist(list: viewModel.movies[0].results) { result in
                                    watchlistSavingStatus = result
                                    isWatchlistSavingAlert = true
                                }
                            } label: {
                                if viewModel.isAddToWatchList{
                                    VStack{
                                        ZStack {
                                            Circle()
                                                .stroke(.white, lineWidth: 4.0)
                                            
                                                .frame(width: 90, height: 90)
                                            Image(systemName: "plus.rectangle.on.rectangle")
                                                .resizable()
                                                .foregroundColor(.white)
                                            
                                            
                                                .frame(width: 70, height: 70)
                                                .scaledToFit()
                                        }
                                        
                                        Text("AddToWatchList")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .padding(.top,-15)
                                        
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    .padding(.top, 5)
                }
                
                .frame(height: 110)
                
                .background(Color.black.opacity(0.5))
                .cornerRadius(15)
                
                
            }
            .alert("Watchlist saving status", isPresented: $isWatchlistSavingAlert) {
                Button(watchlistSavingStatus, role: .cancel) { }
              
            }
            .background(.white)
            .onAppear(){
                if self.viewModel.movies.count <= 0{
                    title = "Recent Movies"
                    self.viewModel.recentMovies()
                    self.columns.removeAll()
                    //  print(geometry.size)
                    let n = Int( UIScreen.main.bounds.width / 115)
                    for _ in 1...n{
                        columns.append(GridItem(.flexible()))
                    }
                }
               
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                
                // Give a moment for the screen boundaries to change after
                // the device is rotated
                Task { @MainActor in
                    try await Task.sleep(for: .seconds(0.1))
                    withAnimation {
                        let h =  UIScreen.main.bounds.height
                        let w =   UIScreen.main.bounds.width
                        
                        self.columns.removeAll()
                        print(w)
                        let n = Int( w / 115)
                        for _ in 1...n{
                            columns.append(GridItem(.flexible()))
                        }
                    }
                }
            }
            .navigationTitle(title)
            
        }
            
       
    }
}

#Preview {
    HomeView()
}
