//
//  Placeholder.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/21/23.
//

import SwiftUI

public enum RedactionType {
    case customPlaceholder
    case scaled
    case blurred
}

struct Redactable: ViewModifier {
    let type: RedactionType?

    @ViewBuilder
    func body(content: Content) -> some View {
        switch type {
        case .customPlaceholder:
            content
                .modifier(Placeholder())
        case .scaled:
            content
                .modifier(Scaled())
        case .blurred:
            content
                .modifier(Blurred())
        case nil:
            content
        }
    }
}

struct Placeholder: ViewModifier {
    
    @State private var animationAmount = 1.0
    func body(content: Content) -> some View {
        content
            .redacted(reason: .placeholder)
            .opacity(animationAmount)
            .animation(.easeInOut(duration: 1)
                .repeatForever(autoreverses: true), value: animationAmount)
            .onAppear {
                animationAmount = 0.5
            }
    }
}

struct Scaled: ViewModifier {
    
    @State private var condition: Bool = false
    func body(content: Content) -> some View {
        content
            .accessibility(label: Text("Scaled"))
            .redacted(reason: .placeholder)
            .scaleEffect(condition ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 1)
                .repeatForever(autoreverses: true), value: UUID())
            .onAppear { condition = true }
    }
}

struct Blurred: ViewModifier {
    
    @State private var condition: Bool = false
    func body(content: Content) -> some View {
        content
            .accessibility(label: Text("Blurred"))
            .redacted(reason: .placeholder)
            .blur(radius: condition ? 0.0 : 4.0)
            .animation(.easeInOut(duration: 1)
                .repeatForever(autoreverses: true), value: UUID())
            .onAppear { condition = true }
    }
}
