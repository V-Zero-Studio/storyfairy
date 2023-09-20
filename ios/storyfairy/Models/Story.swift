//
//  Story.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/18/23.
//

import Foundation

let latentDescriptions: [String] = [
    "magical",
    "whimsical",
    "enchanting",
    "dreamy",
    "curious",
    "brave",
    "imaginative",
    "joyful",
    "cozy",
    "gentle",
    "mysterious",
    "playful",
    "kind",
    "adventurous",
    "lullaby",
    "wonderful",
    "delightful",
    "peaceful",
    "charming",
    "fantastical"
]



struct Slide: Codable {
    var text: String
    var image: String
    var keywords: [String]
    
    init(text: String, image: String, keywords: [String]) {
        self.text = text
        self.image = image
        self.keywords = keywords
    }
}


struct StoryBodyReq: Encodable {
    var characters: [String]
    var scene: String
    var latent: String
    var slides: [Slide]
    var title: String
    
    init(story: Story) {
        self.characters = story.characters
        self.scene = story.scene
        self.latent = story.latent
        self.slides = story.slides
        self.title = story.getTitle(characters: story.characters, scene: story.scene)
    }
}

struct StoryBody: Encodable {
    var story: StoryBodyReq
    var new_keywords: [String]
    
    init(story: Story, new_keywords: [String] = []) {
        self.story = StoryBodyReq(story: story)
        self.new_keywords = new_keywords
    }
}

struct Story: Codable {
//    var title: String
    var characters: [String]
    var scene: String
    var latent: String
    var slides: [Slide]
    
    init(characters: [String], scene: String) {
        self.characters = characters
        self.scene = scene
        self.latent = latentDescriptions.randomElement()!
        self.slides = []
    }
    
    func getTitle(characters: [String], scene: String) -> String {
        var title = ""
        
        var storyString = ""
        
        if characters.isEmpty {
            storyString = ""
        } else if characters.count == 1 {
            storyString = "\(characters[0])"
        } else if characters.count == 2 {
            storyString = "\(characters[0]) and \(characters[1])"
        } else {
            let characterList = characters.dropLast().joined(separator: ", ")
            let lastCharacter = characters.last!
            storyString = "\(characterList) and \(lastCharacter)"
        }
        
        title = "\(storyString) \(scene)".capitalized
        
        return title
    }
    
}

extension Story {
    var title: String {
        getTitle(characters: self.characters, scene: self.scene)
    }
}
