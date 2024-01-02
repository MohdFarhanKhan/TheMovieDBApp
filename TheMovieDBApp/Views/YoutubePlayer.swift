//
//  YoutubePlayer.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 10/05/1445 AH.
//

import SwiftUI
import YouTubePlayerKit
struct YoutubePlayer: View {
    @State var key: String
    @State var title: String
    @State  var youTubePlayer: YouTubePlayer?
   
    var body: some View {
        VStack{
            if self.youTubePlayer != nil{
                YouTubePlayerView(self.youTubePlayer!) { state in
                    // Overlay ViewBuilder closure to place an overlay View
                    // for the current `YouTubePlayer.State`
                    switch state {
                    case .idle:
                        ProgressView()
                    case .ready:
                        EmptyView()
                    case .error(let error):
                        Text(verbatim: "YouTube player couldn't be loaded")
                    }
                }
            }
               
        }
        .navigationTitle(self.title)
        .navigationBarTitleDisplayMode(.inline)
            .onAppear(){
                self.youTubePlayer = YouTubePlayer(
                    source: .video(id: self.key),
                    configuration: .init(
                        autoPlay: true
                    )
                )
            }
    }
}

#Preview {
    YoutubePlayer(key: "psL_5RIBqnY", title: "yes")
}
