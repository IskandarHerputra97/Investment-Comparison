//
//  InvestmentProductDetail.swift
//  Investment Comparison
//
//  Created by Iskandar Herputra Wahidiyat on 24/06/22.
//

import Foundation

struct InvestmentProductDetail: Codable {
    let code: String
    let name: String
    let details: MutualFundDetail
}
