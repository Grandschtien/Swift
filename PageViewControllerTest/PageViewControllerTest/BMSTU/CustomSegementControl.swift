//
//  CustomSegementControl.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 30.03.2022.
//

import UIKit

protocol CustomSegementControlDelegate: AnyObject {
    func changeToIndex(index: Int)
}

class CustomSegementControl: UIView {
    private var buttomTitles: [String]
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    
    var textColor: UIColor = .black
    var font: UIFont = .systemFont(ofSize: 14, weight: .bold)
    var selectorViewColor: UIColor = .red
    var selectorTextColor: UIColor = .red
    
    weak var delegate: CustomSegementControlDelegate?
    
    
    init(frame: CGRect, buttonTitles: [String]) {
        self.buttomTitles = buttonTitles
        super.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        self.buttomTitles = []
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    func setButtonTitles(buttonTitles: [String]) {
        self.buttomTitles = buttonTitles
        updateView()
    }
    
    private func configStack() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func configureSelectorView() {
        let selectorViewWidth = self.frame.width / CGFloat(buttons.count)
        let selectorViewFrame = CGRect(x: 0,
                                       y: 0,
                                       width: selectorViewWidth,
                                       height: self.frame.height)
        selectorView = UIView(frame: selectorViewFrame)
        selectorView.layer.cornerRadius = 8
        self.layer.cornerRadius = 8
        clipsToBounds = true
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }
    
    private func updateView() {
        createButtons()
        configureSelectorView()
        configStack()
    }
    
    private func createButtons() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttomTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = font
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    @objc
    private func buttonAction(sender: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width / CGFloat(buttomTitles.count) * CGFloat(buttonIndex)
                delegate?.changeToIndex(index: buttonIndex)
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }

}
