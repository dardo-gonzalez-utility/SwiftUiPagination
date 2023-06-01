import Foundation
import Combine

open class DataSourceCombine<T: Identifiable> {
    
    private var page = 1
    private let pageSize: Int
    private var totalCount = -1
    private var retrievedIds: [T.ID] = []
    private var subscription: AnyCancellable?

    internal func fetchRequest(after: Int, first: Int) -> AnyPublisher<DataSourcePage<T>, Error> {
        fatalError("Fetch method not implemented")
    }

    init(pageSize: Int) {
        self.pageSize = pageSize
    }

    func retrieveNextPage() -> AnyPublisher<[T], Error>  {
        let subject = PassthroughSubject<[T], Error>()

        if !shouldRetrieveNextPage() {
            DispatchQueue.main.async {
                subject.send([])
            }
        } else {
            subscription = fetchRequest(after: page - 2, first: pageSize)
                .sink(
                    receiveCompletion: { [weak self] result in
                        if case .failure(let error) = result {
                            subject.send(completion: .failure(error))
                        } else {
                            self?.page += 1
                            self?.totalCount = 0
                            subject.send([])
                        }
                    },
                    receiveValue: { [weak self] dataSourcePage in
                        self?.page += 1
                        self?.totalCount = dataSourcePage.totalCount // totalCount may vary between subsequent calls because new items can be added in the BE
                        let page = self?.processPage(page: dataSourcePage.page) ?? dataSourcePage.page
                        subject.send(page)
                    }
                )
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    private func shouldRetrieveNextPage() -> Bool {
        totalCount < 0 ? true : page * pageSize < totalCount
    }

    // If new items are added in the BE between subsequent calls, this can result in getting
    // again a previously obtained item in the next requested page. To avoid duplicating it
    // we check them with the already retrieved ids
    private func processPage(page: [T]) -> [T] {
        let newItems = page.filter { !retrievedIds.contains($0.id) }
        retrievedIds.append(contentsOf: newItems.map { $0.id} )
        return newItems
    }
}
