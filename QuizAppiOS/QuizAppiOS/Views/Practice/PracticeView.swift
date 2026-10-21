import SwiftUI

struct PracticeView: View {
    let bankId: Int64
    let bankName: String
    
    var body: some View {
        List {
            Section(header: Text("顺序练习")) {
                NavigationLink(destination: QuestionView(vm: QuestionViewModel(question: Question(bankId: bankId, questionType: .single, content: "示例题目", options: ["A", "B"], answer: "A", analysis: ""))))) {
                    Text("开始顺序练习")
                }
            }
            
            Section(header: Text("随机练习")) {
                NavigationLink(destination: Text("随机练习功能开发中...")) {
                    Text("开始随机练习")
                }
            }
        }
        .navigationTitle(bankName)
    }
}
