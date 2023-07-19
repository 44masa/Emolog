//
//  EmojiPicker.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/04/21.
//

import SwiftUI


struct EmojiPicker: View {
    @Binding var score: LogService.Score?
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
                    ForEach(LogService.Score.allCases, id: \.self) { option in
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
    @State static private var score: Optional<LogService.Score> = LogService.Score.five
    
    static var previews: some View {
        EmojiPicker(score: $score, isVisible: .constant(true))
    }
}
