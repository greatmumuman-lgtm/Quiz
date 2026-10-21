import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        List {
            // 统计区
            Section {
                HStack(spacing: 0) {
                    StatCell(value: "\(Int(viewModel.totalDuration / 60))分", label: "总时长", icon: "clock.fill", color: .blue)
                    StatCell(value: "\(viewModel.totalAnswered)", label: "总答题", icon: "list.bullet", color: .green)
                    StatCell(value: "\(viewModel.totalExams)", label: "考试", icon: "doc.text.fill", color: .orange)
                }
                .padding(.vertical, 8)
            } header: {
                Text("学习统计")
            }

            // 错题
            if viewModel.bankId != nil {
                Section {
                    Text("错题重做功能开发中...")
                        .foregroundColor(.secondary)
                } header: {
                    Text("错题库")
                }
            }

            // 练习记录
            if !viewModel.practiceRecords.isEmpty {
                Section {
                    ForEach(viewModel.practiceRecords, id: \.id) { record in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("练习记录")
                                    .font(.subheadline.bold())
                                Spacer()
                                Text("正确: \(record.correctCount) / 错误: \(record.wrongCount)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("练习记录")
                }
            }

            // 考试记录
            if !viewModel.examRecords.isEmpty {
                Section {
                    ForEach(viewModel.examRecords, id: \.id) { record in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("得分: \(record.score)分")
                                    .font(.subheadline.bold())
                                Text("\(record.correctCount)/\(record.totalCount) 正确")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                } header: {
                    Text("考试记录")
                }
            }
            
            // 关于
            Section {
                Text("刷题助手 iOS v1.0")
                    .font(.headline)
                Text("著作权人：唐家俊\n仅供分享学习使用。")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("关于")
            }
        }
        .navigationTitle("我的")
        .onAppear { viewModel.loadStats() }
    }
}

struct StatCell: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            Text(value)
                .font(.subheadline.bold())
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
