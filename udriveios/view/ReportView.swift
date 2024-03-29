import SwiftUI
import ConfettiSwiftUI

let clapSound = URL(string: "/System/Library/Audio/UISounds/New/Fanfare.caf")

/* Final View showing a report of the overall driving behavior of the user */
struct ReportView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var goToStart = false
    @State private var newBestscore = false
    
    @State private var currentScore : Double = 0.0;
    @State private var bestScore : Double = 0.0;
    @State private var counter = 0
    
    let soundPlayer: SoundPlayer = SoundPlayer.getInstance();
    
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    if(newBestscore) {
                        FlashingText(text: "Complimenti!\nHai ottenuto un nuovo record!")
                            .onTapGesture {
                                celebrateNewBestScore()
                            }
                            .frame(minWidth: 2, maxWidth: .infinity)
                    }
                    HStack(alignment: .top, spacing: 0) {
                        VStack(alignment: .center, spacing: 1) {
                            if (newBestscore) {
                                Text("👑").font(.title2)
                            } else {
                                Text("☠️").font(.title2)
                            }
                            Text("Punteggio Finale:")
                                .makeHeadline()
                            Text("\(currentScore, specifier: "%.2f") / 100").makeHeadline().monospaced()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(getScoreColor(bestScore: true))
                        VStack() {
                            if (newBestscore) {
                                Text("☠️").font(.title2)
                            } else {
                                Text("👑").font(.title2)
                            }
                            Text("Miglior Punteggio:")
                                .makeHeadline()
                            Text("\(bestScore, specifier: "%.2f") / 100").makeHeadline().monospaced()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(getScoreColor())
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.horizontal, .top])
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
                        .background(safeColor)
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
                        .background(dangerColor)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.horizontal])
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
                    VStack (alignment: .leading) {
                        Text("Il tuo percorso: ")
                            .padding([.leading, .top])
                            .font(.title)
                        MapView().frame(minHeight: 500, maxHeight: 500)
                            .padding([.horizontal])
                    }
                    Button("Nuova Guida", action: {
                        goToStart = true
                        // empties data for a new ride
                        CoreDataManager.getInstance().resetData()
                    })
                    .buttonStyle(CustomButtonStyle())
                    .font(.title)
                    .padding([.vertical])
                }
            }
            .navigationTitle("uDrive")
            .navigationDestination(isPresented: $goToStart) {
                StartView()
            }
        }
        .confettiCannon(counter: $counter, num: 150)
        .padding([.horizontal], 10)
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            soundPlayer.initSoundPlayer(soundUrl: clapSound, silenceDuration: 0, repeatSound: false)
            
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
    
    private func getScoreColor(bestScore: Bool = false) -> Color {
        let greenColor : Color = colorScheme == .light ? Color(hex: "DAFFCC") : Color(hex: "4EB826")
        let redColor : Color = colorScheme == .light ? Color(hex: "FFCCCC") : Color(hex: "B82525")
        if (newBestscore) {
            return bestScore ? greenColor : redColor
        } else {
            return bestScore ? redColor : greenColor
        }
    }
    
    private var safeColor : Color {
        colorScheme == .light ? Color(hex: "CCF3FF") : Color(hex: "2696B8")
    }
        
    private var dangerColor : Color {
        colorScheme == .light ? Color(hex: "E2CCFF") : Color(hex: "6527B8")
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}

struct FlashingText: View {
    var text : String;
    
    @State private var isFlashing = false
    
    var body: some View {
        Text(text)
            .font(.title2)
            .multilineTextAlignment(.center)
            .padding()
            .background(
                Rectangle()
                    .strokeBorder(isFlashing ? Color.green : Color.clear, lineWidth: 5)
                    .cornerRadius(10)
                    .onAppear() {
                        withAnimation(.easeInOut(duration:0.5).repeatForever()) {
                            self.isFlashing.toggle()
                        }
                    }
            )
    }
}
