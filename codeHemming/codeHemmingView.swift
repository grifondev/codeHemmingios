//
//  ContentView.swift
//  codeHemming
//
//  Created by grifondev on 28.04.2023.
//

import SwiftUI

struct codeHemmingView: View {

    @State var message = "Дима" // 001110010100
    // 01111001010011100100011101100111100000
    
    @State var display_legal_error = false
    
    @State var display_error_no_data = false
    
    @State var display_encoded_message = false
    
    @State var disassembled_message: [String] = []
    
    var body: some View {
        NavigationView {
            VStack (){
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(red: 123/255, green: 149/255, blue: 56/255))
                        .frame(width: 350, height: 90)
                        .cornerRadius(30)
                        .padding(.top, 10)
                        .padding(.leading, 5)
                    Rectangle()
                        .foregroundColor(Color(red: 203/255, green: 248/255, blue: 84/255))
                        .frame(width: 350, height: 90)
                        .cornerRadius(30)
                        .padding(.trailing, 5)
                    Text("Hemming code")
                        .font(.custom(Font.bold_font, size: 35))
                        .padding(.top, 10)
                        .foregroundColor(Color(red: 148/255, green: 83/255, blue: 198/255))
                }
                .padding(.top, 40)
                Text("Input your message below:")
                    .font(.custom(Font.bold_font, size: 22))
                    .padding(.top, 10)
                    .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                ZStack {
                    TextField("Input your message here", text: $message)
                        .font(.custom(Font.italic_font, size: 20))
                        .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                        .padding(.leading, UIScreen.screenWidth*0)
                        .multilineTextAlignment(.center)
                        .frame(width: 250, height: 20, alignment: .center)
                    Rectangle()
                        .foregroundColor(Color(red: 123/255, green: 149/255, blue: 56/255))
                        .frame(width: 275, height: 3)
                        .cornerRadius(10)
                        .padding(.top, 40)
                        .padding(.leading, UIScreen.screenWidth*0)
                }
                
                Button {
                    if makeDesision(message: message) == "encode" {
                        disassembled_message = make2base(message: message)
                        encoded_data = createButtonsFromMessage(message: disassembled_message)
                        display_legal_error = true
                        display_error_no_data = false
                        display_encoded_message = false
                    } else if makeDesision(message: message) == "decode" {
                        decoded_data = createMessageToDecode(message: message)
                        decoded_data_after = correctMessage(message: decoded_data)
                        display_error_no_data = false
                        display_legal_error = false
                        display_encoded_message = true
                    } else if makeDesision(message: message) == "bad data" {
                        display_error_no_data = true
                        display_legal_error = false
                        display_encoded_message = false
                    }
                
                    
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
                            .font(.custom(Font.bold_font, size: 25))
                            .padding(.top, 40)
                            .foregroundColor(Color(red: 148/255, green: 83/255, blue: 198/255))
                    }
                    .padding(.top, -40)
                }
                
                if display_error_no_data {
                    swowErrorBadData()
                } else {
                    
                    if display_legal_error {
                        if disassembled_message.count > 0 {
                            Text("Your message in binary:")
                                .font(.custom(Font.bold_font, size: 14))
                                .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                                .padding(.top, 5)
                            displayBinaryMessage(message: encoded_data)
                        }
                        
                        displayControlBits()
                        Text("Your changed bit is " + calculateChangedBit(array_of_control_bits: control_bits_after))
                            .font(.custom(Font.bold_font, size: 18))
                            .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                            .padding(.top, 40)
                    }
                    
                    if display_encoded_message {
                        Text("Before:")
                            .font(.custom(Font.bold_font, size: 24))
                            .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                            .padding(.top, 25)
                        displayEncodedData(message: decoded_data_after)
                        Text("After:")
                            .font(.custom(Font.bold_font, size: 24))
                            .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                            .padding(.top, 25)
                        displayEncodedData(message: decoded_data)
                        Text("The problem was in " + calculateChangedBit(array_of_control_bits: decode_control_bits) +  " bit")
                            .font(.custom(Font.bold_font, size: 20))
                            .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                            .padding(.top, 25)
                        Text("Your string was: \"" + getResultDecodedString() + "\"")
                            .font(.custom(Font.bold_font, size: 24))
                            .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                            .padding(.top, 25)
                    }
                        
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 238/255, green: 257/255, blue: 163/255))
        }
    }
    
    func displayBinaryMessage(message: [char]) -> some View {
        return VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(red: 183/255, green: 208/255, blue: 84/255))
                    .frame(width: 350, height: 50)
                    .cornerRadius(60)
                    .padding(.top,3)
                    .padding(.leading,3)
                Rectangle()
                    .foregroundColor(Color(red: 183/255, green: 248/255, blue: 84/255))
                    .frame(width: 350, height: 50)
                    .cornerRadius(60)
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack {
                        HStack {
                            ForEach(message, id: \.id) { one_char in
                                VStack {
                                    Text(String(one_char.id))
                                        .font(.custom(Font.bold_font, size: 14))
                                        .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                                        .multilineTextAlignment(.center)
                                    char(id: one_char.id, value: String(one_char.value))
                                }
                            }
                        }
                    }
                }
                .frame(width: 310)
                .multilineTextAlignment(.center)
            }
            
            Button {
                display_legal_error.toggle()
                display_legal_error.toggle()
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(red: 123/255, green: 149/255, blue: 56/255))
                        .frame(width: 200, height: 25)
                        .cornerRadius(30)
                        .padding(.top, 3)
                        .padding(.leading, 1)
                    Rectangle()
                        .foregroundColor(Color(red: 203/255, green: 248/255, blue: 84/255))
                        .frame(width: 200, height: 25)
                        .cornerRadius(30)
                        .padding(.trailing, 5)
                    Text("find bit with error")
                        .font(.custom(Font.bold_font, size: 16))
                        .foregroundColor(Color(red: 148/255, green: 83/255, blue: 198/255))
                }
            }
        }
    }
    
    func displayEncodedData(message: [char]) -> some View {
        return VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(red: 183/255, green: 208/255, blue: 84/255))
                    .frame(width: 350, height: 50)
                    .cornerRadius(60)
                    .padding(.top,3)
                    .padding(.leading,3)
                Rectangle()
                    .foregroundColor(Color(red: 183/255, green: 248/255, blue: 84/255))
                    .frame(width: 350, height: 50)
                    .cornerRadius(60)
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack {
                        HStack {
                            ForEach(message, id: \.id) { one_char in
                                VStack {
                                    Text(String(one_char.id))
                                        .font(.custom(Font.bold_font, size: 14))
                                        .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                                        .multilineTextAlignment(.center)
                                    char(id: one_char.id, value: String(one_char.value))
                                }
                            }
                        }
                    }
                }
                .frame(width: 310)
                .multilineTextAlignment(.center)
            }
        }
    }
}



func swowErrorBadData() -> some View {
    Text("Input any data to encode or decode!")
        .font(.custom(Font.bold_font, size: 24))
        .foregroundColor(Color.red)
        .multilineTextAlignment(.center)
        .frame(width: 300)
}

func displayControlBits() -> some View {
    return VStack {
        Text("Control bits:")
            .font(.custom(Font.bold_font, size: 24))
            .foregroundColor(Color(red: 148/255, green: 83/255, blue: 198/255))
            .padding(.top, 30)
        HStack {
            VStack {
                Text("Before:")
                    .font(.custom(Font.bold_font, size: 20))
                    .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                if control_bits_before.isEmpty {
                    Text("first convert your message to binary")
                        .font(.custom(Font.bold_font, size: 12))
                        .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                        .multilineTextAlignment(.center)
                        .frame(width: 100)
                } else {
                    ForEach(control_bits_before, id: \.id) { bit in
                        Text(bit.bit)
                            .font(.custom(Font.bold_font, size: 12))
                            .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                            .padding(.all, 1)
                    }
                }
            }
            Text("-->")
                .font(.custom(Font.bold_font, size: 20))
                .foregroundColor(Color(red: 148/255, green: 83/255, blue: 198/255))
                .multilineTextAlignment(.center)
                .padding(.all, 30)
            VStack {
                Text("After:")
                    .font(.custom(Font.bold_font, size: 20))
                    .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                if control_bits_after.isEmpty {
                    Text("select 1 random bit to continue")
                        .font(.custom(Font.bold_font, size: 12))
                        .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                        .multilineTextAlignment(.center)
                        .frame(width: 100)
                } else {
                    ForEach(control_bits_after, id: \.id) { bit in
                        Text(bit.bit)
                            .font(.custom(Font.bold_font, size: 12))
                            .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                            .padding(.all, 1)
                    }
                }
            }
        }
        .padding(.top, -10)
    }
}

public struct char: View {
    var id: Int
    var value: String
    public var body: some View {
        Button {
            encoded_data = changeValue(char: self, chars: encoded_data)
            encoded_data = calculateError(chars: encoded_data)
        } label: {
            Text(value)
                .font(.custom(Font.bold_font, size: 18))
                .foregroundColor(Color.purple)
        }
    }
}

struct codeHemmingView_Previews: PreviewProvider {
    static var previews: some View {
        codeHemmingView()
    }
}
