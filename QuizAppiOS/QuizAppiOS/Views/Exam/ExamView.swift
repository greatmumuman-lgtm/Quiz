import SwiftUI

struct ExamView: View {
    @StateObject private var viewModel: ExamViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showAnswerCard = false
    @State private var showSubmitAlert = false
    
    init(bankId: Int64) {
        _viewModel = StateObject(wrappedValue: ExamViewModel(bankId: bankId))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("正在生成试卷...")
            } else if viewModel.questions.isEmpty {
                Text("题库中暂无题目")
                    .foregroundColor(.gray)
            } else if viewModel.examFinished {
                examResultView
            } else if let question = viewModel.currentQuestion {
                examQuestionView(question)
            }
        }
        .navigationTitle("模拟考试")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !viewModel.examFinished && !viewModel.questions.isEmpty {
                    Button("交卷") {
                        showSubmitAlert = true
                    }
                }
            }
        }
        .alert("确认交卷？", isPresented: $showSubmitAlert) {
            Button("取消", role: .cancel) {}
            Button("交卷", role: .destructive) {
                viewModel.finishExam()
            }
        }
        .onAppear {
            if viewModel.questions.isEmpty {
                viewModel.initExam()
            }
        }
    }
    
    private func examQuestionView(_ q: Question) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("题目 \(viewModel.currentIndex + 1) / \(viewModel.totalCount)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(q.content)
                .font(.system(size: 18))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(q.options, id: \.self) { option in
                        Button {
                            if let qId = q.id {
                                viewModel.selectAnswer(qId, option)
                            }
                        } label: {
                            HStack {
                                Image(systemName: isSelected(q, option) ? "checkmark.circle.fill" : "circle")
                                Text(option)
                                Spacer()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            
            Spacer()
            
            HStack {
                Button("上一题") {
                    viewModel.goToPrevious()
                }
                .disabled(viewModel.currentIndex == 0)
                
                Spacer()
                
                Button("下一题") {
                    viewModel.goToNext()
                }
                .disabled(viewModel.currentIndex >= viewModel.totalCount - 1)
            }
            .padding()
        }
        .padding()
    }
    
    private var examResultView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            Text("考试完成")
                .font(.title)
            Text("得分：\(viewModel.examScore) 分")
                .font(.headline)
            Text("答对：\(viewModel.correctCount) / \(viewModel.totalCount) 题")
                .foregroundColor(.gray)
            Button("返回") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
    }
    
    private func isSelected(_ q: Question, _ option: String) -> Bool {
        guard let qId = q.id else { return false }
        if q.questionType == .multi {
            return viewModel.examMulti[qId]?.contains(option) ?? false
        } else {
            return viewModel.examAnswers[qId] == option
        }
    }
}
