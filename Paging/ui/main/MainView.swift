import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = MainViewModel()

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AsyncAwaitView(onDismissed: viewModel.loadConfig)) {
                    Text("Launch Async/Await")
                        .font(.system(size: 20))
                        .foregroundColor(Color.primary)
                        .padding()
                }
                NavigationLink(destination: CombineView(onDismissed: viewModel.loadConfig)) {
                    Text("Launch Combine")
                        .font(.system(size: 20))
                        .foregroundColor(Color.primary)
                        .padding()
                }
                
                Spacer()
                
                Divider()
                
                VStack {
                    Toggle(isOn: $viewModel.firstPageError) {
                        Text("Error in first page")
                            .foregroundColor(Color.primary)
                    }
                    .toggleStyle(.automatic)
                    .onChange(of: viewModel.firstPageError) { value in
                        if value { viewModel.setFirstPageError() }
                    }

                    Toggle(isOn: $viewModel.secondPageError) {
                        Text("Error in second page")
                            .foregroundColor(Color.primary)
                    }
                    .onChange(of: viewModel.secondPageError) { value in
                        if value { viewModel.setSecondPageError() }
                    }
                    .toggleStyle(.automatic)

                }
                .padding()

                Divider()

                VStack {
                    Toggle(isOn: $viewModel.returnEmpty) {
                        Text("Return no messages")
                    }
                    .toggleStyle(.automatic)
                    .onChange(of: viewModel.returnEmpty) { value in
                        viewModel.setEmptyMessages(returnEmpty: value)
                    }
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            viewModel.loadConfig()
        }
    }
}

