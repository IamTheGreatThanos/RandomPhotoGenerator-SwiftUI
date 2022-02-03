//
//  ContentView.swift
//  RandomPhotoGenerator-SwiftUI
//
//  Created by MacBook on 02.02.2022.
//

import SwiftUI

struct ContentView: View {
    
    let colors: [UIColor] = [
        .systemPink,
        .systemPurple,
        .systemOrange,
        .systemGreen,
        .systemBlue,
        .systemYellow
    ]
    
    @State var urlString = "https://source.unsplash.com/random/600x600"
    var titleString = "Random Photo"
    @State var image = UIImage()
    @State var isLoading = true
    
    var body: some View {
        ZStack{
            Color(colors.randomElement()!).ignoresSafeArea(.all)
            VStack{
                Text(titleString).bold().foregroundColor(.white).font(.system(size: 38)).frame(width: UIScreen.main.bounds.width-40, alignment: .leading)
                Spacer().frame(height: 100)
                Image(uiImage: image).background(Color.black)
                    .frame(width: 300, height: 400, alignment: .center).scaledToFill().clipped().cornerRadius(15).overlay(RoundedRectangle(cornerRadius: 15).stroke(.white, lineWidth: 5)).overlay(ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white)).frame(width: 150, height: 150).opacity(isLoading ? 1:0))
                Spacer().frame(height: 100)
                Button(action: {
                    Task{
                        isLoading = true
                        image = await getRandomPhoto()
                    }
                }, label: {
                    Text("Generate").bold().frame(width: 260, height: 60).background(Color.white).foregroundColor(.black).cornerRadius(15)
                })
            }
        }.onAppear{
            Task{
                isLoading = true
                image = await getRandomPhoto()
            }
            
        }
    }
    
    func getRandomPhoto() async -> UIImage{
        let url = URL(string: urlString)!
        guard let data = try? Data(contentsOf: url) else {
            isLoading = false
            return UIImage()
        }
        isLoading = false
        return UIImage(data: data)!
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
