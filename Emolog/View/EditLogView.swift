//
//  EditLogView.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/07/19.
//

import SwiftUI

struct EditLogView: View {
    @State private var isEmojiPickerVisible = false
    @Binding var log: LogService.Log
    
    init(log: Binding<LogService.Log>) {
        _log = log
        
        if(log.id == nil) {
            _log.wrappedValue.id = UUID()
            _log.wrappedValue.description = ""
        }
    }
    var body: some View {
        VStack(alignment: .center){
            VStack{
                Text("\(getFormattedDateString(for: log.dateComponents! ))のあなたのムード")
                    .font(.title2)
                    .padding(.bottom, 30)
                EmojiPicker(score: $log.score, isVisible: $isEmojiPickerVisible)
                    .padding(5.0)
            }
            Divider()
                .padding(.bottom, 30)
            Text("メモ")
                .font(.title2)
                
            VStack{
                TextField("今日はこんなことがありました...", text: $log.description)
            }
        }
        .padding(10.0)
    }
}

struct EditLogView_Previews: PreviewProvider {
    @State static var log = LogService.Log(dateComponents: Calendar.current.dateComponents([.year, .month, .day], from: Date()), description: "今日もいい一日だった", score: LogService.Score.five)
    static var previews: some View {
        EditLogView(log: $log)
    }
}
