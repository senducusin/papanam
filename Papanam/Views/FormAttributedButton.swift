//
//  FormAttributedButton.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/1/21.
//

import UIKit

class FormAttributedButton: UIButton {
    // MARK: - Properties
    var titleWithQuestionMark: String? = nil {
        didSet {
            setup()
        }
    }
    
    // MARK: - Lifecycles
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setup(){
        if let title = titleWithQuestionMark, title.contains("?") {
            let attributedString = convertTitleToAttributedText()
            setAttributedTitle(attributedString, for: .normal)
        }else {
            setTitle(titleWithQuestionMark, for: .normal)
            setTitleColor(.themeWhiteText, for: .normal)
        }
    }
    
    private func convertTitleToAttributedText() -> NSAttributedString? {
        
        guard let labels = titleWithQuestionMark?.components(separatedBy: "? "),
              labels.count == 2 else {
            return nil
        }
        
        let regularLabel = labels[0]
        let boldLabel = labels[1]
        
        let attributes: [NSAttributedString.Key:Any] = [.foregroundColor: UIColor.themeWhiteText, .font:UIFont.systemFont(ofSize:15)]
        
        let attributedTitle = NSMutableAttributedString(string: "\(regularLabel)?", attributes: attributes)
        
        let boldAttributes: [NSAttributedString.Key:Any] = [.foregroundColor: UIColor.themeBlue, .font: UIFont.boldSystemFont(ofSize: 15)]
        
        attributedTitle.append(NSAttributedString(string: " \(boldLabel)", attributes: boldAttributes))
        
        return attributedTitle
    }
}

