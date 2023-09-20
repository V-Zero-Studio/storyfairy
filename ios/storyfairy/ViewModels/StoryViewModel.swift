//
//  StoryViewModel.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/21/23.
//

import SwiftUI

class SlideFetcher: DataFetcher<Slide> {
    convenience init() {
        self.init(endpoint: .fetchSlide)
    }
}

class KeywordsFetcher: DataFetcher<[String]> {
    convenience init() {
        self.init(endpoint: .fetchKeywordsChoices)
    }
}

class StoryViewModel: ObservableObject {
    @Published var story: Story = Story(characters: [], scene: "")
    
    
//    @StateObject var slideFetcher = SlideFetcher()
//    @StateObject var keywordsFetcher = KeywordsFetcher()
    
    func setCharacters(characters: [String]) {
        self.story.characters = characters
    }
    
    func setScene(scene: String) {
        self.story.scene = scene
    }
    
    
    func setBasicInfo(characters: [String], scene: String) {
        self.story.characters = characters
        self.story.scene = scene
    }
    
    func addSlide(slide: Slide) {
        self.story.slides.append(slide)
    }
    
//    func fetchSlide() async {
//        await self.slideFetcher.fetch(with: self.story)
//    }
//
//    func fetchKeywords() async {
//        await self.keywordsFetcher.fetch(with: self.story)
//    }
    
    func reset() {
        self.story = Story(characters: [], scene: "")
    }
    
}
