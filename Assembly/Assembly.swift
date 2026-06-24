import Foundation

// MARK: - Assembly / Dependency Injection Container
// Responsible for composing dependencies following Clean Architecture principles

final class Assembly {
    
    // MARK: - Shared Dependencies
    
    private static func makeFetchPaymentsUseCase() -> FetchPaymentsUseCase {
        let dataSource = FetchPaymentsManager()
        let repository = FetchPaymentsRepositoryImpl(dataSource: dataSource)
        return FetchPaymentsUseCaseImpl(repository: repository)
    }
    
    private static func makeSetPaymentUseCase() -> SetPaymentUseCase {
        let dataSource = SetPaymentManager()
        let repository = SetPaymentRepositoryImpl(dataSource: dataSource)
        return SetPaymentUseCaseImpl(repository: repository)
    }
    
    // MARK: - Main ViewModel
    
    static func createMainViewModel() -> MainViewModel {
        let fetchUseCase = makeFetchPaymentsUseCase()
        let setUseCase = makeSetPaymentUseCase()
        
        return MainViewModel(FetchUseCase: fetchUseCase, setUseCase: setUseCase)
    }
    
    // MARK: - Add ViewModel
    
    static func createAddViewModel() -> AddViewModel {
        let manager = CreatePaymentManager()
        let repository = CreatePaymentRepositoryImpl(dataSource: manager)
        let useCase = CreatePaymentUseCaseImpl(repository: repository)
        return AddViewModel(createUseCase: useCase)
    }
    
    // MARK: - Payments ViewModel
    
    static func createPaymentsViewModel() -> PaymentsViewModel {
        let fetchUseCase = makeFetchPaymentsUseCase()
        let setUseCase = makeSetPaymentUseCase()
        
        return PaymentsViewModel(fetchUseCase: fetchUseCase, setUseCase: setUseCase)
    }

    // MARK: - Details ViewModel
    
    static func createDetailsViewModel() -> DetailsViewModel {
        let fetchUseCase = makeFetchPaymentsUseCase()
        
        let updateDataSource = UpdatePaymentManager()
        let updateRepository = UpdatePaymentRepositoryImpl(dataSource: updateDataSource)
        let updateUseCase = UpdatePaymentUseCaseImpl(repository: updateRepository)

        let deleteDataSource = DeletePaymentManager()
        let deleteRepository = DeletePaymentRepositoryImpl(dataSource: deleteDataSource)
        let deleteUseCase = DeletePaymentUseCaseImpl(repository: deleteRepository)

        return DetailsViewModel(
            fetchUseCase: fetchUseCase,
            updateUseCase: updateUseCase,
            deleteUseCase: deleteUseCase
        )
    }

    // MARK: - Login ViewModel
    
    static func createLoginViewModel() -> LoginViewModel {
        return LoginViewModel()
    }
}
