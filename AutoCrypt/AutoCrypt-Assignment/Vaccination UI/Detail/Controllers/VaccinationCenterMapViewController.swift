//
//  VaccinationCenterMapViewController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import UIKit
import MapKit
import SnapKit

final class VaccinationCenterMapViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        self.view = VaccinationCenterMapMainView()
    }
}
