//
//  CreateLogView.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/09/22.
//

import SwiftUI

struct CreateLogView: View {
    let targetDateComponents: DateComponents
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var memo = ""
    @State private var score: EmoLog.Score? = nil
    @State private var isEmojiPickerVisible = false
    
    func save() {
        let log = EmoLog(context: managedObjectContext)
        log.id = UUID()
        log.date = Calendar.current.date(from: targetDateComponents)
        log.score = Int16(score?.rawValue ?? 0)
        log.memo = memo
        
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center){
                VStack{
                    Text("\(getFormattedDateString(for: targetDateComponents))のあなたのムード")
                        .font(.title2)
                        .padding(.bottom, 30)
                    EmojiPicker(score: $score, isVisible: $isEmojiPickerVisible)
                        .padding(5.0).onDisappear {
                            save()
                        }
                }
                .padding(.top, 30)
                Divider()
                    .padding(.bottom, 30)
                Text("メモ")
                    .font(.title2)
                VStack{
                    TextField("今日はこんなことがありました...", text: $memo)
                }
                Spacer()
            }
            .padding(10.0).onDisappear {
                save()
            }
        }
        
    }
}

struct CreateLogView_Previews: PreviewProvider {
    static var previews: some View {
        CreateLogView(targetDateComponents: Calendar.current.dateComponents([.year, .month, .day], from: Date()))
    }
}
