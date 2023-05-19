//
//  CalendarView.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/05/19.
//

import SwiftUI

struct CalendarView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    let dateFormatter = DateFormatter()
    init() {
        self.dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM"
    }
    
    
    @State
    var months = [Date(), Calendar.current.date(byAdding: .month, value: 1, to: Date()),Calendar.current.date(byAdding: .month, value: 2, to: Date())]
    
    @State
    var scrollIndex = 2
    
    var body: some View {
        VStack(){
            Text("2023")
            LazyVGrid(columns: columns, spacing: 20) {
                Text("Sun")
                Text("Mon")
                Text("Tue")
                Text("Wed")
                Text("Thu")
                Text("Fri")
                Text("Sat")
            }
            .padding()
            ScrollView(){
                ForEach(months.indices, id:\.self) { monthIndex in
                    VStack(){
                        Text("\(dateFormatter.string(from: months[monthIndex]!))")
                        LazyVGrid(columns:columns, spacing:20) {
                            let elements = CalendarElement.getFlattenedDatesOfMonth(for: months[monthIndex]!)
                            ForEach(elements.indices, id:\.self){ elementIndex in
                                let element = elements[elementIndex]
                                ZStack() {
                                    if(element.dateComponents != nil) {
                                        let opacity = element.log?.score.rawValue == nil ? 0 : Double((element.log?.score.rawValue)! / 5)
                                        Rectangle()
                                            .foregroundColor(.green.opacity(0))
                                            .aspectRatio(1, contentMode: .fit)
                                        Text("\(element.dateComponents?.day ?? 0)").foregroundColor(.gray)
                                    }
                                }.onAppear{
                                    if(elementIndex + 1 == elements.count && monthIndex + 1 == months.count) {
                                        scrollIndex = scrollIndex + 1
                                        months.append(Calendar.current.date(byAdding: .month, value: scrollIndex, to: Date()))
                                    }
                                }
                            }
                        }.padding()
                    }
                }
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

