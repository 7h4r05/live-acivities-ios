//
//  LiveActivityPlugin.swift
//  App
//
//  Created by Dariusz Zabrzeński on 10/04/2023.
//

import Foundation
import Capacitor
import ActivityKit


@objc(LiveActivityPlugin)
public class LiveAcivityPlugin: CAPPlugin {
    @objc func start(_ call: CAPPluginCall) {
        let title = call.getString("title")!
        let distance = call.getInt("distance")!
        let expectedTimeInMinutes = call.getInt("expectedTimeInMinutes")
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            var future = Calendar.current.date(byAdding: .minute, value: (expectedTimeInMinutes ?? 0), to: Date())!
            future = Calendar.current.date(byAdding: .second, value: (expectedTimeInMinutes ?? 0), to: future)!
            let date = Date.now...future
            let initialContentState = DistanceTrackerAttributes.ContentState(distance: distance, expectedArrivalTime: date)
            let activityAttributes = DistanceTrackerAttributes(title: title)
            let activityContent = ActivityContent(state: initialContentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!, relevanceScore: 100)
            
            do {
                var activity = try Activity.request(attributes: activityAttributes, content: activityContent)
                call.resolve([
                    "activityId": activity.id])
            } catch (let error) {
                print("Error requesting Live Activity \(error.localizedDescription).")
            }
        }
    }
    
    @objc func update(_ call: CAPPluginCall){
        let distance = call.getInt("distance")!
        let activityId = call.getString("activityId")!
        let expectedTimeInMinutes = call.getInt("expectedTimeInMinutes")
        let activity = Activity<DistanceTrackerAttributes>.activities.first { $0.id == activityId}
        
        if activity != nil {
            var future = Calendar.current.date(byAdding: .minute, value: (expectedTimeInMinutes ?? 0), to: Date())!
            future = Calendar.current.date(byAdding: .second, value: (expectedTimeInMinutes ?? 0), to: future)!
            let date = Date.now...future
            let updateState = DistanceTrackerAttributes.ContentState(distance: distance, expectedArrivalTime: date)
            let alertConfiguration = AlertConfiguration(title: "Live update", body: "Getting the things done!", sound: .default)
            let updatedContent = ActivityContent(state: updateState, staleDate: nil)
            
            Task {
                await activity?.update(updatedContent, alertConfiguration: alertConfiguration)
            }
        }
    }
    
    @objc func stop(_ call: CAPPluginCall) {
        let activityId = call.getString("activityId")
        let activity = Activity<DistanceTrackerAttributes>.activities.first { $0.id == activityId}
        if activity != nil {
            Task {
                await activity?.end(dismissalPolicy: .immediate)
            }
        }
    }
}
