import SwiftUI

/* Final View showing a report of the overall driving behavior of the user */
struct ReportView: View {
    
    @State var showAlert = false
    @State var showConfetti = false
    @State var restart = false

    @State var currentScore : Double = 0.0;
    @State var bestScore : Double = 0.0;
    @State var bestScoreColor : Color = Color(hex: "9ff227").opacity(0.2)
    @State var finalScoreColor : Color = Color(hex: "f25727").opacity(0.2)
    
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView(){
            ScrollView{
                VStack{
                    if(showConfetti) {
                        HStack{
                            Text("Complimenti!\nHai ottenuto un nuovo record!").font(.title)
                                .multilineTextAlignment(.center)
                                .padding()
                        }.border(.yellow)
                    }
 
                    HStack(alignment: .top, spacing: 0){
                        VStack(alignment: .center, spacing: 1){
                            Text("Punteggio Finale:")
                                .makeHeadline()
                            Text("\(currentScore, specifier: "%.2f") %").makeHeadline().monospaced()
                        }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(finalScoreColor)
                        
                        VStack(){
                            Text("Miglior Punteggio:")
                                .makeHeadline()
                            Text("\(bestScore, specifier: "%.2f") %").makeHeadline().monospaced()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(bestScoreColor)
                    }
                        .padding([.horizontal, .top])

                    VStack{
                        //Text("Il tuo percorso: ").makeHeadline().padding([.top])
                        
                        /* Mappa che mostra il percorso fatto e i punti in cui si è
                         avuto un dangerous behaviour di guida */
                        MapView().frame( minHeight: 500 , maxHeight: 500)
                            .padding()
                    }
                    Button(action: {showAlert = true}){
                        HStack{
                            //Image(systemName: "stop.fill")
                            Text("Nuova Guida")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.title)
                    .alert(isPresented: $showAlert){
                        Alert(
                            title: Text("Sei sicuro di voler iniziare una nuova guida?"),
                            primaryButton: Alert.Button.default(Text("OK"), action: {
                            }),
                            
                            secondaryButton: Alert.Button.destructive(Text("Annulla"))
                        )
                    }
                }
            }
        }
        .padding([.horizontal], 10)
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
                //I due colori di background dei punteggi si scambiano
                var changeCols = finalScoreColor
                finalScoreColor = bestScoreColor
                bestScoreColor = changeCols
            }/*
            //PER DEBUG
            if(showConfetti){
                var changeCols = finalScoreColor
                finalScoreColor = bestScoreColor
                bestScoreColor = changeCols
            }*/
             
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
