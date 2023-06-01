import Foundation
import Combine

class CombineViewModel: ObservableObject {
    
    @Published var messages : [Message] = []
    @Published var pagingStatus = PagingStatus.loadingFirstPage
    @Published var showLoadingCell = false
    @Published var showRetryCell = false

    private var messageIdUsedForLastQuery: Int = -1
    private let inboxDataSource = InboxDataSourceCombine(pageSize: 10)
    private var subscription: AnyCancellable?

    init() {
        pagingStatus = .loadingFirstPage
        retrieveNextPage()
    }
    
    func onCellAppeared(_ item: Message){
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
        subscription = inboxDataSource.retrieveNextPage()
            .sink(
                receiveCompletion: { [weak self] result in
                    if case .failure(let error) = result {
                        self?.processError(error)
                    } else {
                        self?.processMessages([])
                    }
                },
                receiveValue: { [weak self] messages in
                    self?.processMessages(messages)
                }
            )
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
        subscription?.cancel()
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
        subscription?.cancel()
    }
}

