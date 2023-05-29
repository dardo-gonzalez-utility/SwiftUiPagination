import Foundation

class MainViewModel: ObservableObject {
    
    @Published var firstPageError: Bool = false
    @Published var secondPageError: Bool = false
    @Published var returnEmpty: Bool = false

    func setFirstPageError() {
        firstPageError = true
        apolloClient.errorInFirstPage = true
    }

    func setSecondPageError() {
        secondPageError = true
        apolloClient.errorInSecondPage = true
    }
    
    func setEmptyMessages(returnEmpty: Bool) {
        apolloClient.emptyMessages = returnEmpty
    }
    
    func loadConfig() {
        firstPageError = apolloClient.errorInFirstPage
        secondPageError = apolloClient.errorInSecondPage
    }
}

