//
//  CalendarView.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/05/19.
//

import CoreData
import SwiftUI



struct CalendarView: View {
    struct EmoLogViewModel {
        public var id: UUID?
        public var memo: String?
        public var dateComponents: DateComponents?
        public var score: EmoLog.Score?
    }
    static private let calendar = Calendar.current
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    private let dateFormatter = DateFormatter()
    
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: EmoLog.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \EmoLog.date, ascending: true)], predicate: nil, animation: .default) var rawLogs: FetchedResults<EmoLog>
    
    @State private var targetDate = Date()
    func getTargetDateDateComponentsList(targetDate: Date) -> [DateComponents?] {
        return getDatesOfMonth(for: targetDate)
    }
    
    init(emoLogs: [EmoLogViewModel] = []) {
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM YYYY"
    }
    
    var body: some View {
        NavigationView() {
            ScrollView {
                VStack(spacing: 10) {
                    HStack(spacing:20) {
                        Button(action: {
                            targetDate = Calendar.current.date(byAdding: .month, value: -1, to: targetDate)!
                        }, label: {
                            Text("◀").foregroundColor(.black)
                        })
                        Text("\(dateFormatter.string(from: targetDate))").frame(minWidth: 200)
                        Button(action: {
                            targetDate = Calendar.current.date(byAdding: .month, value: 1, to: targetDate)!
                            //emoLogs = getEmoLogs()
                        }, label: {
                            Text("▶").foregroundColor(.black)
                        })
                    }.padding(.top, 8)
                    LazyVGrid(columns: columns, spacing: 20) {
                        Text("Sun")
                        Text("Mon")
                        Text("Tue")
                        Text("Wed")
                        Text("Thu")
                        Text("Fri")
                        Text("Sat")
                    }.padding()
                    LazyVGrid(columns:columns, spacing:20) {
                        let targetDateDateComponentsList = getTargetDateDateComponentsList(targetDate: targetDate)
                        ForEach(targetDateDateComponentsList.indices, id:\.self){ i in
                            if let targetDateDateComponents = targetDateDateComponentsList[i] {
                                if let matchedLog = rawLogs.first(where: { rawLog in
                                    let rawLogDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: rawLog.date!)
                                    return targetDateDateComponents.year == rawLogDateComponents.year && targetDateDateComponents.month  == rawLogDateComponents.month && targetDateDateComponents.day == rawLogDateComponents.day
                                }) {
                                    NavigationLink (destination: EditLogView(emoLogId: matchedLog.id!)) {
                                        ZStack{
                                            
                                            if(matchedLog.scoreEnum == EmoLog.Score.unknown) {
                                                Rectangle()
                                                    .foregroundColor(.white)
                                                    .aspectRatio(1, contentMode: .fit)
                                                    .shadow(color: .gray, radius: 1)
                                                Text("\(matchedLog.dateComponents?.day ?? 0)").foregroundColor(.gray)
                                            } else {
                                                let opacity =  Double(matchedLog.score ) / 5
                                                Rectangle()
                                                    .foregroundColor(.green).opacity(opacity)
                                                    .aspectRatio(1, contentMode: .fit)
                                                    .shadow(color: .gray, radius: 1)
                                                Text("\(matchedLog.dateComponents?.day ?? 0)").foregroundColor(.gray)
                                            }
                                            
                                        }
                                    }
                                } else {
                                    NavigationLink (destination: CreateLogView(targetDateComponents: targetDateDateComponents)) {
                                        ZStack{
                                            Rectangle()
                                                .foregroundColor(.white)
                                                .aspectRatio(1, contentMode: .fit)
                                                .shadow(color: .gray, radius: 1)
                                            Text("\(targetDateDateComponentsList[i]!.day!)").foregroundColor(.gray)
                                        }
                                    }
                                }
                            } else {
                                // 空のマス
                                Text("")
                            }
                        }
                    }
                    .padding()
                    Spacer()
                }
                
            }
        }.navigationViewStyle(.stack)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

