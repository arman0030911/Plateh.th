import Foundation

// MARK: - Assembly / Dependency Injection Container
// Responsible for composing dependencies following Clean Architecture principles

final class Assembly {
    
    // MARK: - Main ViewModel
    
    static func createMainViewModel() -> MainViewModel {
        let dataSource = FetchPaymentsManager()
        let repository = FetchPaymentsRepositoryImpl(dataSource: dataSource)
        let useCase = FetchPaymentsUseCaseImpl(repository: repository)
        
        let setDataSource = SetPaymentManager()
        let setRepository = SetPaymentRepositoryImpl(dataSource: setDataSource)
        let setUseCase = SetPaymentUseCaseImpl(repository: setRepository)
        
        return MainViewModel(FetchUseCase: useCase, setUseCase: setUseCase)
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
        let dataSource = FetchPaymentsManager()
        let repository = FetchPaymentsRepositoryImpl(dataSource: dataSource)
        let useCase = FetchPaymentsUseCaseImpl(repository: repository)

        let setDataSource = SetPaymentManager()
        let setRepository = SetPaymentRepositoryImpl(dataSource: setDataSource)
        let setUseCase = SetPaymentUseCaseImpl(repository: setRepository)

        return PaymentsViewModel(fetchUseCase: useCase, setUseCase: setUseCase)
    }

    // MARK: - Details ViewModel
    
    static func createDetailsViewModel() -> DetailsViewModel {
        let fetchDataSource = FetchPaymentsManager()
        let fetchRepository = FetchPaymentsRepositoryImpl(dataSource: fetchDataSource)
        let fetchUseCase = FetchPaymentsUseCaseImpl(repository: fetchRepository)

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
