//
//  codeHemmingViewModel.swift
//  codeHemming
//
//  Created by grifondev on 28.04.2023.
//
import Foundation

func calculateValues(data: [String]) -> [String] {
    var data = data
    let data_len: Int = data.count

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
    var words_in_2base: [String] = []
    
    for char in message {
        let binary = getBinaryFromChar(char: String(char))  // recieves binary
        
        for val in binary {
            words_in_2base.append(String(val))
        }
    }

    words_in_2base = insertZeroesInPositions(message: words_in_2base)
    //print(words_in_2base)
    words_in_2base = calculateValues(data: words_in_2base)
    //print(words_in_2base)
    
    return words_in_2base
}
