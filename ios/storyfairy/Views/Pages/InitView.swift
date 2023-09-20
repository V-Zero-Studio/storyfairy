//
//  InitView.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/18/23.
//

import SwiftUI

enum InitViewStatus {
    case choosingCharacters
    case choosingScene
}


struct InitView: View {
    @State var status: InitViewStatus = InitViewStatus.choosingCharacters
    @State var selectedCharacters: [String] = []
    @State var selectedScenes: [String] = []
    
    @State var nextLoading: Bool = false
    @State var nextAlert: Bool = false
    
    
    @StateObject private var characterChoicesFetcher = CharacterChoicesFetcher()
    
    @StateObject private var sceneChoicesFetcher = SceneChoicesFetcher()
    
    @StateObject private var slideFetcher = SlideFetcher()
        
    @EnvironmentObject var storyViewModel: StoryViewModel
    
    
    var body: some View {
        VStack {
            Spacer()
            
            // TagSelection
            
            VStack {
                Text("Let's Make a Story!")
                    .foregroundColor(Color("UCLAPrimaryColor"))
                    .font(.customTitle).padding()
                
                Text(status == .choosingCharacters ? "Step 1: Select Two or More Characters": "Step 2: Select the Story Scene").font(.customBody)
                
                if status == .choosingCharacters {
                    TagSelectionView(choices: characterChoicesFetcher.data ?? [], loading: characterChoicesFetcher.isRefreshing, selected: $selectedCharacters, single: false)
                        .padding(.horizontal)
                        .onAppear {
                            storyViewModel.reset()
                        }
                    //                        .onAppear(perform: characterChoicesFetcher.fetch)
                        .alert(characterChoicesFetcher.error?.localizedDescription ?? "Unknown error", isPresented: $characterChoicesFetcher.hasError) {
                            Button("Retry") {
                                    Task {
                                        await characterChoicesFetcher.fetch()
                                    }
                                }
                            
                            
                        }
                } else {
                    TagSelectionView(choices: sceneChoicesFetcher.data ?? [], loading: sceneChoicesFetcher.isRefreshing, selected: $selectedScenes, single: true)
                        .padding(.horizontal)
//                        .onAppear(perform: {
//                            sceneChoicesFetcher.fetch(with: SceneChoiceRequestBody(characters: selectedCharacters))
//                        })
                        .alert(sceneChoicesFetcher.error?.localizedDescription ?? "Unknown error", isPresented: $sceneChoicesFetcher.hasError) {
                            Button("Retry") {
                                Task {
                                    nextLoading = true
                                    await sceneChoicesFetcher.fetch(with: SceneChoiceRequestBody(characters: selectedCharacters))
                                    nextLoading = false
                                }
                            }
                        }
                }
            }
            
            Spacer()
            // Footer
            HStack {
                ButtonView(icon: "chevron.left", disabled: status == .choosingCharacters) {
                    status = .choosingCharacters
                }
                
                Spacer()
                
                if status == .choosingCharacters {
                    ButtonView(icon: "chevron.right", disabled: selectedCharacters.count < 2, onClick: {
                                                    storyViewModel.setCharacters(characters: selectedCharacters)
                            nextLoading = true
                            
                            await sceneChoicesFetcher.fetch(with: SceneChoiceRequestBody(characters: selectedCharacters))
                            nextLoading = false
                            
                            status = .choosingScene
                    }, loading: nextLoading)
                } else {
                    ButtonView(icon: "chevron.right", disabled: selectedScenes.isEmpty,
                               onClick: {
                        
                        //                        Task {
                        storyViewModel.setScene(scene: selectedScenes.last ?? "")
                        
                        nextLoading = true
                        
                        await slideFetcher.fetch(with: StoryBody(story: storyViewModel.story))
                        
                        
                        if slideFetcher.data != nil
                        {
                            storyViewModel.addSlide(slide: slideFetcher.data!)
                        }
                        
                        
                        nextLoading = false
                        
                    }, navigateTo: AnyView(StoryView()), loading: nextLoading)
                    .alert(slideFetcher
                        .error?.localizedDescription ?? "Unknown error", isPresented: $slideFetcher.hasError) {
                        Button("Retry") {
                            Task {
                                nextLoading = true
                                await slideFetcher.fetch(with: StoryBody(story: storyViewModel.story))
                                nextLoading = false
                            }
                        }
                    }
                }
                
                
                
                
            }
            .padding(30)
        }
        .toolbar { HeaderToolbar(title: storyViewModel.story.title) }
        .modifier(Header())
        
    }
}

struct InitView_Container: View {
    
    @StateObject var storyViewModel: StoryViewModel = StoryViewModel()
    var body: some View {
        NavigationStack() {
            InitView()
        }
            .environmentObject(storyViewModel)
    }
}

struct InitView_Previews: PreviewProvider {
    static var previews: some View {
        InitView_Container()
    }
}
