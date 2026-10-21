import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        List {
            // Stats section
            Section {
                HStack(spacing: 0) {
                    StatCell(value: formatDuration(viewModel.totalDuration), label: "总时长", icon: "clock.fill", color: .blue)
                    StatCell(value: "\(viewModel.totalAnswered)", label: "总答题", icon: "list.bullet", color: .green)
                    StatCell(value: "\(viewModel.totalExams)", label: "考试次数", icon: "doc.text.fill", color: .orange)
                }
                .padding(.vertical, 8)
            } header: {
                Text("学习统计")
            }

            // Wrong questions
            if let _ = viewModel.bankId {
                Section {
                    NavigationLink {
                        // 原作者的 QuestionListView 缺失，这里用临时视图代替，防止报错
                        Text("错题重做功能开发中...")
                            .foregroundColor(.secondary)
                    } label: {
                        Label("错题重做 (\(viewModel.totalWrongCount)题)", systemImage: "xmark.circle")
                            .foregroundColor(.red)
                    }
                } header: {
                    Text("错题库")
                }
            }

            // Practice records
            if !viewModel.practiceRecords.isEmpty {
                Section {
                    ForEach(viewModel.practiceRecords, id: \.id) { record in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(getModeLabel(record.mode))
                                    .font(.subheadline.bold())
                                Spacer()
                                Text(formatDate(record.practiceDate))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            HStack(spacing: 16) {
                                Text("正确: \(record.correctCount)")
                                    .foregroundColor(.green)
                                Text("错误: \(record.wrongCount)")
                                    .foregroundColor(.red)
                                Text(formatDuration(record.duration))
                                    .foregroundColor(.secondary)
                            }
                            .font(.caption)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                if let id = record.id {
                                    viewModel.deletePracticeRecord(id)
                                }
                            } label: {
                                Label("删除", systemImage: "trash")
                            }
                        }
                    }
                } header: {
                    Text("练习记录")
                }
            }

            // Exam records
            if !viewModel.examRecords.isEmpty {
                Section {
                    ForEach(viewModel.examRecords, id: \.id) { record in
                        NavigationLink {
                            ExamRecordDetailView(record: record)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("得分: \(record.score)分")
                                        .font(.subheadline.bold())
                                    Text("\(record.correctCount)/\(record.totalCount) 正确")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(formatDate(record.examDate))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("考试记录")
                }
            }

            // Copyright
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("刷题助手 iOS")
                        .font(.headline)
                    Text("版本 1.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("著作权声明")
                        .font(.subheadline.bold())
                    Text("本软件著作权人：唐家俊\n本软件仅用于分享学习使用，不可用于任何商业行为。")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("关于")
            }
        }
        .navigationTitle("我的")
        .onAppear { viewModel.loadStats() }
    }
    
    // MARK: - 补齐原作者缺失的工具方法
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        return "\(minutes)分"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    private func getModeLabel(_ mode: String) -> String {
        switch mode {
        case "sequential": return "顺序练习"
        case "random": return "随机练习"
        case "type": return "分类练习"
        case "wrong": return "错题练习"
        case "favorite": return "收藏练习"
        default: return mode
        }
    }
}

// MARK: - Stat Cell

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

// MARK: - Exam Record Detail View

struct ExamRecordDetailView: View {
    let record: ExamRecord

    var body: some View {
        List {
            Section {
                HStack {
                    Text("得分")
                    Spacer()
                    Text("\(record.score) 分")
                }
                HStack {
                    Text("正确率")
                    Spacer()
                    Text("\(record.totalCount > 0 ? record.correctCount * 100 / record.totalCount : 0)%")
                }
                HStack {
                    Text("正确/总题")
                    Spacer()
                    Text("\(record.correctCount)/\(record.totalCount)")
                }
                HStack {
                    Text("考试时间")
                    Spacer()
                    Text(formatFullDate(record.examDate))
                }
            } header: {
                Text("考试概况")
            }

            if !record.questionDetails.isEmpty {
                Section {
                    let details = parseDetails()
                    ForEach(Array(details.enumerated()), id: \.offset) { index, detail in
                        HStack {
                            Text("\(index + 1).")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Image(systemName: detail.isCorrect ? "checkmark" : "xmark")
                                .foregroundColor(detail.isCorrect ? .green : .red)
                            Text("题\(detail.questionId)")
                                .fimport SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        List {
            // Stats section
            Section {
                HStack(spacing: 0) {
                    StatCell(value: formatDuration(viewModel.totalDuration), label: "总时长", icon: "clock.fill", color: .blue)
                    StatCell(value: "\(viewModel.totalAnswered)", label: "总答题", icon: "list.bullet", color: .green)
                    StatCell(value: "\(viewModel.totalExams)", label: "考试次数", icon: "doc.text.fill", color: .orange)
                }
                .padding(.vertical, 8)
            } header: {
                Text("学习统计")
            }

            // Wrong questions
            if let _ = viewModel.bankId {
                Section {
                    NavigationLink {
                        // 原作者的 QuestionListView 缺失，这里用临时视图代替，防止报错
                        Text("错题重做功能开发中...")
                            .foregroundColor(.secondary)
                    } label: {
                        Label("错题重做 (\(viewModel.totalWrongCount)题)", systemImage: "xmark.circle")
                            .foregroundColor(.red)
                    }
                } header: {
                    Text("错题库")
                }
            }

            // Practice records
            if !viewModel.practiceRecords.isEmpty {
                Section {
                    ForEach(viewModel.practiceRecords, id: \.id) { record in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(getModeLabel(record.mode))
                                    .font(.subheadline.bold())
                                Spacer()
                                Text(formatDate(record.practiceDate))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            HStack(spacing: 16) {
                                Text("正确: \(record.correctCount)")
                                    .foregroundColor(.green)
                                Text("错误: \(record.wrongCount)")
                                    .foregroundColor(.red)
                                Text(formatDuration(record.duration))
                                    .foregroundColor(.secondary)
                            }
                            .font(.caption)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                if let id = record.id {
                                    viewModel.deletePracticeRecord(id)
                                }
                            } label: {
                                Label("删除", systemImage: "trash")
                            }
                        }
                    }
                } header: {
                    Text("练习记录")
                }
            }

            // Exam records
            if !viewModel.examRecords.isEmpty {
                Section {
                    ForEach(viewModel.examRecords, id: \.id) { record in
                        NavigationLink {
                            ExamRecordDetailView(record: record)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("得分: \(record.score)分")
                                        .font(.subheadline.bold())
                                    Text("\(record.correctCount)/\(record.totalCount) 正确")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(formatDate(record.examDate))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("考试记录")
                }
            }

            // Copyright
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("刷题助手 iOS")
                        .font(.headline)
                    Text("版本 1.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("著作权声明")
                        .font(.subheadline.bold())
                    Text("本软件著作权人：唐家俊\n本软件仅用于分享学习使用，不可用于任何商业行为。")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("关于")
            }
        }
        .navigationTitle("我的")
        .onAppear { viewModel.loadStats() }
    }
    
    // MARK: - 补齐原作者缺失的工具方法
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        return "\(minutes)分"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    private func getModeLabel(_ mode: String) -> String {
        switch mode {
        case "sequential": return "顺序练习"
        case "random": return "随机练习"
        case "type": return "分类练习"
        case "wrong": return "错题练习"
        case "favorite": return "收藏练习"
        default: return mode
        }
    }
}

// MARK: - Stat Cell

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

// MARK: - Exam Record Detail View

struct ExamRecordDetailView: View {
    let record: ExamRecord

    var body: some View {
        List {
            Section {
                HStack {
                    Text("得分")
                    Spacer()
                    Text("\(record.score) 分")
                }
                HStack {
                    Text("正确率")
                    Spacer()
                    Text("\(record.totalCount > 0 ? record.correctCount * 100 / record.totalCount : 0)%")
                }
                HStack {
                    Text("正确/总题")
                    Spacer()
                    Text("\(record.correctCount)/\(record.totalCount)")
                }
                HStack {
                    Text("考试时间")
                    Spacer()
                    Text(formatFullDate(record.examDate))
                }
            } header: {
                Text("考试概况")
            }

            if !record.questionDetails.isEmpty {
                Section {
                    let details = parseDetails()
                    ForEach(Array(details.enumerated()), id: \.offset) { index, detail in
                        HStack {
                            Text("\(index + 1).")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Image(systemName: detail.isCorrect ? "checkmark" : "xmark")
                                .foregroundColor(detail.isCorrect ? .green : .red)
                            Text("题\(detail.questionId)")
                                .font(.caption)
                            Text("答: \(detail.userAnswer.isEmpty ? "未作答" : detail.userAnswer)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("答题详情")
                }
            }
        }
        .navigationTitle("考试详情")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }

    private func parseDetails() -> [ExamDetail] {
        guard let data = record.questionDetails.data(using: .utf8),
              let details = try? JSONDecoder().decode([ExamDetail].self, from: data) else {
            return []
        }
        return details
    }
}ont(.caption)
                            Text("答: \(detail.userAnswer.isEmpty ? "未作答" : detail.userAnswer)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("答题详情")
                }
            }
        }
        .navigationTitle("考试详情")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }

    private func parseDetails() -> [ExamDetail] {
        guard let data = record.questionDetails.data(using: .utf8),
              let details = try? JSONDecoder().decode([ExamDetail].self, from: data) else {
            return []
        }
        return details
    }
}
