//
//  CurrencyViewModel.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import Foundation
import Combine

class CurrencyViewModel: ObservableObject {
    static let shared = CurrencyViewModel()
    private let service = CurrencyService.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currencies: Array<String> = []
    
    @Published var cards = [
        Card(currency: "EUR", balance: 1000, color: .blue, number: "**** **** **** 5236"),
        Card(currency: "USD", balance: 0.0, color: .yellow, number: "**** **** **** 4123"),
        Card(currency: "JPY", balance: 0.0, color: .red, number: "**** **** **** 8341")
    ]
    
    @Published var swipedCard = 0

    @Published var baseCurrency: String = ""
    @Published var baseAmount: Decimal = 0.0
    
    @Published var quoteCurrency: String = ""
    @Published var quoteAmount: Decimal = 0.0
    
    @Published var settings: Settings = Settings(commissionFee: 0.0, minFreeConversion: 0, availFreeConversions: 0)
    
    @Published var showMessage: Bool = false
    
    var title: String = ""
    var message: String = ""
    
    private var bCurrency: String = ""
    private var qCurrency: String = ""
    
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    init() {
        loadSettings()
        loadCurrencies()
        
        // for the sake of sampling, use the first 2 available currencies
        baseCurrency = availableCurrencies.first ?? ""
        quoteCurrency = availableConversions.first ?? ""
        
        bCurrency = baseCurrency
        qCurrency = quoteCurrency
        
        $baseAmount
            .dropFirst()
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.convert()
            })
            .store(in: &cancellables)
        
        $baseCurrency
            .dropFirst()
            .sink(receiveValue: { [weak self] value in
                self?.bCurrency = value
                self?.convert()
            })
            .store(in: &cancellables)
        
        $quoteCurrency
            .dropFirst()
            .sink(receiveValue: { [weak self] value in
                self?.qCurrency = value
                self?.convert()
            })
            .store(in: &cancellables)
    }
    
    func convert() {
        guard !bCurrency.isEmpty && !qCurrency.isEmpty else {
            return
        }
        
        let money = Money(currency: bCurrency, amount: String(describing: baseAmount))
        let _ = try? service.convert(money, toCurrency: qCurrency)
            .map(\.value)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("failed: \(error.localizedDescription)")
                case .finished:
                    print(completion)
                }
            } receiveValue: { [weak self] money in
                self?.quoteAmount = Decimal(string: money.amount) ?? 0.0
            }
            .store(in: &cancellables)
    }
    
    // This should be synced to the server
    func applyConversion() {
        guard let baseIndex = cards.firstIndex(where: { card in
            card.currency == bCurrency
        }), let quoteIndex = cards.firstIndex(where: { card in
            card.currency == qCurrency
        }) else {
            title = "Unable to convert"
            message = "Invalid currency"
            showMessage = true
            return
        }
        
        let freeConversions = settings.availFreeConversions
        let commision = (freeConversions > 0 || baseAmount >= Decimal(settings.minFreeConversion)) ? 0 : (baseAmount * Decimal(settings.commissionFee / 100))
        
        let total = baseAmount + commision
        guard cards[baseIndex].balance >= total else {
            title = "Unable to proceed"
            message = "Insufficient funds"
            showMessage = true
            return
        }
        cards[baseIndex].balance -= total
        
        cards[quoteIndex].balance += quoteAmount
        
        if freeConversions > 0 {
            settings.availFreeConversions -= 1
        }
        
        title = "Currency Converted"
        message = """
            You have converted \(baseAmount) \(bCurrency) to
            \(quoteAmount) \(qCurrency). Commision Fee - \(commision) \(bCurrency)
            """
        showMessage = true
    }
    
    // This is just a sample. Ideally would be great if it can be fetched from the server
    fileprivate func loadCurrencies() {
        guard let path = Bundle.main.path(forResource: "Currencies", ofType: "plist") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url), let plist = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: String] else {
            return
        }
        
        plist.keys.forEach { key in
            currencies.append(key)
        }
    }
    
    var availableCurrencies: Array<String> {
        let available = currencies.filter({ currency in
            currency != quoteCurrency && cards.filter({ card in
                card.currency == currency && card.balance > 0
            }).map { card in card.currency }.contains(currency)
        })
        
        return available
    }
    
    var availableConversions: Array<String> {
        let available = currencies.filter({ currency in
            currency != baseCurrency
        })
        
        return available
    }
    
    // This is typically fetched from the server
   fileprivate func loadSettings() {
        guard let path = Bundle.main.path(forResource: "Settings", ofType: "plist") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else {
            return
        }
       
       do {
           let decoder = PropertyListDecoder()
           settings = try decoder.decode(Settings.self, from: data)
           print("settings: \(settings)")
       } catch {
           print("error loading settings: \(error)")
       }
    }
    
    deinit {
        cancellables.removeAll()
    }
}
