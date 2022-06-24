//
//  MutualFundDetail.swift
//  Investment Comparison
//
//  Created by Iskandar Herputra Wahidiyat on 24/06/22.
//

import Foundation

struct MutualFundDetail: Codable {
    let im_avatar: String
    let type: String
    let return_one_year: Double
    let min_subscription: Double
    let inception_date: String
    let total_unit: Double
    let nav: Double
}
