import SwiftUI

struct QuestionView: View {
    @ObservedObject var vm: QuestionViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 题目类型标识
                HStack {
                    Text(vm.question.questionType.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                    Spacer()
                }
                
                // 题目内容
                Text(vm.question.content)
                    .font(.system(size: 18))
                    .padding(.vertical, 8)
                
                // 选项区域
                switch vm.question.questionType {
                case .single, .judge:
                    ForEach(vm.question.options, id: \.self) { option in
                        Button {
                            vm.submitSingle(option)
                        } label: {
                            HStack {
                                Text(option)
                                    .foregroundColor(.primary)
                                Spacer()
                                if vm.showResult && option == vm.question.answer {
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                } else if vm.showResult && option == vm.selectedAnswer && !vm.isCorrect {
                                    Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .disabled(vm.showResult)
                    }
                case .multi:
                    ForEach(vm.question.options, id: \.self) { option in
                        Button {
                            vm.toggleMulti(option)
                        } label: {
                            HStack {
                                Image(systemName: vm.multiSelected.contains(option) ? "checkmark.square.fill" : "square")
                                Text(option)
                                Spacer()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .disabled(vm.showResult)
                    }
                    
                    if !vm.showResult {
                        Button("确认提交") {
                            vm.confirmMulti()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                    }
                case .fill:
                    Text("填空题暂不支持作答")
                        .foregroundColor(.gray)
                }
                
                // 解析区域
                if vm.showResult {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("答案解析")
                            .font(.headline)
                        Text("正确答案：\(vm.question.answer)")
                            .foregroundColor(vm.isCorrect ? .green : .red)
                        if !vm.question.analysis.isEmpty {
                            Text(vm.question.analysis)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("题目详情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        vm.toggleFavorite()
                    } label: {
                        Image(systemName: vm.isFavorite ? "star.fill" : "star")
                    }
                    Button {
                        vm.toggleMarked()
                    } label: {
                        Image(systemName: vm.isMarked ? "flag.fill" : "flag")
                    }
                }
            }
        }
    }
}
