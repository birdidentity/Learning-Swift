//
//  Emoji.swift
//  EmojiDictionary
//
//  Created by Vladislav Boyko on 11/17/19.
//  Copyright © 2019 Buckwheat. All rights reserved.
//

import Foundation

struct Emoji: Codable {
    var symbol: String
    var name: String
    var description: String
    var usage: String
    
    init(symbol: String, name: String, description: String, usage: String) {
        self.symbol = symbol
        self.name = name
        self.description = description
        self.usage = usage
    }
    
    static let ArchiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("emojis").appendingPathExtension("plist")
    
    static func saveToFile(emojis: [Emoji]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodeEmojis = try? propertyListEncoder.encode(emojis)
        
        try? encodeEmojis?.write(to: Emoji.ArchiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [Emoji]? {
        let propertyListDecoder = PropertyListDecoder()
        
        guard let retrievedEmojisData = try? Data(contentsOf: Emoji.ArchiveURL),
        let decodedEmojis = try? propertyListDecoder.decode(Array<Emoji>.self, from: retrievedEmojisData) else {return nil}
       
       return decodedEmojis
    }
    
    static func loadSampleEmojis() -> [Emoji] {
        if let loadedData = Emoji.loadFromFile() {
            return loadedData
        } else {
            return [
            Emoji(symbol: "😀", name: "Grinning Face",description: "A typical smiley face.", usage: "happiness"),
            Emoji(symbol: "😕", name: "Confused Face",description: "A confused, puzzled face.", usage: "unsurewhat to think; displeasure"),
            Emoji(symbol: "😍", name: "Heart Eyes",description: "A smiley face with hearts for eyes.",usage: "love of something; attractive"),
            Emoji(symbol: "👮", name: "Police Officer",description: "A police officer wearing a blue cap with a goldbadge.", usage: "person of authority"),
            Emoji(symbol: "🐢", name: "Turtle", description:"A cute turtle.", usage: "Something slow"),
            Emoji(symbol: "🐘", name: "Elephant", description:"A gray elephant.", usage: "good memory"),
            Emoji(symbol: "🍝", name: "Spaghetti",description: "A plate of spaghetti.", usage: "spaghetti"),
            Emoji(symbol: "🎲", name: "Die", description: "Asingle die.", usage: "taking a risk, chance; game"),
            Emoji(symbol: "⛺️", name: "Tent", description: "Asmall tent.", usage: "camping"),
            Emoji(symbol: "📚", name: "Stack of Books",description: "Three colored books stacked on each other.",usage: "homework, studying"),
            Emoji(symbol: "💔", name: "Broken Heart",description: "A red, broken heart.", usage: "extremesadness"), Emoji(symbol: "💤", name: "Snore",description:"Three blue \'z\'s.", usage: "tired, sleepiness"),
            Emoji(symbol: "🏁", name: "Checkered Flag",description: "A black-and-white checkered flag.", usage:"completion")]
        }
    }
}
