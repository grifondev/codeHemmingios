//
//  codeHemmingViewModel.swift
//  codeHemming
//
//  Created by grifondev on 28.04.2023.
//
import Foundation

var binary_encoded_data: [String] = []  //encoded data in binary

var encoded_data: [char] = []   //result of encoding
var data_to_decode: [char] = [] //message in binary before decode
var decoded_data: [char] = []   //result of decoding

var control_bits_before: [control_bits] = []    //control bits before changing "error" bit
var control_bits_after: [control_bits] = [] // control bits after changing "error" bit
var decode_control_bits: [control_bits] = []    //control bits for decode. Neccessary for calculating changed bit

func divideBinaryDataToChars(binary_data: String) -> [String] { //recieves binary data and returns it like array of 8bit strings
    var array_of_chars: [String] = []
    
    var one_char: String = ""
    for item in binary_data {
        one_char += String(item)
        if one_char.count == 8 {
            array_of_chars.append(one_char)
            one_char = ""
        }
    }
    
    return array_of_chars
}

func decodedString() -> String {    //returns result string after decoding
    var decoded_str: String = ""
    var raw_binary: String = ""
    let ids_of_control_bits: [Int] = [1,2,4,8,16,32,64,128,256,512,1024,2048,4096]
    
    for char in data_to_decode {
        if !ids_of_control_bits.contains(char.id) {
            raw_binary += char.value
        }
    }
    
    let binary_data_divided_to_chars: [String] = divideBinaryDataToChars(binary_data: raw_binary)
    
    for i in 0...binary_data_divided_to_chars.count-1 {
        let char_10base = strtoul(binary_data_divided_to_chars[i], nil, 2)  //make str to 10 base
        decoded_str += String(UnicodeScalar(Int(char_10base) + 848)!)
    }
    
    return decoded_str
}

func correctMessage(message: [char]) -> [char] {    //changing "error" bit
    var raw_string: [String] = []
    var changed_data: [char] = []
    
    for item in message {
        raw_string.append(item.value)
    }
    
    raw_string = calculateControlBits(data: raw_string, forDecode: true)
    let changed_bit = calculateChangedBit(array_of_control_bits: decode_control_bits)
    
    changed_data = data_to_decode
    for item in changed_data {
        if String(item.id) == changed_bit {
            data_to_decode = changeValueOfOneChar(char: item, chars: data_to_decode)
            break
        }
    }
    
    return changed_data
}

func createEncodableData(message: String) -> [char] {   //converting message to viewable struct
    decode_control_bits = []
    var index: Int = 1
    var decoded_message: [char] = []
    
    for element in message {
        decoded_message.append(char(id: index, value: String(element)))
        index += 1
    }

    return decoded_message
}

func makeDesision(message: String) -> String {  //returns decision what programm will do with inputed message: encode or decode. Returns bad data when input is empty
    if message.isEmpty {
        return "bad data"
    } else {
        for char in message {
            if String(char) != "1" && String(char) != "0" {
                return "encode"
            }
        }
    }
    return "decode"
}

func calculateChangedBit(array_of_control_bits: [control_bits]) -> String { //usable when encoding. Returns position of "error" bit
    var bit_with_error = 0
    
    if !array_of_control_bits.isEmpty {
        for i in 0...array_of_control_bits.count-1 {
            if (Int(array_of_control_bits[i].bit)! % 2 == 1) {
                bit_with_error += NSDecimalNumber(decimal: pow(2, i)).intValue
            }
        }
    }
    
    return bit_with_error > 0 ? String(bit_with_error) : "0"
}

func calculateError(chars: [char]) -> [char]{   //  calculates control bits when encoding and the message already has error
    control_bits_after = []
    var control_bits: [String] = []
    var final_control_bits: [char] = []
    
    for item in chars {
        control_bits.append(item.value)
    }
    
    control_bits = calculateControlBits(data: control_bits, onlyShow: true)
    
    for i in 0...control_bits.count-1 {
        final_control_bits.append(char(id: i+1, value: control_bits[i]))
    }
    
    return final_control_bits
}

func visualiseBinaryData(message: [String]) -> [char] { // make encodable [data] viewable for display
    var chars: [char] = []
    for i in 0...message.count-1 {
        chars.append(char(id: i+1, value: message[i]))
    }
    return chars
}

func changeValueOfOneChar(char: char, chars: [char]) -> [char] {    //  changing value of one char. Returns new data
    var char_to_change = char
    var new_data: [char] = chars

    for elem in new_data {
        if elem.id == char_to_change.id {
            if char_to_change.value == "0" {
                char_to_change.value = "1"
            } else if char_to_change.value == "1" {
                char_to_change.value = "0"
            }
            new_data.remove(at: char_to_change.id-1)    //  remove wrong value
            new_data.insert(char_to_change, at: char_to_change.id-1)    //  insert correct value

            break
        }
    }
    return new_data
}

func calculateControlBits(data: [String], onlyShow: Bool = false, forDecode: Bool = false) -> [String] {    //calculating all control_bits
    var data = data
    let data_len: Int = data.count
    
    var step: Int = 0
    
    var current_position = 1
    
    while current_position < data_len {
        var count_of_ones = 0
        
        for i in stride(from: step, to: data_len, by: (step+1)*2) {
            for j in 0...step {
                if i+j < data_len {
                    if data[i+j] == "1" {
                        count_of_ones += 1
                    }
                }
            }
        }
        let isOne = count_of_ones & 1
        
        if !onlyShow {
            data[current_position-1] = String(isOne)
        }

        if onlyShow {
            control_bits_after.append(control_bits(bit: String(count_of_ones)))
        } else {
            control_bits_before.append(control_bits(bit: String(count_of_ones + isOne)))
        }
        
        if forDecode {
            decode_control_bits.append(control_bits(bit: String(count_of_ones)))
        }

        current_position <<= 1
        step = current_position-1
    }
    
    return data
}

func getBinaryFromChar(char: String) -> String {    //recieves char and returns binary view of this
    let asciiChar: UInt32? = char.unicodeScalars.first?.value
    var asciiCode = asciiChar!
    
    if asciiCode > 1000 {
        asciiCode -= 848
    }       //if the symbol is russian
    
    let char_second_base: String = String(asciiCode, radix: 2) //   convert decimal to binary
    
    return char_second_base
}

func insertControlBitsInRawMessage(message:[String]) -> [String] {  //returns array of strings with inputed control bits positions
    var message = message
    
    let data_len: Int = message.count
    var counter: Int = 0
    var curr_position = 1

    while curr_position <= data_len {
        message.insert("0", at: curr_position-1)
        
        counter += 1
        curr_position = NSDecimalNumber(decimal: pow(2, counter)).intValue  //  calculating position of the next control bit
    }
    
    return message
}

func make2base(message: String) -> [String] {   //  returns array of binary data
    control_bits_before = []
    
    var words_in_2base: [String] = []
    
    for char in message {
        let binary_data = getBinaryFromChar(char: String(char))  // recieves binary
        
        for val in binary_data {
            words_in_2base.append(String(val))  //  appending values
        }
    }

    words_in_2base = insertControlBitsInRawMessage(message: words_in_2base) //  inserting empty control bits into data
    
    words_in_2base = calculateControlBits(data: words_in_2base) //  calculating values for control bits
    
    return words_in_2base
}
