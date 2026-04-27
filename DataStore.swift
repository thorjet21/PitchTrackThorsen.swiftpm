//
//  File.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 4/24/26.
//

import Foundation

class DataStore: ObservableObject {
    //this ensures it's always accessed on the main thread 
    @MainActor static let shared = DataStore()
    private let key = "teams_data"

    @Published var teams: [Teams] = [] {
        didSet { save() }
    }

    init() {
        load()
    }
//gives me a esay way to save things to the phone using json
    func save() {
        if let encoded = try? JSONEncoder().encode(teams) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
//gives me a esay way to pull stuff of the phone storage and decodes the json
    func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Teams].self, from: data)
        else { return }
        teams = decoded
    }
}
