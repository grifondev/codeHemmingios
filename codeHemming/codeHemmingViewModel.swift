//
//  codeHemmingViewModel.swift
//  codeHemming
//
//  Created by grifondev on 28.04.2023.
//
import Foundation

var chars: [char] = []

var control_bits_before: [control_bits] = []
var control_bits_after: [control_bits] = []

func calculateChangedBit() -> String {
    var sum = 0
    
    if !control_bits_after.isEmpty {
        for i in 0...control_bits_after.count-1 {
            if (Int(control_bits_after[i].bit)! % 2 == 1) {
                sum += NSDecimalNumber(decimal: pow(2, i)).intValue
            }
        }
    }
    
    return sum > 0 ? String(sum) : "none"
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

func calculateControlBits(data: [String], onlyShow: Bool = false) -> [String] {
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
