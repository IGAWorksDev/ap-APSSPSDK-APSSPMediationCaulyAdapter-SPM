//
//  CaulyMediationInterstitialAd.swift
//  MediationCauly
//
//  Created by Odin.송황호 on 5/29/24.
//

import UIKit

import APSSPSDK
import CaulySDK


final class CaulyMediationInterstitialAd: NSObject {
    
    weak var delegate: APSSPInterstitialAdapterDelegate?
    
    private let placementId: String
    
    private var interstitialAd: CaulyInterstitialAd?
    
    private weak var parentViewController: UIViewController?
    
    init(placementId: String, rootViewController: UIViewController?) {
        self.placementId = placementId
        self.parentViewController = rootViewController
    }
    
    public func present(from: UIViewController, completion: () -> Void) {
        if interstitialAd != nil {
            interstitialAd?.show()
            completion()
        } else {
            delegate?.interstitialShowFail(message: "Cauly Intersititial ShowFail")
        }
    }
    
    func load() {
        guard !placementId.isEmpty else {
            APLogger.error("Cauly Interstitial placementId is empty")
            delegate?.interstitialLoadFail(error: .nextMediation, errorMessage: "placementId is empty")
            return
        }
        
        guard let parentViewController else {
            APLogger.error("Cauly must set rootViewController")
            delegate?.interstitialLoadFail(error: .nextMediation, errorMessage: "rootViewController is nil")
            return
        }

        interstitialAd = CaulyInterstitialAd.init(parentViewController: parentViewController)
        interstitialAd?.delegate = self                //  전면 delegate 설정
        interstitialAd?.startRequest()                 //  전면광고 요청
    }
}


extension CaulyMediationInterstitialAd: CaulyInterstitialAdDelegate {
    
    /// 로드 성공. **본문이 비어 있으면 코어가 loadSuccess 를 받지 못해
    /// 광고를 받아오고도 10초 타임아웃 후 다음 미디에이션으로 넘어간다.**
    /// ObjC(CaulyAdapter.m:366) / AOS(CaulyAdapter.java:359) 와 동일하게 통보한다.
    func didReceive(_ interstitialAd: CaulyInterstitialAd!, isChargeableAd: Bool) {
        APLogger.debug("Cauly Interstitial loadSuccess")
        delegate?.interstitialLoadSuccess()
    }
    
    func didFail(toReceive interstitialAd: CaulyInterstitialAd!, errorCode: Int32, errorMsg: String!) {
        APLogger.error("Cauly Interstitial Error: \(errorMsg ?? "Cauly error")")
        delegate?.interstitialLoadFail(error: .nextMediation, errorMessage: errorMsg)
    }
    
    func didClose(_ interstitialAd: CaulyInterstitialAd!) {
        delegate?.interstitialClosed(message: "closed Cauly Interstitial")
    }
    
    func willShow(_ interstitialAd: CaulyInterstitialAd!) {
        delegate?.interstitialShowSuccess(message: "show Cauly Interstitial")
    }
}
