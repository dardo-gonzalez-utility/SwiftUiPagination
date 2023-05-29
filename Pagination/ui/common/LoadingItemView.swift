import SwiftUI

struct LoadingItemView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.primary))
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 80, maxHeight: 80, alignment: .center)
        .background(Color.secondary)
        .cornerRadius(10.0)
        .padding(.vertical, 5)
    }
}
