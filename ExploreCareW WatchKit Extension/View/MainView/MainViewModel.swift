//
//  File.swift
//  ExploreCareW WatchKit Extension
//
//  Created by Rasyid Ridla on 19/07/22.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var name = "Rachel"
    @Published var isMute = false
    @Published var timeVal = 1
}
