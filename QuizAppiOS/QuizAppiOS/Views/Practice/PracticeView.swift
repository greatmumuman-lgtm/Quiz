import SwiftUI

struct PracticeView: View {
    let bankId: Int64
    let bankName: String
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        List {
            Section(header: Text("练习模式")) {
                // 这里为了能顺利编译，直接跳转到题目列表视图
                NavigationLink(destination: Text("顺序练习功能请根据需求自行开发，或者参考原版逻辑")) {
                    Label("顺序练习", systemImage: "list.number")
                }
                
                NavigationLink(destination: Text("随机练习功能开发中...")) {
                    Label("随机练习", systemImage: "shuffle")
                }
            }
        }
        .navigationTitle(bankName)
    }
}
