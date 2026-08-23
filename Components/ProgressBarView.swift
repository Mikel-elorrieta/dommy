import SwiftUI

struct ProgressBarView: View {
    let completed: Int
    let total: Int
    let percent: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(completed) / \(total) completados")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(Int(percent * 100))%")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.yellow)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.1))
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(colors: [.red, .yellow], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: geo.size.width * percent)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: percent)
                }
            }
            .frame(height: 10)
        }
    }
}
