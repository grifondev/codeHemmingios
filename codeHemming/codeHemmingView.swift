//
//  ContentView.swift
//  codeHemming
//
//  Created by grifondev on 28.04.2023.
//

import SwiftUI

struct codeHemmingView: View {

    @State var message = "Дима"
    
    let italic_font = "LibreBaskerville-Italic"
    let bold_font = "LibreBaskerville-Bold"
    
    var body: some View {
        NavigationView {
            VStack (){
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(red: 123/255, green: 149/255, blue: 56/255))
                        .frame(width: 350, height: 90)
                        .cornerRadius(30)
                        .padding(.top, 50)
                        .padding(.leading, 5)
                    Rectangle()
                        .foregroundColor(Color(red: 203/255, green: 248/255, blue: 84/255))
                        .frame(width: 350, height: 90)
                        .cornerRadius(30)
                        .padding(.top, 40)
                        .padding(.trailing, 5)
                    Text("Hemming code")
                        .font(.custom(bold_font, size: 35))
                        .padding(.top, 50)
                        .foregroundColor(Color(red: 148/255, green: 83/255, blue: 198/255))
                }
                Text("Input your message below:")
                    .font(.custom(bold_font, size: 22))
                    .padding(.top, 30)
                    .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                ZStack {
                    TextField("Input your message here", text: $message)
                        .font(.custom(italic_font, size: 20))
                        .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                        .padding(.top, 25)
                        .padding(.leading, UIScreen.screenWidth*0)
                        .multilineTextAlignment(.center)
                    Rectangle()
                        .foregroundColor(Color(red: 123/255, green: 149/255, blue: 56/255))
                        .frame(width: 275, height: 3)
                        .cornerRadius(10)
                        .padding(.top, 70)
                        .padding(.leading, UIScreen.screenWidth*0)
                }
                
                Button {
                    make2base(message: message)
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(red: 123/255, green: 149/255, blue: 56/255))
                            .frame(width: 200, height: 50)
                            .cornerRadius(30)
                            .padding(.top, 46)
                            .padding(.leading, 1)
                        Rectangle()
                            .foregroundColor(Color(red: 203/255, green: 248/255, blue: 84/255))
                            .frame(width: 200, height: 50)
                            .cornerRadius(30)
                            .padding(.top, 40)
                            .padding(.trailing, 5)
                        Text("convert")
                            .font(.custom(bold_font, size: 25))
                            .padding(.top, 40)
                            .foregroundColor(Color(red: 148/255, green: 83/255, blue: 198/255))
                    }
                    .padding(.top, -30)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 238/255, green: 257/255, blue: 163/255))
        }
    }
}

struct codeHemmingView_Previews: PreviewProvider {
    static var previews: some View {
        codeHemmingView()
    }
}
