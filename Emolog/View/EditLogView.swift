//
//  EditLogView.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/07/19.
//

import SwiftUI

struct EditLogView: View {
    let emoLogId: UUID
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State private var isEmojiPickerVisible = false
    @State private var memo = ""
    @State private var score: EmoLog.Score? = nil
    @FocusState  var isTextEditorFocused:Bool
    
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
    
    func save(to emoLog: EmoLog) {
        emoLog.memo = memo
        emoLog.score = Int16(score?.rawValue ?? 0)
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    
    var body: some View {
        if let target = results.first {
            ScrollView {
                VStack(alignment: .center){
                    VStack{
                        Text("Your mood for \(getFormattedDateString(for: target.dateComponents))")
                            .font(.title2)
                            .padding(.bottom, 30)
                        EmojiPicker(score: $score, isVisible: $isEmojiPickerVisible)
                            .padding(5.0).onDisappear {
                                save(to: target)
                            }
                    }.padding(.top, 30)
                    Divider()
                        .padding(.bottom, 30)
                    Text("Memo")
                        .font(.title2)
                    VStack{
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $memo)
                                .focused($isTextEditorFocused)
                                .background(Color(white: 0.95))
                                .cornerRadius(1)
                                .shadow(radius: 1)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("Done") {
                                            isTextEditorFocused = false
                                        }
                                    }
                                }
                            if memo.isEmpty {
                                Text("What happened today?")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 12)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
                    Spacer()
                    
                }
                .padding(10.0).onAppear {
                    memo = target.memo ?? ""
                    score = target.scoreEnum
                }.onDisappear {
                    save(to: target)
                }
            }
            
        } else {
            EmptyView()
        }
    }
}

struct EditLogView_Previews: PreviewProvider {
    static var mockEmoLogId: UUID {
        return PersistenceController.addMockEmoLog(to: PersistenceController.preview.container.viewContext)
    }
    
    static var previews: some View {
        EditLogView(emoLogId: mockEmoLogId).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
