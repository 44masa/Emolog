//
//  CalendarView.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/05/19.
//

import SwiftUI

struct CalendarView: View {
    private let  columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    private let dateFormatter = DateFormatter()
    private let service: LogService
    
    @State private var targetDate = Date()
    @State private var logs: Array<LogService.Log> = []
    @State private var navPath = NavigationPath()
    @State var targetIndex = 0
    
    
    init(service:LogService) {
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM YYYY"
        self.service = service
        _logs = State(initialValue: self.service.getLogs(from: Date()))
    }
    
    var body: some View {
        NavigationStack(path:$navPath) {
            VStack(spacing: 10) {
                HStack(spacing:20) {
                    Button(action: {
                        targetDate = Calendar.current.date(byAdding: .month, value: -1, to: targetDate)!
                        logs = service.getLogs(from: targetDate)
                    }, label: {
                        Text("◀").foregroundColor(.black)
                    })
                    Text("\(dateFormatter.string(from: targetDate))").frame(minWidth: 200)
                    Button(action: {
                        targetDate = Calendar.current.date(byAdding: .month, value: 1, to: targetDate)!
                        logs = service.getLogs(from: targetDate)
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
                    ForEach(logs.indices, id:\.self){ i in
                        Button {
                            if(logs[i].dateComponents != nil) {
                                navPath.append(i.self)
                                targetIndex = i
                            }
                        } label: {
                            ZStack {
                                // dateComponentがある = 日付を表示する
                                if(logs[i].dateComponents != nil) {
                                    if(logs[i].id != nil) {
                                        let opacity =  Double(logs[i].score?.rawValue ?? 0) / 5
                                        Rectangle()
                                            .foregroundColor(.green).opacity(opacity)
                                            .aspectRatio(1, contentMode: .fit)
                                            .shadow(color: .gray, radius: 1)
                                        Text("\(logs[i].dateComponents!.day ?? 0)").foregroundColor(.gray)
                                    } else {
                                        Rectangle()
                                            .foregroundColor(.white)
                                            .aspectRatio(1, contentMode: .fit)
                                            .shadow(color: .gray, radius: 1)
                                        Text("\(logs[i].dateComponents!.day ?? 0)").foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                Spacer()
            }.navigationDestination(for: Int.self) { i in
                EditLogView(log: $logs[targetIndex])
                
            }
            
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(service: LogService(repository: LogRepository()))
    }
}

