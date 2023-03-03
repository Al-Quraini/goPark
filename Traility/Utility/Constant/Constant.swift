//
//  Constant.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/23/23.
//

import Foundation

enum ACTIVITIES {
    static let activitesDict : [UUID : String] =
    [
        "13A57703-BB1A-41A2-94B8-53B692EB7238".toUUID() : "astronomy",
        "7CE6E935-F839-4FEC-A63E-052B1DEF39D2".toUUID() : "biking",
        "071BA73C-1D3C-46D4-A53C-00D5602F7F0E".toUUID() : "boating",
        "A59947B7-3376-49B4-AD02-C0423E08C5F7".toUUID() : "camping",
        "BA316D0F-92AE-4E00-8C80-DBD605DC58C3".toUUID() : "caving",
        "B12FAAB9-713F-4B38-83E4-A273F5A43C77".toUUID() : "climbing",
        "09DF0950-D319-4557-A57E-04CD2F63FF42".toUUID() : "culture",
        "AE42B46C-E4B7-4889-A122-08FE180371AE".toUUID() : "fishing",
        "D72206E4-6CD1-4441-A355-F8F1827466B1".toUUID() : "flying",
        "3F3ABD16-2C52-4EAA-A1F6-4235DE5686F0".toUUID() : "golfing",
        "BFF8C027-7C8F-480B-A5F8-CD8CE490BFBA".toUUID() : "hiking",
        "8386EEAF-985F-4DE8-9037-CCF91975AC94".toUUID() : "hunting",
        "5FF5B286-E9C3-430E-B612-3380D8138600".toUUID() : "skiing",
        "0B685688-3405-4E2A-ABBA-E3069492EC50".toUUID() : "wildlife"
    ]
}

enum CREDIT {
    static let credit = CreditFooterCollectionViewCell.CreditData(title: "Data used in this app is provided by the National Parks Service. We are grateful for their valuable contributions to our project.", imageName: "nps", url: "www.google.com")
}

enum FEATURE {
    typealias Feature = FeatureCollectionViewCell.FeatureData
    static var featuers : [Feature] = [
       Feature(imageName: "deal1", title: "Locate nearby parks") ,
       Feature(imageName: "deal2", title: "Detailed information") ,
       Feature(imageName: "deal3", title: "Plan your trip") ,
    ]
}
