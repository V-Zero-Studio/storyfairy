//
//  TagSelectionChoice.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/19/23.
//

import Foundation


struct TagSelectionChoice: Codable, Hashable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

struct SceneChoiceRequestBody: Encodable {
    var characters: [String]
    
    init(characters: [String]) {
        self.characters = characters
    }
}
