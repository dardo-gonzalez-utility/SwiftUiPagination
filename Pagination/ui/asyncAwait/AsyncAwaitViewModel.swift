import Foundation

class AsyncAwaitViewModel: ObservableObject {
    
    @Published var messages : [Message] = []
    @Published var pagingStatus = PagingStatus.loadingFirstPage
    @Published var showLoadingCell = false
    @Published var showRetryCell = false

    private var messageIdUsedForLastQuery: Int = -1
    private let inboxDataSource = InboxDataSourceAsyncAwait(pageSize: 10)
    
    init() {
        pagingStatus = .loadingFirstPage
        retrieveNextPage()
    }
    
    func onCellAppeared(_ item: Message) {
        guard let lastMessage = messages.last, lastMessage.id == item.id, messageIdUsedForLastQuery != item.id else { return }
        messageIdUsedForLastQuery = item.id
        print("Requesting next page")
        retrieveNextPage()
    }

    func reloadPage() {
        if messages.isEmpty {
            reloadFirstPage()
        } else {
            reloadNextPage()
        }
    }
    
    private func reloadFirstPage() {
        apolloClient.errorInFirstPage = false
        pagingStatus = .loadingFirstPage
        retrieveNextPage()
    }
    
    private func reloadNextPage() {
        apolloClient.errorInSecondPage = false
        self.showRetryCell = false
        self.showLoadingCell = true
        retrieveNextPage()
    }
    
    private func retrieveNextPage() {
        Task {
            do {
                let pagedMessages = try await inboxDataSource.retrieveNextPage()
                processMessages(pagedMessages)
            } catch {
                processError(error)
            }
        }
    }
    
    func processMessages(_ pagedMessages: [Message]) {
        DispatchQueue.main.async {
            self.pagingStatus = .showMessages
            if pagedMessages.isEmpty {
                self.showLoadingCell = false
            } else {
                self.messages.append(contentsOf: pagedMessages)
                self.showLoadingCell = true
            }
        }
    }
    
    func processError(_ error: Error) {
        DispatchQueue.main.async {
            if self.messages.isEmpty {
                self.pagingStatus = .firstPageLoadingError
            } else {
                self.pagingStatus = .showMessages
                self.showRetryCell = true
                self.showLoadingCell = false
            }
        }
    }
}

