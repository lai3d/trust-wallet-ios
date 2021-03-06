// Copyright SIX DAY LLC. All rights reserved.

import Foundation

struct ConfigExplorer {

    let server: RPCServer

    init(
        server: RPCServer
    ) {
        self.server = server
    }

    func transactionURL(for ID: String) -> URL {
        let urlString: String = {
            switch server {
            case .main:
                return ConfigExplorerConstants.etherscanMain + "/tx/" + ID
            case .kovan:
                return ConfigExplorerConstants.etherscanKovan + "/tx/" + ID
            case .ropsten:
                return ConfigExplorerConstants.etherscanRopsten + "/tx/" + ID
            case .oraclesTest:
                return ConfigExplorerConstants.oraclesMain + "/tx/" + ID
            }
        }()
        return URL(string: urlString)!
    }
}
