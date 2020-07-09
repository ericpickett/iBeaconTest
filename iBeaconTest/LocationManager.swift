//
//  LocationManager.swift
//  iBeaconTest
//
//  Created by eric on 2020/07/07.
//  Copyright © 2020 BizMobile. All rights reserved.
//

import CoreLocation
import UIKit
import os
import UserNotifications

class LocationManager: CLLocationManager {
    static let shared = LocationManager()
    
    private override init() {
        super.init()
        self.delegate = self
        self.allowsBackgroundLocationUpdates = true
        self.showsBackgroundLocationIndicator = true
    }
    
    func presentAlert(message: String) -> Void {
        let content = UNMutableNotificationContent()
        content.title = "iBeacon Event"
        content.body = message
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLBeaconRegion {
            let beaconRegion = region as! CLBeaconRegion
            self.presentAlert(message: "Entered region \(beaconRegion.proximityUUID)\nMajor: \(beaconRegion.major ?? -1)\nMinor: \(beaconRegion.minor ?? -1)")
            os_log("Entered region: %s", beaconRegion.proximityUUID.uuidString)
            os_log("Major: %d, Minor: %d", beaconRegion.major?.int16Value ?? -1, beaconRegion.minor?.int16Value ?? -1)
            self.startRangingBeacons(in: beaconRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLBeaconRegion {
            let beaconRegion = region as! CLBeaconRegion
            self.presentAlert(message: "Exited region \(beaconRegion.proximityUUID)\nMajor: \(beaconRegion.major ?? -1)\nMinor: \(beaconRegion.minor ?? -1)")
            os_log("Exited region: %s", beaconRegion.proximityUUID.uuidString)
            os_log("Major: %d, Minor: %d", beaconRegion.major?.int16Value ?? -1, beaconRegion.minor?.int16Value ?? -1)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if region is CLBeaconRegion {
            let beaconRegion = region as! CLBeaconRegion
            switch state {
            case .inside:
                self.presentAlert(message: "Inside region \(beaconRegion.proximityUUID)\nMajor: \(beaconRegion.major ?? -1)\nMinor: \(beaconRegion.minor ?? -1)")
                os_log("Inside region: %s", beaconRegion.proximityUUID.uuidString)
                os_log("Major: %d, Minor: %d", beaconRegion.major?.int16Value ?? -1, beaconRegion.minor?.int16Value ?? -1)
            case.outside:
                self.presentAlert(message: "Outside region \(beaconRegion.proximityUUID)\nMajor: \(beaconRegion.major ?? -1)\nMinor: \(beaconRegion.minor ?? -1)")
                os_log("Outside. region: %s", beaconRegion.proximityUUID.uuidString)
                os_log("Major: %d, Minor: %d", beaconRegion.major?.int16Value ?? -1, beaconRegion.minor?.int16Value ?? -1)
            default:
                os_log("Received unknown region state.")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if !beacons.isEmpty {
            for beacon in beacons {
                os_log("Ranged beacon: %s", beacon.proximityUUID.uuidString)
                os_log("Major: %d, Minor: %d", beacon.major.int16Value, beacon.minor.int16Value)
                os_log("Proximity: %d", beacon.proximity.rawValue)
                os_log("RSSI: %d", beacon.rssi)
                if #available(iOS 13.0, *) {
                    os_log("Timestamp: %s", beacon.timestamp.description(with: .current))
                } else {
                    os_log("Logged at: %s", Date().description(with: .current))
                }
            }
        }
    }
}
