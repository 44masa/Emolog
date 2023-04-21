//
//  LogDetail.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/04/21.
//

import SwiftUI

struct LogDetail: View {
    @Binding var log: Log
    @State private var isEmojiPickerVisible = false
    
    
    var body: some View {
        VStack(alignment: .center){
            VStack{
                Text("\(log.getDateString())のあなたのムード")
                    .font(.title2)
                EmojiPicker(score: $log.score, isVisible: $isEmojiPickerVisible)
                    .padding(5.0)
            }
            Divider()
            Text("メモ")
                .font(.title2)
            VStack{
                TextField("今日はこんなことがありました...", text: $log.description)
            }
        }
        .padding(10.0)
    }
}

struct LogDetail_Previews: PreviewProvider {
    @State static private var log = Log(id: 1, date: Date(), description: "なんかいい日だった", score: Score.five)
    static var previews: some View {
        LogDetail(log: $log
        )
    }
}
