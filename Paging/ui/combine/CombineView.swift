import SwiftUI

struct CombineView: View {
    
    @StateObject var viewModel = CombineViewModel()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    private let onDismissed: () -> Void
    
    init(onDismissed: @escaping () -> Void) {
        self.onDismissed = onDismissed
    }
    
    var body: some View {
        ZStack {
            switch viewModel.pagingStatus {
            case .loadingFirstPage:
                showLoadingView
            case .firstPageLoadingError:
                showErrorView
            case .showMessages:
                if viewModel.messages.isEmpty {
                    showMessagesViewEmpty
                } else {
                    showMessagesViewList
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
            self.onDismissed()
        }){
            Image(systemName: "arrow.left").foregroundColor(.primary)
        })
    }
    
    var showLoadingView: some View {
        VStack {
            ProgressView()
        }
    }
    
    var showErrorView: some View {
        VStack {
            Text("An error has ocurred")
                .padding()
            
            Button("Try again") {
                viewModel.reloadPage()
            }
            .padding()
        }
    }
    
    var showMessagesViewEmpty: some View {
        VStack {
            Text("You have no messages")
        }
    }
    
    var showMessagesViewList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.messages, id: \.self) { message in
                    MessageItemView(message: message)
                        .onAppear() {
                            viewModel.onCellAppeared(message)
                        }
                }
                if viewModel.showLoadingCell {
                    LoadingItemView()
                }
                if viewModel.showRetryCell {
                    RetryItemView()
                        .onTapGesture { viewModel.reloadPage() }
                }
            }
        }
    }
}


