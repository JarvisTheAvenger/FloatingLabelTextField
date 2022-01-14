//
//  CustomTextField.swift
//  CustomFloatingLabel
//
//  Created by Rahul Umap on 14/01/22.
//

import UIKit

protocol CustomTextFieldDelegate: UITextFieldDelegate {}

@IBDesignable
class FloatingLabelTextField: UIView {
    @IBOutlet weak private var placeholderLabel: UILabel!
    @IBOutlet weak private var textfield: UITextField!
    @IBOutlet weak private var bottomSeparator: UIView!
    @IBOutlet weak private var contentView: UIView!
    
    weak var delegate: CustomTextFieldDelegate?
    
    private (set) var isActive = false {
        didSet {
            if isActive {
                self.placeholderLabel.textColor = .black
                self.bottomSeparator.backgroundColor = .black
            } else {
                self.placeholderLabel.textColor = .gray
                self.bottomSeparator.backgroundColor = .gray
            }
        }
    }
    
    //MARK: - Placeholder Related.
    @IBInspectable
    var placeholderText: String? {
        get { textfield.placeholder }
        set {
            textfield.placeholder = newValue
            placeholderLabel.text = newValue
        }
    }
    
    var placeholderLabelFont: UIFont {
        get { placeholderLabel.font }
        set { placeholderLabel.font = newValue }
    }
    
    //MARK: - TextField Related.
    @IBInspectable
    var text: String? {
        get { textfield.text }
        set {
            textfield.text = newValue
            textfield.accessibilityValue = newValue
            updatePlaceholderVisibility(textfield.text!)
        }
    }
    
    @IBInspectable
    var textColor: UIColor? {
        get { textfield.textColor }
        set { textfield.textColor = newValue }
    }
    
    var textFont: UIFont? {
        get { textfield.font }
        set { textfield.font = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FloatingLabelTextField", owner: self, options: nil)
        
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.placeholderLabel.isHidden = true
        self.textfield.delegate = self
    }
    
    private func updatePlaceholderVisibility(_ text: String) {
        self.placeholderLabel.isHidden = text.isEmpty
    }

}

//MARK: - UITextFieldDelegate (Relay delegate calls to the controller for further updates)
extension FloatingLabelTextField : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidEndEditing?(textField)
        isActive = false
        self.updatePlaceholderVisibility(textfield.text ?? "")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidBeginEditing?(textField)
        isActive = true
        self.updatePlaceholderVisibility(textfield.text ?? "")
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            isActive = !updatedText.isEmpty
            self.updatePlaceholderVisibility(updatedText)
        }
        
        return delegate?.textField?(textField,
                                    shouldChangeCharactersIn: range,
                                    replacementString: string) ?? true
    }
}

