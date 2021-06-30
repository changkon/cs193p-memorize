//
//  ContentView.swift
//  memorize
//
//  Created by Changkon Han on 2021/06/19.
//

import SwiftUI

struct ContentView: View {
    static var DEFAULT_EMOJI_COUNT = 8
    static var EMOJI_THEMES: [String: [String]] = [
        "ANIMALS": [
            "🐶",
            "🐱",
            "🐭",
            "🐹",
            "🐰",
            "🦊",
            "🐻",
            "🐼",
            "🐻‍❄️",
            "🐨",
            "🐯",
            "🦁",
            "🐮",
            "🐷",
            "🐽",
            "🐸",
            "🐵",
            "🙈",
            "🙉",
            "🙊",
            "🐒",
            "🐔",
            "🐧",
            "🐦"
        ],
        "VEHICLES": ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🚃", "🚘", "🚖", "🛴", "🚲", "🛵", "🏍", "🛺", "🚍", "🚔"],
        "SPORTS": ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏓", "🏉", "🥏", "🎱", "🪀", "🏸", "🏒", "🏑", "🥍", "🏏", "🏹", "🥋", "🛹", "🛼", "🏋️‍♀️", "🏄‍♀️", "🏂"]
    ]
    @State var activeEmojis: [String]
    @State var activeTheme: String

    init() {
        let initialTheme = "ANIMALS"
        self.activeTheme = initialTheme
        var initialEmojis = ContentView.EMOJI_THEMES[initialTheme] ?? []
        initialEmojis.shuffle()
        self.activeEmojis = initialEmojis
    }
    
    func setActiveEmojis(theme: String) -> [String] {
        if let selectedThemes = ContentView.EMOJI_THEMES[theme] {
            var indexSet: Set<String> = []
            var activeTheme: [String] = []
            for _ in 0..<ContentView.DEFAULT_EMOJI_COUNT {
                var insertResult: (Bool, String)
                var index: Int
                var element: String
                repeat {
                    index = Int.random(in: 0..<selectedThemes.count)
                    element = selectedThemes[index]
                    insertResult = indexSet.insert(element)
                } while (insertResult.0 == false)
                activeTheme.append(element)
            }
            return activeTheme
        }
        
        return []
    }
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
                .foregroundColor(.black);
            ScrollView {
                LazyVGrid (
                    columns: [GridItem(.adaptive(minimum: 100))]
                ) {
                    ForEach(activeEmojis[0..<activeEmojis.count], id: \.self) { emoji in
                        CardView(isFaceUp: false, content: emoji)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            HStack {
                ThemeButton(image: "🐌", text: "ANIMALS", isActive: self.activeTheme == "ANIMALS", cb: {
                    self.activeTheme = "ANIMALS"
                    self.activeEmojis = self.setActiveEmojis(theme: "ANIMALS")
                });
                ThemeButton(image: "🚝", text: "VEHICLES", isActive: self.activeTheme == "VEHICLES", cb: {
                    self.activeTheme = "VEHICLES"
                    self.activeEmojis = self.setActiveEmojis(theme: "VEHICLES")
                });
                ThemeButton(image: "🥊", text: "SPORTS", isActive: self.activeTheme == "SPORTS", cb: {
                    self.activeTheme = "SPORTS"
                    self.activeEmojis = self.setActiveEmojis(theme: "SPORTS")
                });
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
        .foregroundColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

struct ThemeButton: View {
    var image: String
    var text: String
    var isActive: Bool
    var cb: () -> ()
    
    var body: some View {
        VStack {
            let textColor = isActive ? Color.green : Color.blue
            
            Text(image)
                .font(.title)
            Text(text)
                .foregroundColor(textColor)
        }.onTapGesture {
            cb()
        }
    }
}

struct CardView: View {
    @State var isFaceUp: Bool
    var content: String
    
    var body: some View {
        ZStack {
            let card = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                card
                    .fill()
                    .foregroundColor(.white)
                card
                    .strokeBorder(lineWidth: 3)
                Text(content)
                    .font(.largeTitle)
            } else {
                card
                    .fill()
            }
        }.onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}
