//
//  EmojiPicker.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/04/21.
//

import SwiftUI


struct EmojiPicker: View {
    @Binding var score: EmoLog.Score?
    @Binding var isVisible: Bool
    
    var body: some View {
        Button(action: {
            isVisible = true
        }, label: {
            Text(score?.emoji ?? "?")
                .font(.system(size: 50))
        })
        .sheet(isPresented: $isVisible, content: {
            VStack {
                Text("Select Your Mood")
                    .font(.headline)
                    .padding()
                HStack {
                    ForEach(EmoLog.Score.allCases, id: \.self) { option in
                        Button(action: {
                            score = option
                            isVisible = false
                        }, label: {
                            Text(option.emoji)
                                .font(.system(size: 50))
                        })
                    }
                }
                .padding()
                Button(action: {
                    isVisible = false
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding()
                })
            }
        })
        
    }
}

struct EmojiPicker_Previews: PreviewProvider {
    @State static private var score:  EmoLog.Score? = EmoLog.Score.five
    @State static private var isVisible = true
    
    static var previews: some View {
        EmojiPicker(score: $score, isVisible: $isVisible)
    }
}
