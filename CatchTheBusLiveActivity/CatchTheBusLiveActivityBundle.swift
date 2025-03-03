//
//  CatchTheBusLiveActivityBundle.swift
//  CatchTheBusLiveActivity
//
//  Created by amolonus on 02/03/2025.
//

import WidgetKit
import SwiftUI
import ActivityKit

@main
struct BusTripWidgetBundle: WidgetBundle {
    var body: some Widget {
        BusTripLiveActivityWidget()
    }
}

struct BusTripLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BusTripAttributes.self) { context in
            BusTripLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "bus.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    if let estimatedTime = context.state.estimatedArrivalTime {
                        Text(estimatedTime, style: .time)
                            .font(.headline)
                            .foregroundColor(context.state.isDelayed ? .red : .green)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("Route \(context.attributes.routeNumber)")
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    BusTripDynamicIslandExpandedView(context: context)
                }
            } compactLeading: {
                Image(systemName: "bus.fill")
                    .foregroundColor(.green)
            } compactTrailing: {
                if let estimatedTime = context.state.estimatedArrivalTime {
                    Text(estimatedTime, style: .time)
                        .font(.caption)
                        .foregroundColor(context.state.isDelayed ? .red : .primary)
                }
            } minimal: {
                Image(systemName: "bus.fill")
                    .foregroundColor(context.state.isDelayed ? .red : .green)
            }
        }
    }
}

