import SwiftUI
import ConfettiSwiftUI


let clapSoundUrl = URL(string: "/System/Library/Audio/UISounds/New/Fanfare.caf")

/* Final View showing a report of the overall driving behavior of the user */
struct ReportView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @State var goToStart = false
    @State private var newBestscore = false
    
    @State private var currentScore : Double = 0.0;
    @State private var bestScore : Double = 0.0;
    @State private var counter = 0

    let soundPlayer: SoundPlayer = SoundPlayer(soundUrl: clapSoundUrl, silenceDuration: 0, repeatSound: false)
    
    let greenColor : Color = Color(hex: "9ff227").opacity(0.2)
    let redColor : Color = Color(hex: "f25727").opacity(0.2)
    
    var body: some View {
        NavigationStack() {
            VStack {
                ScrollView {
                    if(newBestscore) {
                        HStack {
                            Text("Complimenti!\nHai ottenuto un nuovo record!").font(.title2)
                                .multilineTextAlignment(.center)
                                .padding()
                                .onTapGesture {
                                    celebrateNewBestScore()
                                }
                        }
                        .frame(minWidth: 2, maxWidth: .infinity)
                        .border(.green, width: 5)
                        .padding([.horizontal])
                    }
                    HStack(alignment: .top, spacing: 0) {
                        VStack(alignment: .center, spacing: 1) {
                            if (newBestscore) {
                                Text("👑").font(.title2)
                            }
                            Text("Punteggio Finale:")
                                .makeHeadline()
                            Text("\(currentScore, specifier: "%.2f") / 100").makeHeadline().monospaced()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(newBestscore ? greenColor : redColor)
                        VStack() {
                            if (!newBestscore) {
                                Text("👑").font(.title2)
                            }
                            Text("Miglior Punteggio:")
                                .makeHeadline()
                            Text("\(bestScore, specifier: "%.2f") / 100").makeHeadline().monospaced()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(newBestscore ? redColor : greenColor)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.horizontal, .top])
                    VStack(alignment: .center, spacing: 1) {
                        Text("La tua guida è durata:")
                            .font(.title2)
                            .bold()
                        Text(Utils.getFormattedTime(duration: Int64(TimeIntervalManager.getInstance().getTotalTime())))
                            .font(.title2)
                            .monospaced()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    HStack(alignment: .top, spacing: 0) {
                        VStack() {
                            Text("😇").font(.title2)
                            Text("Guida sicura: ")
                                .makeHeadline()
                            Text(Utils.getFormattedTime(duration: Int64(
                                TimeIntervalManager.getInstance()
                                    .getTotalTime(dangerous: false))))
                            .makeHeadline()
                            .monospaced()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(greenColor)
                        VStack() {
                            Text("😈").font(.title2)
                            Text("Guida pericolosa: ")
                                .makeHeadline()
                            Text(Utils.getFormattedTime(duration: Int64(
                                TimeIntervalManager.getInstance()
                                    .getTotalTime(dangerous: true))))
                            .makeHeadline()
                            .monospaced()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(redColor)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.horizontal])
                    VStack (alignment: .leading) {
                        Text("Il tuo percorso: ")
                            .padding([.leading, .top])
                            .font(.title)
                        MapView().frame(minHeight: 500, maxHeight: 500)
                            .padding([.horizontal])
                    }
                    Button(action: {
                        goToStart = true
                        // empties data for a new ride
                        CoreDataManager.getInstance().resetData()
                    }) {
                        Text("Nuova Guida")
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.title)
                    .padding([.vertical])
                }
            }
            .navigationDestination(isPresented: $goToStart) {       // must be called before title...
                StartView()
            }
            .navigationTitle("uDrive")  // it must be here. Otherwise, weird behaviour with ScrollView
        }
        .confettiCannon(counter: $counter, num: 150)
        .padding([.horizontal], 10)
        .navigationBarBackButtonHidden(true)
        
        .onAppear() {
            CoreDataManager.getInstance().context = viewContext
            let timeIntervalManager = TimeIntervalManager.getInstance()
            bestScore = timeIntervalManager.getBestScore()
            currentScore = timeIntervalManager.getCurrentScore()
            if(bestScore < currentScore) {
                celebrateNewBestScore()
                timeIntervalManager.saveBestScore()
            }
        }
    }
    
    private func celebrateNewBestScore() {
        soundPlayer.play()
        counter += 1         // everytime counter changes the confetti are shot
        newBestscore = true
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
