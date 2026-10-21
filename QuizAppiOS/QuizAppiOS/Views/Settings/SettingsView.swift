import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        Form {
            Picker("主题模式", selection: $settingsManager.settings.themeMode) {
                Text("跟随系统").tag(ThemeMode.system)
                Text("浅色").tag(ThemeMode.light)
                Text("深色").tag(ThemeMode.dark)
            }
        }
        .navigationTitle("设置")
    }
}
