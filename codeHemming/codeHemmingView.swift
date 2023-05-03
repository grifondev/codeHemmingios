//
//  ContentView.swift
//  codeHemming
//
//  Created by grifondev on 28.04.2023.
//

import SwiftUI

struct codeHemmingView: View {

    @State var message = "001110010000" // 001110010100 "Д"
    // 01101001010011100100011101100111100000 "Дима"
    
    @State var display_encoding = false //  flag for view when encoding
    @State var display_decoding = false //  flag for view when encoding
    @State var display_error_no_data = false    //displays error when input is empty
    
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
                        .foregroundColor(Color(red: 148/255, green: 83/255, blue: 198/255))
                }       // caption
                .padding(.top, 20)
                Text("Input your message below:")
                    .font(.custom(Font.bold_font, size: 22))
                    .padding(.top, 2)
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
                }   // input field
                
                Button {
                    var current_decision: String = makeDesision(message: message)
                    
                    if current_decision == "encode" {   //encoding process
                        binary_encoded_data = make2base(message: message)
                        encoded_data = visualiseBinaryData(message: binary_encoded_data)
                        display_encoding = true
                        display_error_no_data = false
                        display_decoding = false
                    } else if current_decision == "decode" {    //decosind process
                        data_to_decode = createEncodableData(message: message)
                        decoded_data = correctMessage(message: data_to_decode)
                        display_error_no_data = false
                        display_encoding = false
                        display_decoding = true
                    } else if current_decision == "bad data" {  //error case
                        display_error_no_data = true
                        display_encoding = false
                        display_decoding = false
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
                        Text("process")
                            .font(.custom(Font.bold_font, size: 25))
                            .padding(.top, 40)
                            .foregroundColor(Color(red: 148/255, green: 83/255, blue: 198/255))
                    }
                    .padding(.top, -40)
                }       // "process" button
                
                if display_error_no_data {  //if input field is empty
                    showErrorEmptyMessage()
                } else {
                    if display_encoding { displayEncodedData() }    //encoding view
                    else if display_decoding { displayDecodedData() }   //decoding view
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 238/255, green: 257/255, blue: 163/255))
        }
    }
    
    func displayEncodedData() -> some View {
        return VStack {
            Text("Your message in binary:")
                .font(.custom(Font.bold_font, size: 18))
                .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                .padding(.top, 5)
            
            displayScrollableData(message: encoded_data)    //message in binary with function of scrolling
                .padding(.top, -5)
            
            Button {
                display_encoding.toggle()
                display_encoding.toggle()   //resets view when state variable was changed
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(red: 123/255, green: 149/255, blue: 56/255))
                        .frame(width: 200, height: 30)
                        .cornerRadius(30)
                        .padding(.top, 3)
                        .padding(.leading, 1)
                    Rectangle()
                        .foregroundColor(Color(red: 203/255, green: 248/255, blue: 84/255))
                        .frame(width: 200, height: 30)
                        .cornerRadius(30)
                        .padding(.trailing, 5)
                    Text("Find bit with error")
                        .font(.custom(Font.bold_font, size: 16))
                        .foregroundColor(Color(red: 148/255, green: 83/255, blue: 198/255))
                }
                .padding(.top, 10)
            }
            
            displayControlBits()    //displays control bits
            
            if calculateChangedBit(array_of_control_bits: control_bits_after) == "0" {  //if all bits by default
                Text("There is no changed bit")
                    .font(.custom(Font.bold_font, size: 18))
                    .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                    .padding(.top, 20)
            } else {    //if any of bit was changed
                Text("Your changed bit is " + calculateChangedBit(array_of_control_bits: control_bits_after))
                    .font(.custom(Font.bold_font, size: 18))
                    .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                    .padding(.top, 20)
            }
        }
    }
    
    func displayDecodedData() -> some View {
        return VStack {
            ZStack {
                Text("Before:")
                    .font(.custom(Font.bold_font, size: 24))
                    .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                    .padding(.top, -40)
                displayScrollableData(message: decoded_data)
                    .padding(.top, 50)
                Rectangle()
                    .padding(.top, 50)
                    .foregroundColor(Color(red: 1, green: 1, blue: 1, opacity: 0))
                    .frame(width: 350, height: 50)
            }   //data before decoding
            ZStack {
                Text("After:")
                    .font(.custom(Font.bold_font, size: 24))
                    .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                    .padding(.top, -40)
                displayScrollableData(message: data_to_decode)
                    .padding(.top, 50)
                Rectangle()
                    .padding(.top, 50)
                    .foregroundColor(Color(red: 1, green: 1, blue: 1, opacity: 0))
                    .frame(width: 350, height: 50)
            }   //data after decoding
            
            if calculateChangedBit(array_of_control_bits: decode_control_bits) == "0" { //if message was without error
                Text("There is no changed bits in your message")
                    .font(.custom(Font.bold_font, size: 24))
                    .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                    .multilineTextAlignment(.center)
                    .frame(width: 300, height: 75, alignment: .center)
                    .padding(.top, 25)

            } else {    //if there are some errors in the message
                Text("The problem was in " + calculateChangedBit(array_of_control_bits: decode_control_bits) +  " bit")
                    .font(.custom(Font.bold_font, size: 20))
                    .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                    .padding(.top, 25)
                Text("Your string was: \"" + decodedString() + "\"")
                    .font(.custom(Font.bold_font, size: 24))
                    .foregroundColor(Color(red: 94/255, green: 32/255, blue: 141/255))
                    .padding(.top, 25)
            }
        }
    }
    
    func displayScrollableData(message: [char]) -> some View {      //returns horizontal scrollview with inputed data
        return ZStack {
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

func showErrorEmptyMessage() -> some View {     //returns when no data in input field
    Text("Input any message to encode or decode!")
        .font(.custom(Font.bold_font, size: 24))
        .foregroundColor(Color.red)
        .multilineTextAlignment(.center)
        .frame(width: 300)
}

func displayControlBits() -> some View {    //displays control bits when encoding
    return VStack {
        Text("Control bits:")
            .font(.custom(Font.bold_font, size: 24))
            .foregroundColor(Color(red: 148/255, green: 83/255, blue: 198/255))
            .padding(.top, 10)
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
            encoded_data = changeValueOfOneChar(char: self, chars: encoded_data)    //changing value in mutable data
            encoded_data = calculateError(chars: encoded_data)  //calculating char with error
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
