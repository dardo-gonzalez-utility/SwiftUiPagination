import Foundation
import Combine

class InboxDataSourceCombine: DataSourceCombine<Message> {
    
    private let inboxService = InboxServiceCombine()
    
    override func fetchRequest(after: Int, first: Int) -> AnyPublisher<DataSourcePage<Message>, Error> {
        return inboxService.getMessagesWithCombine(after: after, first: first)
    }
}
