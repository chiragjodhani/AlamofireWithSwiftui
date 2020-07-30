//
//  ContentView.swift
//  AlamofireDemoSwiftui
//
//  Created by Chirag's on 17/04/20.
//  Copyright © 2020 Chirag's. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct ContentView: View {
    @ObservedObject var observe = observer()
    var body: some View {
        Home(albums: $observe.userData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    @Binding var albums: [UserData]
    var body: some View{
        VStack{
            HStack{
                Text("Album Songs")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer(minLength: 0)
            }
            .padding()
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(Color.white.shadow(color: Color.black.opacity(0.18), radius: 5, x: 0, y: 5))
            .zIndex(0)
            
            GeometryReader{mainView in
                List {
                    VStack(spacing: 15){
                        ForEach(self.albums, id: \.id) { album in
                            GeometryReader{item in
                                AlbumView(album: album).scaleEffect(self.scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY),anchor: .bottom).opacity(Double(self.scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY)))
                            }.frame(height: 100)
                        }
                    }.padding(.horizontal)
                        .padding(.top,25)
                }
            }.zIndex(1).background(Color.black.opacity(0.06).edgesIgnoringSafeArea(.all))

        }.edgesIgnoringSafeArea(.top).onAppear { UITableView.appearance().separatorStyle = .none }
    }
    
    // Simple Calculation for scaling Effect...
    
    func scaleValue(mainFrame : CGFloat,minY : CGFloat)-> CGFloat{
        
        // adding animation...
        
        withAnimation(.easeOut){
            
            // reducing top padding value...
            
            let scale = (minY - 25) / mainFrame
            
            // retuning scaling value to Album View if its less than 1...
            
            if scale > 1{
                
                return 1
            }
            else{
                
                return scale
            }
        }
    }
}


struct AlbumView : View {
    var album : UserData
    var body: some View{
        HStack {
            AnimatedImage.init(url: URL(string: album.avatar ?? "")!).frame(width: 100, height: 100).cornerRadius(15)
            VStack(alignment: .leading, spacing: 12) {
                Text(album.name ?? "").fontWeight(.bold).font(.title)
                Text(album.username ?? "")
            }
            .padding(.leading,10)
            Spacer(minLength: 0)
        }
        .background(Color.white.shadow(color: Color.black.opacity(0.12), radius: 5, x: 0, y: 4))
        .cornerRadius(15)
    }
}


class observer : ObservableObject {
    @Published var userData = [UserData]()
    init() {
        API.fetchUserData { (response, error) in
            if error == nil {
                if response != nil {
                    if let userData = response?.data, userData.count > 0 {
                        self.userData = userData
                    }
                }
            }else {
                print("Error:- \(error ?? "")")
            }
        }
    }
}
