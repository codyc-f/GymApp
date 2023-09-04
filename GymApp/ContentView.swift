//
//  ContentView.swift
//  GymApp
//
//  Created by Cody Choo-Foo on 2023-09-01.
//

import SwiftUI

struct LapClass:Identifiable{
    var id = UUID()
    let lap:String
    init(_ lap:String){
        self.lap = lap
    }
}
struct Note: Identifiable {
    var id = UUID()
    var content: String
    var timestamp: Date
}




struct ContentView: View {
    @ObservedObject var managerClass = ManagerClass()
    @State private var lapTimings: [LapClass] = []
    @State private var notes: [Note] = []
    @State private var newNoteText = ""
    @State private var rep1 = ""
    @State private var rep2 = ""
    @State private var rep3 = ""

    
    var body: some View{
        VStack{
            Text(String(managerClass.secondsString))
            switch managerClass.mode{
            case .stopped:
                withAnimation{
                    Button(action: {
                        managerClass.start()},
                           label:{
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(100)
                    })
                    
                }
            case .running:
                HStack{
                    withAnimation{
                        Button(action: {managerClass.stop()
                            lapTimings = []
                        }, label:{
                            Image(systemName: "stop.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(100)
                        })
                    }
                    withAnimation{
                        Button(action: {
                            let newLap = LapClass(managerClass.secondsString)
                            lapTimings.append(newLap)
                        },
                               label:{
                            Image(systemName: "stopwatch.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(100)
                        })
                        
                    }
                    withAnimation{
                        Button(action: {
                            managerClass.pause()},
                               label:{
                            Image(systemName: "pause.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(100)
                        })
                        
                    }
                }
                
            case .paused:
                HStack{
                    withAnimation{
                        Button(action: {managerClass.stop()
                            lapTimings = []
                        }, label:{
                            Image(systemName: "stop.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(100)
                        })
                    }
                    withAnimation{
                        Button(action: {
                            managerClass.start()},
                               label:{
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(100)
                        })
                        
                    }
                    
                    
                }
                
                
            }
            List(lapTimings.reversed()){lap in
                Text(lap.lap)
            }
            VStack {
                            HStack {
                                Spacer()
                                TextField("Exercise 1", text: $rep1)
                                    .fontWidth(.compressed)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                Spacer()
                                TextField("# of reps", text:$rep2)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                                TextField("# of reps", text:$rep2)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("# of reps", text:$rep2)
                                Spacer()
                            }
                
                            HStack {
                                Spacer()
                                Button("Add Note") {
                                    if !newNoteText.isEmpty || !rep1.isEmpty || !rep2.isEmpty || !rep3.isEmpty {
                                        let note = Note(content: newNoteText, timestamp: Date())
                                        notes.append(note)
                                        newNoteText = ""
                                        rep1 = ""
                                        rep2 = ""
                                        rep3 = ""
                                    }
                                }
                                Spacer()
                            }
                        }
                        
                        // List of notes
                        List(notes.reversed()) { note in
                            VStack(alignment: .leading) {
                                Text(note.content)
                                HStack {
                                    Text("Exercise 1: \(rep1)")
                                    Spacer()
                                }
                                HStack {
                                    Text("Exercise 2: \(rep2)")
                                    Spacer()
                                }
                                HStack {
                                    Text("Exercise 3: \(rep3)")
                                    Spacer()
                                }
                            }
                        }
                    }
                }
        
    
}

enum mode{
    case running
    case stopped
    case paused
}

class ManagerClass: ObservableObject {
    @Published var secondsString = ""
    @Published var secondElapsed = 0.0
    @Published var mode:mode = .stopped
    var timer = Timer()
    
    func secondsToFormat(seconds : Int) -> (Int,Int,Int){
        return ((seconds/3600), ((seconds%3600)/60), ((seconds%3600)%60))
    }

    func timetoString(hours:Int, minutes:Int, seconds:Int) -> String{
        var timeString = ""
        timeString += String(format: "%.2i", hours)
        timeString += " : "
        timeString += String(format: "%.2i", minutes)
        timeString += " : "
        timeString += String(format: "%.2i", seconds)
        return timeString
    }
    
    func start(){
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){
            timer in self.secondElapsed += 1
            let time = self.secondsToFormat(seconds: Int(self.secondElapsed))
            let timeString = self.timetoString(hours: time.0, minutes: time.1, seconds: time.2)
            self.secondsString = timeString
       
        
        }
            

    
    }
    func stop(){
        timer.invalidate()
        secondElapsed = 0
        mode = .stopped
    }
    func pause(){
        timer.invalidate()
        mode = .paused
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
