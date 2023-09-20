//
//  InitViewModel.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/18/23.
//

import Foundation

class CharacterChoicesFetcher: DataFetcher<[TagSelectionChoice]> {
    convenience init() {
        self.init(endpoint: .fetchCharacterChoices)
        
        Task {
            await self.fetch()
        }
    }
}

class SceneChoicesFetcher: DataFetcher<[TagSelectionChoice]> {
    convenience init() {
        self.init(endpoint: .fetchSceneChoices)
    }
}
