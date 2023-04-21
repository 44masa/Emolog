//
//  ContentView.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/04/21.
//

import SwiftUI

struct ContentView: View {
    @State var log = Log(id: 1, date: Date(), description: "", score: Score.five)
    
    var body: some View {
       LogDetail(log: $log)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

