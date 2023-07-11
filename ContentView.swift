import SwiftUI

let dimension = 4

struct ContentView: View {
    let pictureTable = ["hare",
                        "tortoise",
                        "lizard",
                        "bird",
                        "ant",
                        "fish",
                        "pawprint",
                        "leaf",
                        "hare",
                        "tortoise",
                        "lizard",
                        "bird",
                        "ant",
                        "fish",
                        "pawprint",
                        "leaf"].shuffled()
    
    @State var pictureTableStates = Array(repeating: false,
                                          count: dimension * dimension)
    @State var selectedCardIndices: [Int] = []
    
    var body: some View {
        VStack {
            ForEach(0..<4) { row in
                HStack {
                    ForEach(0..<dimension, id: \.self) { column in
                        Button(action: {
                            clicked(row: row, column: column)
                        }) {
                            if pictureTableStates[row * dimension + column] {
                                Image(systemName: pictureTable[row * dimension + column])
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            } else {
                                Image(systemName: "slowmo")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .padding()
                            }
                        }
                        .frame(width: 80, height: 100)
                    }
                }
            }
        }
    }
    
    func clicked(row: Int, column: Int) {
        let index = row * dimension + column
        //fall ausschließen dass etwas passiert wenn auf bereits offene karte geklickt wird
        if !pictureTableStates[index] {
            pictureTableStates[index] = true
            
            if selectedCardIndices.count == 1 {
                let previousIndex = selectedCardIndices[0]

                if pictureTable[previousIndex] == pictureTable[index] {
                    // Match found und pictureTableStates[index] bleibt somit true
                    selectedCardIndices.removeAll()
                } else {
                    // auftritt wenn kein match
                    //https://developer.apple.com/documentation/dispatch/dispatchqueue
                                    //now nimmt die jetztige zeit und 0.5 sek wird dazu addiert
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        // zurück auf den anfangszustand
                        pictureTableStates[previousIndex] = false
                        pictureTableStates[index] = false
                        //leeren
                        selectedCardIndices.removeAll()
                    }
                }
            } else {
                //ausgeführt bei dem reveal der 1. Karte und Index wird gespeichert,
                //um bei dem nächsten klick die 2 indizes zu überprüfen
                selectedCardIndices.append(index)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
