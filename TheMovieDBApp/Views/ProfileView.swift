//
//  ProfileView.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 06/05/1445 AH.
//

import SwiftUI

struct ProfileView: View {
    @State var isProfileSavingAlert = false
    @State var isRegionAlert = false
    @State var profileSavingStatus = ""
    @State var savedRegion: Regions?
    @State var columns: [GridItem] = []
    @ObservedObject var viewModel: MovieViewModel = MovieViewModel()
    var body: some View {
        NavigationView {
            VStack{
                
                VStack(alignment: .center, spacing: 5){
                    HStack{
                        Text("Name :")
                        TextField("Write your name - here..", text: $viewModel.profileStructure.name)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack{
                        Text("Age :")
                        TextField("Write your age - here..", value: $viewModel.profileStructure.age, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack{
                        Text("Favorite Genre :")
                        TextField("Write Favorite genre - here..", text: $viewModel.profileStructure.genre)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack{
                        Text("Favorite  Movie :")
                        TextField("Write Favorite Movie - here..", text: $viewModel.profileStructure.movie)
                            .textFieldStyle(.roundedBorder)
                    }
                    VStack{
                        Button {
                            viewModel.saveProfileInfo(profileInfo: viewModel.profileStructure) { result in
                                isProfileSavingAlert = true
                                profileSavingStatus = result
                            }
                        } label: {
                            HStack{
                                Image(systemName: "folder")
                                    .foregroundColor(.white)
                                Text("Save")
                                    .foregroundColor(.white)
                            }
                            .foregroundColor(.white)
                            
                            
                        }
                        .background(.green)
                    }
                    
                    .frame(width: 75,height: 35)
                    .background(
                        
                        RoundedRectangle(
                            
                            cornerRadius: 5,
                            style: .continuous
                            
                        )
                        .stroke(.green, lineWidth: 2)
                        
                    )
                }
                .padding(.leading, 20)
                .padding( .trailing, 20)
                .fontWeight(.heavy)
                .cornerRadius(10)
                .frame( height: 300, alignment: .center)
               
                Text("Watchlist")
                    .foregroundColor(.black)
                    .fontWeight(.heavy)
                if  self.viewModel.watchlistMovies != nil, !self.viewModel.watchlistMovies!.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(0...(viewModel.watchlistMovies!.count-1), id: \.self) { index in
                                NavigationLink (destination: MovieInfoView(movie:viewModel.watchlistMovies![index])){
                                    MovieCell(movie: viewModel.watchlistMovies![index])
                                        .scenePadding(.all)
                                }
                                
                                
                                
                            }
                        }
                    }
                  
                }
                
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                            if viewModel.regionArray.count > 0{
                                Button {
                                    isRegionAlert = true
                                    savedRegion = viewModel.getSelectedRegion()
                                } label: {
                                    Text("Set Region")
                                    
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
            .alert("Choose to set the region", isPresented: $isRegionAlert) {
                if viewModel.regionArray != nil && viewModel.regionArray.count > 0{
                    ForEach(0...(self.viewModel.regionArray.count-1), id:\.self){ index in
                       
                        Button {
                            viewModel.setSelectedRegion(region: viewModel.regionArray[index])
                        } label: {
                                Text(self.viewModel.regionArray[index].english_name)
                            .foregroundColor(getBgColorForRegion(region: self.viewModel.regionArray[index]))
                            
                        }
                      
                       
                    }
                    Button("OK", role: .cancel) { }
                }
                
            }
            .alert("Profile Saving status", isPresented: $isProfileSavingAlert) {
                Button(profileSavingStatus, role: .cancel) { }
                
            }
            .onAppear(){
                viewModel.getUserProfileInfo()
                viewModel.getWatchlist()
                viewModel.getRegions()
                self.columns.removeAll()
                //  print(geometry.size)
                let n = Int( UIScreen.main.bounds.width / 115)
                for _ in 1...n{
                    columns.append(GridItem(.flexible()))
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
        }
    }
    func getBgColorForRegion(region:Regions)-> Color{
        if let svdRegion = savedRegion, region.iso_3166_1 == svdRegion.iso_3166_1{
            return Color.green
                           }
                           else{
                               return Color.black
                           }
    }
}

#Preview {
    ProfileView()
}
