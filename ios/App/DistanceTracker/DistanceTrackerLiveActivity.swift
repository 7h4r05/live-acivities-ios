//
//  DistanceTrackerLiveActivity.swift
//  DistanceTracker
//
//  Created by Dariusz Zabrzeński on 10/04/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DistanceTrackerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var distance: Int
        var expectedArrivalTime: ClosedRange<Date>
    }
    
    var title: String
}

struct DistanceTrackerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DistanceTrackerAttributes.self) { context in
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {

                    Label("\(context.state.distance) m", systemImage: "paperplane")
                    .frame(width: 120)
                   .foregroundColor(.green)
                   .font(.title2)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Label {
                        Text(timerInterval: context.state.expectedArrivalTime, countsDown: true)
                            .frame(width: 50)
                            .monospacedDigit()
                    } icon: {
                        Image(systemName: "timer")
                    }
                    .font(.title2)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.attributes.title)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.green)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Spacer()
                    Button {
                      } label: {
                          Label("Check status", systemImage: "questionmark.app")
                              .font(.title2)
                      }
                      .foregroundColor(.green)
                      .background(.gray)
                }
                
            } compactLeading: {
                Label {
                    Text("\(context.state.distance)m")
                } icon: {
                    Image(systemName: "paperPlane")
                }
            } compactTrailing: {
                Label {
                    Text(timerInterval: context.state.expectedArrivalTime, countsDown: true)
                        .frame(width: 50)
                        .monospacedDigit()
                } icon: {
                    Image(systemName: "timer")
                }
            } minimal: {
                Text(timerInterval: context.state.expectedArrivalTime, countsDown: true)
                    .monospacedDigit()
                    .font(.caption2)
            }
        }
    }
}


struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<DistanceTrackerAttributes>
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(context.attributes.title) on the way!")
            Spacer()
            HStack {
                Spacer()
                Label {
                    Text("\(context.state.distance)m")
                } icon: {
                    Image(systemName: "paperplane")
                }
                .font(.title2)
                
                Label {
                    Text(timerInterval: context.state.expectedArrivalTime, countsDown: true)
                        .frame(width: 70)
                        .monospacedDigit()
                } icon: {
                    Image(systemName: "timer")
                }
                .font(.title2)
                Spacer()
            }
            Spacer()
        }
        .activityBackgroundTint(.green)
    }
}

struct DistanceTrackerLiveActivity_Previews: PreviewProvider {
    static let attributes = DistanceTrackerAttributes(title: "Knowledge delivery")
    static let contentState = DistanceTrackerAttributes.ContentState(distance: 3500, expectedArrivalTime: Date.now...Date())

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
