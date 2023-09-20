//
//  TagSelectionView.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/18/23.
//

import SwiftUI


func generateRandomTagChoices(size: Int) -> [TagSelectionChoice] {
    guard size > 0 else {
        return [TagSelectionChoice]()
    }
    
    var results:[TagSelectionChoice] = []
    
    for result in 0..<size {
        results.append(TagSelectionChoice(name: "Item-\(result)", image: "https://picsum.photos/150"))
    }
    
    return results
}

struct SimpleTagSelectionView: View {
    let title: String?
    let choices: [String]
    @Binding var selected: String?
    
    let columns = [GridItem(.adaptive(minimum: 10), spacing: 25, alignment: .center), GridItem(.flexible(), spacing: 25, alignment: .center)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if (title != nil) {
                Text(title!).font(.title).foregroundColor(Color("UCLAPrimaryColor"))
            }
            VStack(
                alignment: .leading,
                spacing: 15
//                vSpacing: 15,
            ) {
                ForEach (choices, id: \.self) {choice in
                    Button(action: {
                        if selected == choice {
                            selected = nil
                        } else {
                            selected = choice
                        }
                    }, label: {
                        
                        Text(choice)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .font(.customCaption)
                            .foregroundColor(
                                choice == selected ? Color.white : Color("UCLAPrimaryColor")
                            )
                            .background(
                                choice == selected ? Color("UCLAPrimaryColor") : .white
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.gray, lineWidth: 1)
                                    
                            )
                            .cornerRadius(15)
                            .shadow(radius: 5)
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 5)
                    })
                }
            }
        }
    }
}

struct TagSelectionView: View {
    let choices: [TagSelectionChoice]
    let loading: Bool
    @Binding var selected: [String]
    var single: Bool
    
    
    
    let rows = [GridItem(.fixed(175), spacing: 25, alignment: .center), GridItem(.fixed(175), spacing: 25, alignment: .center)]
    
    func onSelect(_ item: String) -> Void {
        if single {
            if selected.contains(item) {
                selected = []
            } else {
                selected = [item]
            }
        } else {
            if selected.contains(item) {
                selected.removeAll { $0 == item }
            } else {
                selected.append(item)
            }
        }
    }
    
    var body: some View {
        VStack {
//            HStack {
//                if selected.isEmpty {
//                    Text("You haven't selected any.").font(.caption).padding(.vertical, 7.0)
//                }
//                ForEach (selected, id: \.self) { selected_item in
//                    Button(action: {
//                        onSelect(selected_item)
//                    }) {
//                        HStack {
//                            Text(selected_item)
//
//                            Image(systemName: "delete.left.fill").font(.caption)
//                        }
//                    }
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 4)
//                    .background(Color("UCLAPrimaryColor"))
//                    .foregroundStyle(.white)
//                    .clipShape(Capsule())
//
//                }
//            }
            
            GeometryReader { geometry in
                ScrollView(.horizontal) {
                    
                    
                    
                    LazyHGrid(
                        rows: rows,
                        alignment: .center,
                        spacing: 25
                    ) {
                        ForEach (loading ? generateRandomTagChoices(size: 14):choices, id: \.self) { choice in
                            VStack {
                                AsyncImage(
                                    url: URL(string: choice.image)
                                ) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 125, height: 125)
                                .border(Color("UCLAPrimaryColor"), width: 8)
                                .cornerRadius(10)

                                
                                Text(choice.name)
                                    .lineLimit(2...)
                                    .font(.customHeadline)
                                    .foregroundColor(
                                        selected.contains(choice.name) ? Color.white : Color("UCLAPrimaryColor")
                                    )
                                    .multilineTextAlignment(.center)
                                    .frame(width: 150, alignment: .top)
//                                    .lineLimit(2)

                                
                            }
                            .padding(.all, 8.0)
                            .background(selected.contains(choice.name) ? Color("UCLAPrimaryColor") : Color.gray.opacity(0))
                            .cornerRadius(10)
                            
                            .onTapGesture {
                                if !loading {
                                    onSelect(choice.name)
                                }
                            }
                            .redacted(reason: loading ? .placeholder: [])
                        }
                        
                    }.frame(minWidth: geometry.size.width)
                    
                }
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
        }
    }
}

struct TagSelectionView_Container: View {
    @State var choices:[TagSelectionChoice] = generateRandomTagChoices(size: 8)
    @State var selectedTags: [String] = ["1"] // Example selected tags

    var body: some View {
        TagSelectionView(choices: choices, loading: false, selected: $selectedTags, single: false)      .previewLayout(.sizeThatFits)
    }
}

struct TagSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TagSelectionView_Container()
    }
}

