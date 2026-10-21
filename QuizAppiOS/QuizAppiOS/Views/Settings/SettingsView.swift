import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showReminderTimePicker = false
    
    var body: some View {
        Form {
            Section {
                Picker("主题", selection: $settingsManager.settings.themeMode) {
                    Text("跟随系统").tag(ThemeMode.system)
                    Text("浅色").tag(ThemeMode.light)
                    Text("深色").tag(ThemeMode.dark)
                }
            } header: {
                Text("外观")
            }
            
            Section {
                Toggle("开启每日提醒", isOn: $settingsManager.settings.reminderEnabled)
                    .onChange(of: settingsManager.settings.reminderEnabled) { enabled in
                        if enabled {
                            ReminderService.shared.requestPermission()
                        }
                    }
                
                if settingsManager.settings.reminderEnabled {
                    DatePicker("提醒时间", selection: $settingsManager.settings.reminderTime, displayedComponents: .hourAndMinute)
                        .onChange(of: settingsManager.settings.reminderTime) { newTime in
                            ReminderService.shared.scheduleReminder(at: newTime)
                        }
                }
            } header: {
                Text("学习提醒")
            }
        }
        .navigationTitle("设置")
    }
}
