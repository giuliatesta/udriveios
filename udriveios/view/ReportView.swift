//
//  ReportView.swift
//  udriveios
//
//  Created by Giulia Testa on 08/07/23.
//

import SwiftUI

struct ReportView: View {
    var body: some View {
        NavigationView(){
            VStack{
                FinalMapView()
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
