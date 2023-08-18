//
//  EditLogView.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/07/19.
//

import SwiftUI

struct EditLogView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var isEmojiPickerVisible = false
    let emoLogId: UUID
    @FetchRequest var results: FetchedResults<EmoLog>
        init(emoLogId: UUID) {
            self.emoLogId = emoLogId
            
            let predicate = NSPredicate(format: "id == %@", emoLogId.uuidString)
            
            _results = FetchRequest<EmoLog>(
                entity: EmoLog.entity(),
                sortDescriptors: [],
                predicate: predicate
            )
        }
    
    @State var memo = ""
    @State var score: EmoLog.Score? = nil
    
    var body: some View {
        if let target = results.first {
            VStack(alignment: .center){
                VStack{
                    Text("\(getFormattedDateString(for: target.dateComponents!))のあなたのムード")
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
                    TextField("今日はこんなことがありました...", text: $memo)
                }
            }
            .padding(10.0).onAppear {
                memo = target.memo!
                score = target.scoreEnum!
            }
        } else {
            EmptyView()
        }
    }
}

struct EditLogView_Previews: PreviewProvider {
    static var previews: some View {
        EditLogView(emoLogId: UUID())
    }
}
