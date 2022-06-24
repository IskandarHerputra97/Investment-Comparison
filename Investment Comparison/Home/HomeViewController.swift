//
//  HomeViewController.swift
//  Investment Comparison
//
//  Created by Iskandar Herputra Wahidiyat on 24/06/22.
//

import UIKit

enum MutualFundModelItemType {
    case comparePercentage
    case mutualFund
    case mutualFundType
    case mutualFundYield
    case mutualFundManagedFunds
    case mutualFundMinimumPurchase
    case mutualFundTimePeriod
    case mutualFundRiskLevel
    case mutualFundLaunchingDate
    case mutualFundAction
}

class MutualFundModelItem {
    var type: MutualFundModelItemType
    
    init(type: MutualFundModelItemType) {
        self.type = type
    }
}

class ComparePercentage {
    var type: MutualFundModelItemType {
        return .comparePercentage
    }
}

class MutualFundItem {
    var type: MutualFundModelItemType {
        return .mutualFund
    }
}

class MutualFundTypeItem {
    var type: MutualFundModelItemType {
        return .mutualFundType
    }
}

class MutualFundYieldItem {
    var type: MutualFundModelItemType {
        return .mutualFundYield
    }
}

class MutualFundManagedFundsItem {
    var type: MutualFundModelItemType {
        return .mutualFundManagedFunds
    }
}

class MutualFundMinimumPurchaseItem {
    var type: MutualFundModelItemType {
        return .mutualFundMinimumPurchase
    }
}

class MutualFundTimePeriodItem {
    var type: MutualFundModelItemType {
        return .mutualFundTimePeriod
    }
}

class MutualFundRiskLevelItem {
    var type: MutualFundModelItemType {
        return .mutualFundRiskLevel
    }
}

class MutualFundLaunchingDateItem {
    var type: MutualFundModelItemType {
        return .mutualFundLaunchingDate
    }
}

class MutualFundActionItem {
    var type: MutualFundModelItemType {
        return .mutualFundAction
    }
}

struct MutualFund {
    let image: String
    let name: String
}

struct MutualFundType {
    let type: String
}

struct MutualFundYield {
    let yield: String
}

struct MutualFundManagedFunds {
    let managedFunds: String
}

struct MutualFundMinimumPurchase {
    let minimumPurchase: String
}

struct MutualFundTimePeriod {
    let timePeriod: String
}

struct MutualFundRiskLevel {
    let riskLevel: String
}

struct MutualFundLaunchingDate {
    let launchingDate: String
}

class HomeViewController: UIViewController {
    @IBOutlet weak var investmentSegmentedControl: UISegmentedControl!
    @IBOutlet weak var chartView: ChartView!
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mutualFundCollectionView: UICollectionView!
    
    var items: [MutualFundModelItem] = [
        //MutualFundModelItem(type: .comparePercentage),
        MutualFundModelItem(type: .mutualFund),
        MutualFundModelItem(type: .mutualFundType),
        MutualFundModelItem(type: .mutualFundYield),
        MutualFundModelItem(type: .mutualFundManagedFunds),
        MutualFundModelItem(type: .mutualFundMinimumPurchase),
        MutualFundModelItem(type: .mutualFundTimePeriod),
        MutualFundModelItem(type: .mutualFundRiskLevel),
        MutualFundModelItem(type: .mutualFundLaunchingDate),
        MutualFundModelItem(type: .mutualFundAction)
    ]
    
    private var investmentProductDetail: [InvestmentProductDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchInvestmentProducts()
    }
    
    //MARK: - Setup
    private func setupView() {
        title = "Perbandingan"
        mutualFundCollectionView.register(UINib(nibName: "ComparePercentageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ComparePercentageCollectionViewCell")
        mutualFundCollectionView.register(UINib(nibName: "MutualFundCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MutualFundCollectionViewCell")
        mutualFundCollectionView.register(UINib(nibName: "ActionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ActionCollectionViewCell")
        mutualFundCollectionView.delegate = self
        mutualFundCollectionView.dataSource = self
    }
    
    //MARK: - Private
    private func fetchInvestmentProducts() {
        guard let url = URL(string: "https://ae1cdb19-2532-46fa-9b8f-cce01702bb1e.mock.pstmn.io/takehometest/apps/compare/detail?productCodes=K%20I002MMCDANCAS00&productCodes=TP002EQCEQTCRS00&productCodes=NI002EQCDANSIE00") else {
            return
        }
        
        //Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(InvestmentProduct.self, from: data)
                    self.investmentProductDetail = response.data
                   
                    DispatchQueue.main.async {
                        self.mutualFundCollectionView.reloadData()
                    }
                    self.fetchChartData()
                } catch let error {
                    print("error.localizedDescription: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func fetchChartData() {
        guard let url = URL(string: "https://ae1cdb19-2532-46fa-9b8f-cce01702bb1e.mock.pstmn.io/takehometest/apps/compare/chart?productCodes=KI%20002MMCDANCAS00&productCodes=TP002EQCEQTCRS00&productCodes=NI002EQCDANSIE00") else {
            return
        }
        
        //Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                do {
                    let response = try JSONDecoder().decode(ChartData.self, from: data)
                    for item in self.investmentProductDetail {
                        //print("item.details.code: \(item.details.code)")
                        print("item.code: \(item.code)")
                        guard let responseData = response.data["\(item.code)"] else {return}
                        print("responseData: \(responseData)")
                        print("responseData.data: \(responseData.data)")
                        for item2 in responseData.data {
                            print("item2: \(item2)")
                        }
                    }
                } catch let error {
                    print("error.localizedDescription: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    //MARK: - Button Action
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch investmentSegmentedControl.selectedSegmentIndex {
        case 0:
            print("Imbal Hasil")
        case 1:
            print("Dana Kelolaan")
        default:
            break
        }
    }
    
    @IBAction func timeIndexChanged(_ sender: UISegmentedControl) {
        let numSegments = (sender.selectedSegmentIndex + 1) * 4
        
        var dataPoints = [Double]()
        
        for _ in 0..<numSegments {
            dataPoints.append(Double.random(in: 20.0...100.0))
        }
        
        chartView.setData(dataPoints)
        
        switch timeSegmentedControl.selectedSegmentIndex {
        case 0:
            print("1W")
        case 1:
            print("1M")
        case 2:
            print("1Y")
        case 3:
            print("3Y")
        case 4:
            print("5Y")
        case 5:
            print("10Y")
        case 6:
            print("All")
        default:
            break
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return investmentProductDetail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.section]
        
        switch item.type {
        case .comparePercentage:
            guard indexPath.row < investmentProductDetail.count, let cell: ComparePercentageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComparePercentageCollectionViewCell", for: indexPath) as? ComparePercentageCollectionViewCell else {
                return UICollectionViewCell()
            }
            if indexPath.row != investmentProductDetail.count - 1 {
                cell.descriptionLabel.text = "10%"
            }
            else {
                cell.descriptionLabel.text = "10% (20 Jan 2020)"
            }
            return cell
        case .mutualFund:
            guard indexPath.row < investmentProductDetail.count, let cell: MutualFundCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MutualFundCollectionViewCell", for: indexPath) as? MutualFundCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if indexPath.row == 0 {
                cell.cardView.backgroundColor = UIColor(red: 226 / 256, green: 235 / 256, blue: 221 / 256, alpha: 1)
            }
            else if indexPath.row == 1 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 219 / 256, blue: 235 / 256, alpha: 1)
            }
            else if indexPath.row == 2 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 232 / 256, blue: 238 / 256, alpha: 1)
            }
            
            cell.backgroundColor = .blue
            cell.cellTitleLabel.text = ""
            cell.mutualFundImageView.isHidden = false
            
            let url = URL(string: investmentProductDetail[indexPath.row].details.im_avatar)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.mutualFundImageView.image = UIImage(data: data!)
                }
            }
            
            cell.mutualFundTitleLabel.text = investmentProductDetail[indexPath.row].name
            return cell
        case .mutualFundType:
            guard indexPath.row < investmentProductDetail.count, let cell: MutualFundCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MutualFundCollectionViewCell", for: indexPath) as? MutualFundCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if indexPath.row == 0 {
                cell.cardView.backgroundColor = UIColor(red: 226 / 256, green: 235 / 256, blue: 221 / 256, alpha: 1)
            }
            else if indexPath.row == 1 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 219 / 256, blue: 235 / 256, alpha: 1)
            }
            else if indexPath.row == 2 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 232 / 256, blue: 238 / 256, alpha: 1)
            }
            
            if indexPath.row == 0 {
                cell.cellTitleLabel.text = "Jenis reksa dana"
                cell.cellTitleLabel.isHidden = false
            }
            else {
                cell.cellTitleLabel.isHidden = true
            }
            cell.mutualFundImageView.isHidden = true
            //cell.mutualFundTitleLabel.text = "Pasar Uang"
            cell.mutualFundTitleLabel.text = investmentProductDetail[indexPath.row].details.type
            return cell
        case .mutualFundYield:
            guard indexPath.row < investmentProductDetail.count, let cell: MutualFundCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MutualFundCollectionViewCell", for: indexPath) as? MutualFundCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if indexPath.row == 0 {
                cell.cardView.backgroundColor = UIColor(red: 226 / 256, green: 235 / 256, blue: 221 / 256, alpha: 1)
            }
            else if indexPath.row == 1 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 219 / 256, blue: 235 / 256, alpha: 1)
            }
            else if indexPath.row == 2 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 232 / 256, blue: 238 / 256, alpha: 1)
            }
            
            if indexPath.row == 0 {
                cell.cellTitleLabel.text = "Imbal hasil"
                cell.cellTitleLabel.isHidden = false
            }
            else {
                cell.cellTitleLabel.isHidden = true
            }
            cell.mutualFundImageView.isHidden = true
            //cell.mutualFundTitleLabel.text = "5,50% / 5 thn"
            cell.mutualFundTitleLabel.text = "\(investmentProductDetail[indexPath.row].details.return_one_year)%/1 thn"
            return cell
        case .mutualFundManagedFunds:
            guard indexPath.row < investmentProductDetail.count, let cell: MutualFundCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MutualFundCollectionViewCell", for: indexPath) as? MutualFundCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if indexPath.row == 0 {
                cell.cardView.backgroundColor = UIColor(red: 226 / 256, green: 235 / 256, blue: 221 / 256, alpha: 1)
            }
            else if indexPath.row == 1 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 219 / 256, blue: 235 / 256, alpha: 1)
            }
            else if indexPath.row == 2 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 232 / 256, blue: 238 / 256, alpha: 1)
            }
            
            if indexPath.row == 0 {
                cell.cellTitleLabel.text = "Dana kelolaan"
                cell.cellTitleLabel.isHidden = false
            }
            else {
                cell.cellTitleLabel.isHidden = true
            }
            cell.mutualFundImageView.isHidden = true
            
            //AUM (Dana Kelolaan) is calculated from Total Unit * NAV
            let totalUnit = investmentProductDetail[indexPath.row].details.total_unit
            let nav = investmentProductDetail[indexPath.row].details.nav
            let aum = totalUnit * nav
            print("aum: \(aum)")
            
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.groupingSeparator = "."
            formatter.numberStyle = .decimal
            if let formattedAmount = formatter.string(from: aum as NSNumber) {
                //cell.mutualFundTitleLabel.text = "Rp \(aum)"
                cell.mutualFundTitleLabel.text = "Rp \(formattedAmount)"
            }
            
            //cell.mutualFundTitleLabel.text = "3,64 Miliar"
            return cell
        case .mutualFundMinimumPurchase:
            guard indexPath.row < investmentProductDetail.count, let cell: MutualFundCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MutualFundCollectionViewCell", for: indexPath) as? MutualFundCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if indexPath.row == 0 {
                cell.cardView.backgroundColor = UIColor(red: 226 / 256, green: 235 / 256, blue: 221 / 256, alpha: 1)
            }
            else if indexPath.row == 1 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 219 / 256, blue: 235 / 256, alpha: 1)
            }
            else if indexPath.row == 2 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 232 / 256, blue: 238 / 256, alpha: 1)
            }
            
            if indexPath.row == 0 {
                cell.cellTitleLabel.text = "Min. pembelian"
                cell.cellTitleLabel.isHidden = false
            }
            else {
                cell.cellTitleLabel.isHidden = true
            }
            cell.mutualFundImageView.isHidden = true
            //cell.mutualFundTitleLabel.text = "1 Juta"
            
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.groupingSeparator = "."
            formatter.numberStyle = .decimal
            if let formattedAmount = formatter.string(from: investmentProductDetail[indexPath.row].details.min_subscription as NSNumber) {
                cell.mutualFundTitleLabel.text = "Rp \(formattedAmount)"
            }
            return cell
        case .mutualFundTimePeriod:
            guard indexPath.row < investmentProductDetail.count, let cell: MutualFundCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MutualFundCollectionViewCell", for: indexPath) as? MutualFundCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if indexPath.row == 0 {
                cell.cardView.backgroundColor = UIColor(red: 226 / 256, green: 235 / 256, blue: 221 / 256, alpha: 1)
            }
            else if indexPath.row == 1 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 219 / 256, blue: 235 / 256, alpha: 1)
            }
            else if indexPath.row == 2 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 232 / 256, blue: 238 / 256, alpha: 1)
            }
            
            if indexPath.row == 0 {
                cell.cellTitleLabel.text = "Jangka waktu"
                cell.cellTitleLabel.isHidden = false
            }
            else {
                cell.cellTitleLabel.isHidden = true
            }
            cell.mutualFundImageView.isHidden = true
            cell.mutualFundTitleLabel.text = "1 Tahun"
            return cell
        case .mutualFundRiskLevel:
            guard indexPath.row < investmentProductDetail.count, let cell: MutualFundCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MutualFundCollectionViewCell", for: indexPath) as? MutualFundCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if indexPath.row == 0 {
                cell.cardView.backgroundColor = UIColor(red: 226 / 256, green: 235 / 256, blue: 221 / 256, alpha: 1)
            }
            else if indexPath.row == 1 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 219 / 256, blue: 235 / 256, alpha: 1)
            }
            else if indexPath.row == 2 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 232 / 256, blue: 238 / 256, alpha: 1)
            }
            
            if indexPath.row == 0 {
                cell.cellTitleLabel.text = "Tingkat risiko"
                cell.cellTitleLabel.isHidden = false
            }
            else {
                cell.cellTitleLabel.isHidden = true
            }
            cell.mutualFundImageView.isHidden = true
            
            //Tingkat risiko & Jangka waktu is obtained from Product Type condition:
            //❏ Money market fund is low risk and short term investment ❏ Equity fund is high risk and long term investment
            if investmentProductDetail[indexPath.row].details.type == "Saham" {
                cell.mutualFundTitleLabel.text = "Tinggi"
            }
            else if investmentProductDetail[indexPath.row].details.type == "Pasar Uang" {
                cell.mutualFundTitleLabel.text = "Rendah"
            }
            return cell
        case .mutualFundLaunchingDate:
            guard indexPath.row < investmentProductDetail.count, let cell: MutualFundCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MutualFundCollectionViewCell", for: indexPath) as? MutualFundCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if indexPath.row == 0 {
                cell.cardView.backgroundColor = UIColor(red: 226 / 256, green: 235 / 256, blue: 221 / 256, alpha: 1)
            }
            else if indexPath.row == 1 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 219 / 256, blue: 235 / 256, alpha: 1)
            }
            else if indexPath.row == 2 {
                cell.cardView.backgroundColor = UIColor(red: 224 / 256, green: 232 / 256, blue: 238 / 256, alpha: 1)
            }
            
            if indexPath.row == 0 {
                cell.cellTitleLabel.text = "Peluncuran"
                cell.cellTitleLabel.isHidden = false
            }
            else {
                cell.cellTitleLabel.isHidden = true
            }
            cell.mutualFundImageView.isHidden = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: investmentProductDetail[indexPath.row].details.inception_date)
            dateFormatter.dateFormat = "d MMMM yyyy"
            let resultString = dateFormatter.string(from: date!)
            print("resultString: \(resultString)")
            
            cell.mutualFundTitleLabel.text = resultString
            return cell
        case .mutualFundAction:
            guard indexPath.row < investmentProductDetail.count, let cell: ActionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCollectionViewCell", for: indexPath) as? ActionCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.detailButton.layer.borderWidth = 1.0
            cell.detailButton.layer.borderColor = UIColor.green.cgColor
            cell.cellDelegate = self
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGSize = UIScreen.main.bounds.size
        let width: CGFloat = screenSize.width / 3.5
        return CGSize(width: width, height: width * 1.7)
    }
}

extension HomeViewController: ActionCollectionViewCellDelegate {
    func detailButtonDidTapped(cell: ActionCollectionViewCell, didTappedThe button: UIButton?) {
        print("detailButtonDidTapped")
    }
    
    func buyButtonDidTapped(cell: ActionCollectionViewCell, didTappedThe button: UIButton?) {
        print("buyButtonDidTapped")
    }
}
