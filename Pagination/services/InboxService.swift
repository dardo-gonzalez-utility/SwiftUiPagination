import Foundation
import Combine

enum MessagesError: Error {
    case unknown
}

/**
 InboxService that handles queries to obtain the messages from BE
 */

// InboxService implementation for using async/await
class InboxServiceAsyncAwait {
    func getMessagesWithAsyncAwait(after: Int, first: Int) async throws -> DataSourcePage<Message> {
        return try await withCheckedThrowingContinuation { continuation in
            let query = GraphQLMessagesQuery(after: after, first: first)
            apolloClient.fetch(query: query) { result in
                switch result {
                case .success(let response):
                    guard let response = response.data else {
                        return continuation.resume(throwing: MessagesError.unknown)
                    }
                    let pagedMessages = DataSourcePage(totalCount: response.totalCount, page: response.messages.map { Message(graphQLMessageEntity: $0) })
                    continuation.resume(returning: pagedMessages)
                case .failure(let error):
                    return continuation.resume(throwing: error)
                }
            }
        }
    }
}


// InboxService implementation for using combine
class InboxServiceCombine {
    func getMessagesWithCombine(page: Int) -> AnyPublisher<[Message], Error> {
        let subject = PassthroughSubject<[Message], Error>()
        
        let query = GraphQLMessagesQuery(after: page, first: 10)
        apolloClient.fetch(query: query) { result in
            switch result {
            case .success(let response):
                if let messagesGraphQL = response.data  {
                    subject.send(messagesGraphQL.messages.map { Message(graphQLMessageEntity: $0) })
                } else {
                    subject.send(completion: .failure(MessagesError.unknown))
                }
            case .failure(let error):
                subject.send(completion: .failure(error))
            }
        }

        return subject.eraseToAnyPublisher()
    }
}
