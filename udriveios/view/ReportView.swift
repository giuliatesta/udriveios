import SwiftUI

/* Final View showing a report of the overall driving behavior of the user */
struct ReportView: View {
    
    @State var showAlert = false;
    @State var showConfetti = false
    @State var exit = false

    @State var currentScore : Double = 0.0;
    @State var bestScore : Double = 0.0;
    
    @Environment(\.managedObjectContext) private var viewContext

    // TODO scroll view
    var body: some View {
        NavigationView(){
            VStack{
                VStack{
                    Text("Punteggio Finale:")
                    Text("\(currentScore, specifier: "%.2f") %")
                    Text("Miglior Punteggio:")
                    Text("\(bestScore, specifier: "%.2f") %")
                    if(showConfetti) {
                        Text("Complimenti, hai migliorato il tuo")
                        Text("miglior punteggio!")
                    }
                }.frame(minWidth: 300, maxWidth: .infinity, minHeight: 100 , maxHeight: 500)
                VStack{
                    Text("Il tuo percorso: ")
                    MapView().frame(minWidth: 300, maxWidth: .infinity, minHeight: 500 , maxHeight: 500).padding(20)
                }
                
                HStack{
                    Button(action: {showAlert = true}){
                        HStack{
                            Image(systemName: "stop.fill")
                            Text("Nuova Guida")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .alert(isPresented: $showAlert){
                        Alert(
                            title: Text("Sei sicuro di voler iniziare una nuova guida?"),
                            primaryButton: Alert.Button.default(Text("OK"), action: {
                            }),
                            
                            secondaryButton: Alert.Button.destructive(Text("Annulla"))
                        )
                    }
                    
                    Button(action: {exit = true}){
                        HStack{
                            Image(systemName: "stop.fill")
                            Text("Esci")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .alert(isPresented: $exit) {
                        Alert(
                            title: Text("Sei sicuro di voler uscire?"),
                            primaryButton: Alert.Button.default(Text("OK"), action: {
                                    Darwin.exit(0)
                            }),
                            secondaryButton: Alert.Button.destructive(Text("Annulla"))
                        )
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("uDrive")
        .onAppear() {
            CoreDataManager.getInstance().context = viewContext
            let timeIntervalManager = TimeIntervalManager.getInstance()
            bestScore = timeIntervalManager.getBestScore()
            currentScore = timeIntervalManager.getCurrentScore()
            if(bestScore < currentScore) {
                showConfetti = true
                timeIntervalManager.saveBestScore()
            }
             
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
