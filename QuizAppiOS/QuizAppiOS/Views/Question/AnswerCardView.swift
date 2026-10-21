import SwiftUI

struct AnswerCardView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ExamViewModel
    @State private var searchText = ""
    
    var filteredQuestions: [Question] {
        if searchText.isEmpty {
            return viewModel.questions
        } else {
            return viewModel.questions.filter { $0.content.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 12) {
                    ForEach(0..<filteredQuestions.count, id: \.self) { index in
                        let q = filteredQuestions[index]
                        if let qId = q.id {
                            Button {
                                if let originalIndex = viewModel.questions.firstIndex(where: { $0.id == qId }) {
                                    viewModel.currentIndex = originalIndex
                                    dismiss()
                                }
                            } label: {
                                Text("\(index + 1)")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 44, height: 44)
                                    .background(viewModel.isQuestionAnswered(qId) ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                    .foregroundColor(viewModel.isQuestionAnswered(qId) ? .blue : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
            }
            .searchable(text: $searchText, prompt: "输入题目关键词")
            .navigationTitle("答题卡")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 严格使用 ToolbarItem 消除歧义
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
        }
    }
}
