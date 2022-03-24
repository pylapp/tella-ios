//
//  Enums.swift
//  Tella
//
//  Created by Oliphant, Samuel on 2/17/20.
//  Copyright © 2020 Anessa Petteruti. All rights reserved.
//
/*
 Enum class
 */

import Foundation


enum PasswordTypeEnum: String, CaseIterable {
    
    case tellaPassword
    case tellaPin
    case passcode
    case biometric

    public func toFlag() -> SecAccessControlCreateFlags {
        switch(self) {
        case .tellaPassword, .tellaPin:
            return .applicationPassword
        case .biometric:
            return .biometryAny
        case .passcode:
            return .devicePasscode
        }
    }
}
