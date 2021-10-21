//
//  HavaConstants.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 18/10/2021.
//

import Foundation
import UIKit

final class HavaConstants: NSObject {
    let shared = HavaConstants()
    static let PNG = "png"
    static let PDF = "pdf"
    static let UTC = "UTC"
    static let OTP_COUNT = 4
    static var ADMIN_NUMBER = ""
    static let NETWORK = "network"
    static let ONLINE = "ONLINE"
    static let OFFLINE = "OFFLINE"
    static let GENERIC = "generic"
    static let RELEASE = "release"
    static let SCHEAME = "HavaDriver"
    static var SOUND = "CreateRequest"
    static let TRUE_URL = "truesdk://"
    static var START_SOUND = "StartTrip"
    static let MAX_ZOOM: Float = 15
    static let MIN_ZOOM: Float = 12
    static let MIN_VOLUME: Float = 0.2
    static let MAX_ZOOM_IN: Float = 19
    static let DIFF_CONSTANT: Double = 60
    static let DEEPLINK = "DEEPLINK"
    static let REFERRAL_CODE = "referral_code"
    static let DRIVER_PAYMENT = "DiverPayment"
    static let IMAGE_MIME = "image/png"
    static let HAVA_RIDER = "Hava:Home"
    static let NODE_PATH = "/driver/home"
    static let UNAVAILABLE = "unavailable"
    static let NEW_REQUEST = "New Request"
    static let DATE_FORMAT = "dd-MM-yyyy"
    static let UPLOAD_FORMAT = "YYYY-MM-dd"
    static let DEFAULT_PADDING: CGFloat = 8
    static let DOUBLE_PADDING: CGFloat = 16
    static let DEFAULT_LANGUAGE_CODE = "en"
    static let MAX_FILE_SIZE: Int = 2000000
    static var LARGE_FONT_SIZE: CGFloat = 16
    static let EXTRA_LARGE_FONT: CGFloat = 20
    static let MAP_TIMER_ESTIMATE: Double = 30
    static var DEFAULT_FONT_SIZE: CGFloat = 12
    static let ACCEPT_ACTION = "ACCEPT_ACTION"
    static let HEADER_VERSION = "X-App-Version"
    static let DECLINE_ACTION = "DECLINE_ACTION"
    static let MAXIMUM_DISTANCE: Double = 1000
    static let REQUEST_TIMEOUT: TimeInterval = 60
    static let WAZE_URL = "waze://"
    static let REFERRAL_KEY = "Referrals"
    static let CIFilterValueKey = "inputMessage"
    static let CIFilterName = "CIQRCodeGenerator"
    static let GMAPS_URL = "comgooglemaps://"
    static let PLATFORM_VERSION = "X-Platform-Version"
    static let HAVA_ITUNES_URL = "https://hava.bz/asd1"
    static let BURNER_TIME_VALUE = "HideBurnerTimeValue"
    static let VOLUME_KEY_PATH = "outputVolume"
    static let IDENTIFIER = Bundle.main.bundleIdentifier!
    static let THROTTLING: TimeInterval = 0.2
    static let INTRIP_TIMEINTERVAL: TimeInterval = 13
    static let LOCATION_UPDATE_FREQUENCY: TimeInterval = 29
    static let EXPECTED_REQUEST_DURATION: TimeInterval = 15
    static let ONLINE_LOCATION_UPDATE_FREQUENCY: Double = 29
    static let OFFLINE_LOCATION_UPDATE_FREQUENCY: Double = 60
    static let SHOW_OFFLINE_TIME_VALUE: TimeInterval = 10800
    static let PRIVATE_POLICY = "https://www.hava.bz/privacy/"
    static let DRIVER_TERMS = "https://www.hava.bz/driver-terms/"
    static let SHOW_VOLUME_VIEW_VALUE = "ShowVolumeModalValue"
    static let GO_OFFLINEVIEW_TIME_VALUE = "ShowGoOfflineViewValue"
    static let SENTRY_DSN = "https://f7644fca565a4b9d9720122c859247a9@sentry.io/1802455"
    static let APPSTORE_RIDER = URL(string: "itms-apps://itunes.apple.com/app/bars/1441086929")
    static let CLOUD_FUNCTIONSAPI = "https://us-central1-hava-mobile-apps.cloudfunctions.net/geolocation/"
    static let GOOGLE_ITUNES_APP_URL = "itms://itunes.apple.com/us/app/google-maps-transit-food/id585027354?mt=8"
    static let APPLE_TEST_USER = "+15155555555"
}
