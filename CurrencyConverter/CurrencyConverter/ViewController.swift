//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Deepika Jha on 20/10/21.
//

import UIKit
import SwiftyJSON
import PromiseKit
import Alamofire
import SwiftSpinner

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet  var fromCurrencyPicker:UIPickerView!
    
    @IBOutlet weak var inputCurrentText: UITextField!
    
    @IBOutlet weak var convertedCurrencyLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var conversionRateDisplay: UILabel!
    
    let baseUrl="https://free.currconv.com/api/v7/convert?q="
    let apiKey="3bcb9122d07b513e1dee"
   
    var pickerData = ["AED","AFN","ALL","AMD","ANG","AOA","ARS","AUD","AWG","AZN","BAM","BBD","BDT","BGN","BHD","BIF","BMD","BND","BOB","BRL","BSD","BTC","BTN","BWP","BYN","BYR","BZD","CAD","CDF","CHF","CLF","CLP","CNY","COP","CRC","CUC","CUP","CVE","CZK","DJF","DKK","DOP","DZD","EGP","ERN","ETB","EUR","FJD","FKP","GBP","GEL","GGP","GHS","GIP","GMD","GNF","GTQ","GYD","HKD","HNL","HRK","HTG","HUF","IDR","ILS","IMP","INR","IQD","IRR","ISK","JEP","JMD","JOD","KES","KGS","KHR","KMF","KPW","KRW","KWD","KYD","KZT","LAK","LBP","LKR","LRD","LSL","LVL","LYD","MAD","MDL","MGA","MKD","MMK","MNT","MOP","MRO","MUR","MVR","MWK","MXN","MYR","MZN","NAD","NGN","NIO","NOK","NPR","NZD","OMR","PAB","PEN","PGK","PHP","PKR","PLN","PYG","QAR","RON","RSD","RUB","RWF","SAR","SBD","SCR","SDG","SEK","SGD","SHP","SLL","SOS","SRD","STD","SVC","SYP","SZL","THB","TJS","TMT","TND","TOP","TRY","TTD","TWD","TZS","UAH","UGX","USD","UYU","UZS","VEF","VND","VUV","WST","XAF","XAG","XCD","XDR","XOF","XPF","YER","ZAR","ZMK","ZMW","ZWL"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fromCurrencyPicker.dataSource=self
        fromCurrencyPicker.delegate=self
        fromLabel.text="AED"
        toLabel.text="AED"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let fromCurrencyRow=pickerView.selectedRow(inComponent: 0)  // to get the selected row in picker1 i.e source currency
        let toCurrencyRow=pickerView.selectedRow(inComponent: 1)   // to get the selected row in picker2 i.e target currency
        let sourceCurrency=pickerData[fromCurrencyRow]
        let targetCurreny=pickerData[toCurrencyRow]
        fromLabel.text=sourceCurrency
        toLabel.text=targetCurreny
        
    }
    

    @IBAction func getConvertedCurrencyValue(_ sender: Any){
        if((fromLabel.text=="")||(toLabel.text=="")){
            errorLabel.text="Error: Either source currency or target currency not selected"
            return
        }
        errorLabel.text=""
        let amount1=inputCurrentText.text!
        if(amount1==""){
            errorLabel.text="Error: Invalid amount"
            return
        }
        errorLabel.text=""
        if let amount=Float(amount1){
            getTargetValue(amount)
        }else{
            errorLabel.text="Error: Invalid amount. Enter numeric value."
            return
        }
        errorLabel.text=""
        
    }
    
    
    func getTargetValue(_ amount:Float){
        let part1 = baseUrl + (fromLabel.text?.uppercased())! + "_" + (toLabel.text?.uppercased())! + "," + (toLabel.text?.uppercased())!
        let part2 = "_" + (fromLabel.text?.uppercased())! + "&compact=ultra&apiKey=" + apiKey
        let url = part1 + part2
        SwiftSpinner.show("Fetching Converted Value")
        AF.request(url).responseJSON { response in
//            print(response.data)
            if(response.error != nil){
                print(response.error)
                return
            }
            SwiftSpinner.hide(nil)
            let convertedValue=JSON(response.data!)
            if(convertedValue.isEmpty==true){
                self.errorLabel.text="Error: An issue occurred retry after some time"
                return
            }
            self.errorLabel.text=""
            let conversionKey=(self.fromLabel.text?.uppercased())!+"_"+(self.toLabel.text?.uppercased())!
            let conversionRate=convertedValue[conversionKey]
            let rateFloat=(conversionRate).float
            let convertedAmount=amount*rateFloat!
            
            self.conversionRateDisplay.text="Conversion Rate=\(conversionRate)"
            self.convertedCurrencyLabel.text=self.fromLabel.text!+"->"+self.toLabel.text!+" = "+"\(convertedAmount)"
        }
        
    }
    

  
}

