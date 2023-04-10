//
//  DistanceTrackerBundle.swift
//  DistanceTracker
//
//  Created by Dariusz Zabrzeński on 10/04/2023.
//

import WidgetKit
import SwiftUI

@main
struct DistanceTrackerBundle: WidgetBundle {
    var body: some Widget {
        DistanceTracker()
        if #available(iOS 16.1, *) {
            
            DistanceTrackerLiveActivity()
        }
    }
}
