// Copyright SIX DAY LLC. All rights reserved.

import BigInt
import Foundation
import UIKit

struct TransactionCellViewModel {

    let transaction: Transaction
    let chainState: ChainState
    let shortFormatter = EtherNumberFormatter.short

    init(
        transaction: Transaction,
        chainState: ChainState
    ) {
        self.transaction = transaction
        self.chainState = chainState
    }

    var confirmations: Int? {
        return chainState.confirmations(fromBlock: transaction.blockNumber)
    }

    var state: TransactionState {
        if transaction.isError {
            return .error
        }
        if confirmations == 0 {
            return .pending
        }
        return .completed
    }

    private var operationTitle: String? {
        return transaction.operation?.title
    }

    var title: String {
        if let operationTitle = operationTitle { return operationTitle }
        switch state {
        case .completed:
            switch transaction.direction {
            case .incoming: return "Received"
            case .outgoing: return "Sent"
            }
        case .error: return "Error"
        case .pending:
            switch transaction.direction {
            case .incoming: return "Receiving"
            case .outgoing: return "Sending"
            }
        }
    }

    var subTitle: String {
        switch transaction.direction {
        case .incoming: return "\(transaction.from)"
        case .outgoing: return "\(transaction.to)"
        }
    }

    var subTitleTextColor: UIColor {
        return Colors.gray
    }

    var subTitleFont: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
    }

    var amount: String {
        let value: String = {
            if let operation = transaction.operation {
                return shortFormatter.string(from: BigInt(operation.value) ?? BigInt(), decimals: operation.decimals)
            }
            let number = BigInt(transaction.value) ?? BigInt()
            return shortFormatter.string(from: number)
        }()
        guard value != "0" else { return value }
        switch transaction.direction {
        case .incoming: return "+\(value)"
        case .outgoing: return "-\(value)"
        }
    }

    var amountTextColor: UIColor {
        switch transaction.direction {
        case .incoming: return Colors.green
        case .outgoing: return Colors.red
        }
    }

    var amountFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
    }

    var backgroundColor: UIColor {
        switch state {
        case .completed:
            return .white
        case .error:
            return Colors.veryLightRed
        case .pending:
            return Colors.veryLightOrange
        }
    }

    var statusImage: UIImage? {
        switch state {
        case .error: return R.image.transaction_error()
        case .completed:
            switch transaction.direction {
            case .incoming: return R.image.transaction_received()
            case .outgoing: return R.image.transaction_sent()
            }
        case .pending:
            return R.image.transaction_pending()
        }
    }
}
