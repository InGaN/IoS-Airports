//
//  CountryCollectionViewController.swift
//  Airports
//
//  Created by Kevin van der Vleuten on 29/09/15.
//  Copyright © 2015 Kevin van der Vleuten. All rights reserved.
//

import UIKit

class CountryCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "CountryCell"
    private let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    //var cellColor = true
    var countryCodes = [String]();
    
    var countries: [[String]] = [
        ["LK_Sri_Lanka", "AZ_Azerbaijan", "PH_Philippines", "AM_Armenia", "CN_Republic_of_China", "MN_Mongolia", "IO_British_Indian_Ocean_Territory", "HK_Hong_Kong", "IN_India", "JP_Japan", "KG_Kyrgyzstan", "KP_North_Korea", "KR_South_Korea", "KZ_Kazakhstan", "LA_Laos", "MM_Myanmar", "MV_Maldives",
         "NP_Nepal", "TW_Taiwan_Republic_of_China", "RU_Russia", "SG_Singapore", "TH_Thailand", "TJ_Tajikistan", "TM_Turkmenistan", "UY_Uruguay", "KH_Cambodia", "BD_Bangladesh", "MO_Macau", "BT_Bhutan", "GE_Georgia"], // Asia
        
        ["AT_Austria", "BA_Bosnia_and_Herzegovina", "BE_Belgium", "DE_Germany", "BG_Bulgaria", "IS_Iceland", "BY_Belarus", "CH_Switzerland", "CZ_Czech_Republic", "EE_Estonia", "GG_Guernsey", "JE_Jersey", "IM_Isle_of_Mann", "NL_Netherlands", "IE_Ireland", "FO_Faroe_Islands",
         "LU_Luxembourg", "NO_Norway", "SE_Sweden", "LV_Latvia", "LT_Lithuania", "FR_France", "GR_Greece", "HU_Hungary", "IT_Italy", "HR_Croatia", "SI_Slovenia", "MT_Malta", "MC_Monaco", "PT_Portugal", "RO_Romania",
         "LI_Liechtenstein", "MD_Moldova", "MK_Macedonia", "GI_Gibraltar", "RS_Serbia", "ME_Montenegro", "SK_Slovakia", "UA_Ukraine", "SM_San_Marino", "ES_Spain.png", "AX_Aland_Islands", "DK_Denmark", "FI_Finland", "GB_United_Kingdom", "PL_Poland", "CH_Switzerland"], // Europe
        
        ["AD_Andorra", "AL_Albania", "AO_Angola", "GA_Gabon", "SD_Sudan", "KE_Kenya", "CV_Cape_Verde", "BW_Botswana", "LR_Liberia", "CD_Democratic_Republic_of_the_Congo", "CG_Republic_of_the_Congo", "DZ_Algeria", "BJ_Benin", "BF_Burkina_Faso", "GH_Ghana", "NG_Nigeria", "NE_Niger",
         "TN_Tunisia", "TG_Togo", "ER_Eritrea", "ET_Ethiopia", "ZA_South_Africa", "SZ_Swaziland", "CF_Central_African_Republic", "GQ_Equatorial_Guinea", "SH_Saint_Helena", "CM_Cameroon", "ZM_Zambia", "KM_Comoros", "YT_Mayotte", "RE_Reunion", "ST_Sao_Tome_and_Principe",
         "TF_French_Southern_and_Antarctic_Lands", "SC_Seychelles", "ZW_Zimbabwe", "MW_Malawi", "LS_Lesotho", "NA_Namibia", "ML_Mali", "GM_The_Gambia", "SL_Sierra_Leone", "GW_Guinea-Bissau", "MU_Mauritius", "MA_Morocco", "EH_Western_Sahara", "SN_Senegal", "TZ_Tanzania",
         "GN_Guinea", "BI_Burundi", "SO_Somalia", "DJ_Djibouti", "LY_Libya", "RW_Rwanda", "UG_Uganda", "VA_Vatican_city_Holy_See.png", "MG_Madagascar", "MR_Mauritania", "MZ_Mozambique", "SS_South_Sudan", "TD_Chad"], // Africa
        
        ["NR_Nauru", "AU_Australia", "FJ_Fiji", "FM_Federated_States_of_Micronesia", "GU_Guam", "ID_Indonesia", "TL_East_Timor", "MY_Malaysia", "CK_Cook_Islands", "TO_Tonga", "KI_Kiribati", "TV_Tuvalu", "NU_Niue", "WF_Wallis_and_Futuna", "WS_Samoa", "PF_French_Polynesia",
         "VU_Vanuatu", "NC_New_Caledonia", "NZ_New_Zealand", "UM_United_States_Outlying_Islands", "BN_Brunei", "CC_Cocos_Keeling_Islands", "CX_Christmas_Island", "NF_Norfolk_Island", "MH_Marshall_Islands", "MP_Northern_Mariana_Islands", "PG_Papua_New_Guinea", "PW_Palau", "SB_Solomon_Islands"], // Oceania
        
        ["US_United_States", "GL_Greenland", "BM_Bermuda", "BS_Bahamas", "BR_Brazil", "CA_Canada", "CU_Cuba", "DO_Dominican_Republic", "GT_Guatemala", "HN_Honduras", "HT_Haiti", "JM_Jamaica", "PM_Saint-Pierre_and_Miquelon", "TC_Turks_and_Caicos_Islands", "CR_Costa_Rica", "NI_Nicaragua",
         "PA_Panama", "SV_El_Salvador", "KY_Cayman_Islands", "AG_Antigua_and_Barbuda", "BB_Barbados", "DM_Dominica", "GP_Guadeloupe", "MQ_Martinique", "MF_Saint-Martin", "BL_Saint_Barthelemy", "VI_United_States_Virgin_Islands", "KN_Saint_Kitts_and_Nevis", "LC_Saint_Lucia", "SX_Saint-Martin", "AI_Anguilla", "MS_Montserrat",
         "VG_British_Virgin_Islands", "VC_Saint_Vincent_and_the_Grenadines", "AS_American_Samoa", "MX_Mexico", "PR_Puerto_Rico"], // North America
        
        ["AR_Argentina", "BO_Bolivia", "BZ_Belize", "CL_Chile", "EC_Ecuador", "FK_Falkland_Islands", "GF_French_Guiana", "GY_Guyana", "SR_Suriname", "GD_Grenada", "PE_Peru", "PY_Paraguay", "UY_Uruguay", "AW_Aruba", "BQ_Bonaire", "CW_Curacao", "TT_Trinidad_and_Tobago", "CO_Colombia", "VE_Venezuela"], // South America
        
        ["AE_United_Arab_Emirates", "AF_Afghanistan", "OM_Oman", "CY_Cyprus", "EG_Egypt", "IL_Israel", "IQ_Iraq", "IR_Iran", "JO_Jordan", "KW_Kuwait", "LB_Lebanon", "PS_Palestine", "TR_Turkey", "BH_Bahrain", "SA_Saudi_Arabia", "PK_Pakistan", "SY_Syria", "QA_Qatar",
         "YE_Yemen"], // Middle East
        
        ["AQ"] // Antarctica        
        
    ]

    var continents: [String] = [
        "Asia", "Europe", "Africa", "Oceania", "North America", "South America", "Middle East", "Antarctica"
    ]
    
    var xIndex = 0;
    var yIndex = 0;
    
    var DepDes: Bool = false // 0 = Depart, 1 = Destination
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return continents.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countries[section].count //243
        // might want to help people out by putting this info online
    }
    
    
    override func viewDidLoad() {
        let adbh = AirportDatabaseHelper.sharedInstance
        self.countryCodes = adbh.getISOCountryCodes()!
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CountryCell", forIndexPath: indexPath) as! CountryCollectionViewCell
        cell.backgroundColor = UIColor.blackColor()
        //cellColor = !cellColor
    
        let index = indexPath.row
        yIndex = indexPath.section
        xIndex = index
        let country = countries[yIndex][index]
        

        let idx = country.startIndex.advancedBy(2)
        cell.flagImage.image = validCountryFlag(country)
        cell.countryName.text = country.substringToIndex(idx)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CountryCodeHeaderView", forIndexPath: indexPath) as! CountryCodeHeaderView
            let index = indexPath.section
            
            headerView.titleLabel.text = continents[index]
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }

    
    func validCountryFlag(code: String) -> UIImage {
        if (UIImage(named: code) == nil) {
            return UIImage(named: "unknown_flag")!
        }
        else {
            return UIImage(named: code )!
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue to \(segue.identifier)")
        
        if segue.identifier == "segueFlagsToTable" {
            if let destination = segue.destinationViewController as? AirportTableViewController {
                //self.tableView.indexPathForSelectedRow!.row
                let selectedCell = ((sender as? CountryCollectionViewCell)!)
                destination.countryCode = selectedCell.countryName.text
                destination.DepDes = self.DepDes
            }
        }
    }
}
