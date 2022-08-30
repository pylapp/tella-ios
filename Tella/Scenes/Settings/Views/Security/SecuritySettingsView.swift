//  Tella
//
//  Copyright © 2022 INTERNEWS. All rights reserved.
//

import SwiftUI

struct SecuritySettingsView: View {
    
    @EnvironmentObject var appModel : MainAppModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @EnvironmentObject private var sheetManager: SheetManager
    @StateObject var lockViewModel = LockViewModel(unlockType: .update)
    @State var passwordTypeString : String = ""
    
    
    var body: some View {
        
        ContainerView {
            VStack(spacing: 0) {
               
                Spacer()
                    .frame(height: 8)

                SettingsCardView(cardViewArray: [lockView.eraseToAnyView(), lockTimeoutView.eraseToAnyView()])
                
                SettingsCardView(cardViewArray: [screenSecurityView.eraseToAnyView()])

                Spacer()
            }
        }
        
        .toolbar {
            LeadingTitleToolbar(title: LocalizableSettings.settSecAppBar.localized)
        }
        
        .onAppear {
            lockViewModel.shouldDismiss.send(false)
            let passwordType = AuthenticationManager().getPasswordType()
            passwordTypeString = passwordType == .tellaPassword ? LocalizableLock.lockSelectActionPassword.localized : LocalizableLock.lockSelectActionPin.localized
        }
        
    }
    
    var lockView: some View {
        
        SettingsItemView<AnyView>(imageName: "settings.lock",
                                  title: LocalizableSettings.settSecLock.localized,
                                  value: passwordTypeString,
                                  destination:unlockView.eraseToAnyView())
    }

    var lockTimeoutView: some View {
        
        SettingsItemView<AnyView>(imageName:"settings.timeout",
                                  title: LocalizableSettings.settSecLockTimeout.localized,
                                  value: appModel.settings.lockTimeout.displayName,
                                  destination:unlockView.eraseToAnyView()) {
            showLockTimeout()

        }
    }

 
    var screenSecurityView: some View {
        
        SettingToggleItem(title: LocalizableSettings.settSecScreenSecurity.localized,
                          description: LocalizableSettings.settSecScreenSecurityExpl.localized,
                          toggle: $appModel.settings.screenSecurity)
        
        
    }

    var unlockView : some View {
        
        let passwordType = AuthenticationManager().getPasswordType()
        return passwordType == .tellaPassword ?
        
        UnlockPasswordView()
            .environmentObject(lockViewModel)
            .eraseToAnyView()  :
        
        UnlockPinView()
            .environmentObject(lockViewModel)
            .eraseToAnyView()
        
    }
    
    func showLockTimeout() {
        sheetManager.showBottomSheet(modalHeight: 408) {
            LockTimeoutView()
                .environmentObject(settingsViewModel)
        }
    }
}

struct SecuritySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SecuritySettingsView()
    }
}
