//
//  ContentView.swift
//  codeHemming
//
//  Created by grifondev on 28.04.2023.
//

import SwiftUI

struct codeHemmingView: View {

    @State var message = "Дима"
    
    @State var disassembled_message: [String] = []
    
    @State var characters: [char] = []
    
    public let italic_font = "LibreBaskerville-Italic"
    public let bold_font = "LibreBaskerville-Bold"
    
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
                    disassembled_message = make2base(message: message)
                    characters = createButtonsFromMessage(message: disassembled_message)
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
                
                if disassembled_message.count > 0 {
                    displayBinaryMessage(message: characters)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 238/255, green: 257/255, blue: 163/255))
        }
    }
}

struct char: View {
    var id: Int
    var value: String
    var body: some View {
        Button {
            
        } label: {
            Text(value)
                .foregroundColor(Color.red)
        }
    }
}

func displayBinaryMessage(message: [char]) -> some View {
    return ScrollView(.horizontal, showsIndicators: false) {
        HStack {
            ForEach(message, id: \.id) { one_char in
                char(id: one_char.id, value: String(one_char.value))
            }
        }
    }
    .frame(width: 300)
    .multilineTextAlignment(.center)
}

func changeValue(char: char) -> char {
    var char = char
    if char.value == "0" {
        char.value = "1ONE"
    } else {
        char.value = "0ZERO"
    }
    return char
}

struct codeHemmingView_Previews: PreviewProvider {
    static var previews: some View {
        codeHemmingView()
    }
}
