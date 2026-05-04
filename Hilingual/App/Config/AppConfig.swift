//
//  AppConfig.swift
//  Hilingual
//
//  Created by 성현주 on 7/9/25.
//

import Foundation

let BASE_URL = Bundle.main.infoDictionary?["BASE_URL"] as? String ?? ""
let TOKEN = Bundle.main.infoDictionary?["TOKEN"] as? String ?? ""
let MASTERKEY = Bundle.main.infoDictionary?["MASTERKEY"] as? String ?? ""
let AD_BANNER_UNIT_ID = Bundle.main.infoDictionary?["AD_BANNER_UNIT_ID"] as? String ?? ""
let AD_NATIVE_UNIT_ID = Bundle.main.infoDictionary?["AD_NATIVE_UNIT_ID"] as? String ?? ""
let AD_FEEDBACK_UNIT_ID = Bundle.main.infoDictionary?["AD_FEEDBACK_UNIT_ID"] as? String ?? ""
let AD_INTERSTITIAL_UNIT_ID = Bundle.main.infoDictionary?["AD_INTERSTITIAL_UNIT_ID"] as? String ?? ""
