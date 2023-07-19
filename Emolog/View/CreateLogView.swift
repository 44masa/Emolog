//
//  CreateLogView.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/06/23.
//

import SwiftUI

struct CreateLogView: View {
    @State private var score :LogService.Score? = nil
    @State private var description = ""
    @State private var isEmojiPickerVisible = false
    @Binding var dateComponents: DateComponents
    
    
    
    
    var body: some View {
        VStack(alignment: .center){
            VStack{
                Text("\(getFormattedDateString(for: dateComponents))のあなたのムード")
                    .font(.title2)
                    .padding(.bottom, 30)
                EmojiPicker(score: $score, isVisible: $isEmojiPickerVisible)
                    .padding(5.0)
            }
            Divider()
                .padding(.bottom, 30)
            Text("メモ")
                .font(.title2)
                
            VStack{
                TextField("今日はこんなことがありました...", text: $description)
            }
        }
        .padding(10.0)
    }
}

struct CreateLogView_Previews: PreviewProvider {
    @State static var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from:Date())
    static var previews: some View {
        CreateLogView(dateComponents: $dateComponents)
    }
}
