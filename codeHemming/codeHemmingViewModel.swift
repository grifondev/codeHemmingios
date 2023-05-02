//
//  codeHemmingViewModel.swift
//  codeHemming
//
//  Created by grifondev on 28.04.2023.
//
import Foundation

var encoded_data: [char] = []
var decoded_data: [char] = []
var decoded_data_after: [char] = []

var control_bits_before: [control_bits] = []
var control_bits_after: [control_bits] = []
var decode_control_bits: [control_bits] = []

func getResultDecodedString() -> String {
    var result_string: String = ""
    let banned_ids: [Int] = [1,2,4,8,16,32,64,128,256,512,1024]
    
    for item in decoded_data {
        if banned_ids.contains(item.id) {
            
        } else {
            result_string += item.value
        }
    }
    
    var res = strtoul(result_string, nil, 2)
    var res1 = Int(res)
    result_string = String(UnicodeScalar(res1 + 848)!)
    
    return result_string
}

func correctMessage(message: [char]) -> [char] {
    var temp_array: [String] = []
    var data_to_decode: [char] = []
    
    for item in message {
        temp_array.append(item.value)
    }
    
    temp_array = calculateControlBits(data: temp_array, forDecode: true)
    let changed_bit = calculateChangedBit(array_of_control_bits: decode_control_bits)
    
    data_to_decode = decoded_data
    for item in data_to_decode {
        if String(item.id) == changed_bit {
            decoded_data = changeValue(char: item, chars: decoded_data)
            break
        }
    }
    
    return data_to_decode
}

func createMessageToDecode(message: String) -> [char] {
    let message: String = message
    var temp_arr: [String] = []
    var decoded_message: [char] = []
    
    for char in message {
        temp_arr.append(String(char))
    }
    
    for i in 0...temp_arr.count-1 {
        decoded_message.append(char(id:i+1, value: temp_arr[i]))
    }

    return decoded_message
}

func makeDesision(message: String) -> String {
    if message.isEmpty {
        return "bad data"
    } else if (message.first?.unicodeScalars.first?.value == "1".unicodeScalars.first?.value ||
               message.first?.unicodeScalars.first?.value == "0".unicodeScalars.first?.value) {
        return "decode"
    }
    return "encode"
}

func calculateChangedBit(array_of_control_bits: [control_bits]) -> String {
    var sum = 0
    
    if !array_of_control_bits.isEmpty {
        for i in 0...array_of_control_bits.count-1 {
            if (Int(array_of_control_bits[i].bit)! % 2 == 1) {
                sum += NSDecimalNumber(decimal: pow(2, i)).intValue
            }
        }
    }
    
    return sum > 0 ? String(sum) : "all bits are good"
}

func calculateError(chars: [char]) -> [char]{
    control_bits_after = []
    var data: [String] = []
    
    for item in chars {
        data.append(item.value)
    }
    data = calculateControlBits(data: data, onlyShow: true)
    
    var new_chars: [char] = []
    for i in 0...data.count-1 {
        new_chars.append(char(id: i+1, value: data[i]))
    }
    
    return new_chars
}

func createButtonsFromMessage(message: [String]) -> [char] {
    var chars: [char] = []
    for i in 0...message.count-1 {
        chars.append(char(id: i+1, value: message[i]))
    }
    return chars
}

func changeValue(char: char, chars: [char]) -> [char] {
    var char = char
    var temp_char: [char] = chars

    for elem in temp_char {
        if elem.id == char.id {
            if char.value == "0" {
                char.value = "1"
            } else if char.value == "1" {
                char.value = "0"
            }
            temp_char.remove(at: char.id-1)
            temp_char.insert(char, at: char.id-1)

            break
        }
    }
    return temp_char
}

func calculateControlBits(data: [String], onlyShow: Bool = false, forDecode: Bool = false) -> [String] {
    var data = data
    let data_len: Int = data.count
    
    var step: Int = 0
    
    var current_position = 1
    var counter: Int = 0
    
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
        let isOne = count_of_ones % 2
        
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
        
        counter += 1
        current_position = NSDecimalNumber(decimal: pow(2, counter)).intValue
        step = current_position-1
    }
    
    return data
}

func getBinaryFromChar(char: String) -> String {
    let asciiChar: UInt32? = char.unicodeScalars.first?.value
    var asciiCode = asciiChar!
    
    if asciiCode > 1000 {
        asciiCode -= 848
    }       //if the symbol is russian
    
    let char_second_base: String = String(asciiCode, radix: 2) //   convert to 2 base
    
    //print(String(asciiCode) + " --> " + char_second_base)
    
    return char_second_base
}

func insertZeroesInPositions(message:[String]) -> [String] {
    var message = message
    
    let arrayLen: Int = message.count
    var counter: Int = 0
    var currentPosition = 1

    while currentPosition <= arrayLen {
        message.insert("0", at: currentPosition-1)
        
        counter += 1
        currentPosition = NSDecimalNumber(decimal: pow(2, counter)).intValue
    }
    
    return message
}

func make2base(message: String) -> [String] {
    control_bits_before = []
    
    var words_in_2base: [String] = []
    
    for char in message {
        let binary = getBinaryFromChar(char: String(char))  // recieves binary
        
        for val in binary {
            words_in_2base.append(String(val))
        }
    }

    words_in_2base = insertZeroesInPositions(message: words_in_2base)
    
    words_in_2base = calculateControlBits(data: words_in_2base)
    
    return words_in_2base
}
