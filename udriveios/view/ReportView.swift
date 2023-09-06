import SwiftUI

struct ReportView: View {
    var body: some View {
        NavigationView(){
            VStack{
                MapView()
            }
        }.navigationBarBackButtonHidden(true)
        .navigationTitle("uDrive")
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
