//
//  ViewController.swift
//  AWPinSecurity
//
//  Created by Anthony Williams on 8/20/16.
//
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {
    
    // Pin
    private var correctPin: [String] = []
    private var guessedPin: [String] = []
    
    // Customizations
    private var maxAttempts: Int?
    private var onSuccess: (() -> ())?
    
    // Colors
    private var primaryColor = UIColor.black
    private var secondaryColor = UIColor.white
    
    // Images
    private var defaultLogoImage = UIImage(named: "slack")
    private var defaultEmptyImage = UIImage(named: "EmptyCircle")
    private var defaultFilledImage = UIImage(named: "FilledCircle")
    
    // Pin Entry
    private var pinEntryView: UIView!
    private var circleImageView1: UIImageView!
    private var circleImageView2: UIImageView!
    private var circleImageView3: UIImageView!
    private var circleImageView4: UIImageView!
    
    var circleImages: [UIImageView] = []
    
    // Key Pad Buttons
    private var keyPadView: UIView!
    private var oneButton: UIButton!
    private var twoButton: UIButton!
    private var threeButton: UIButton!
    private var fourButton: UIButton!
    private var fiveButton: UIButton!
    private var sixButton: UIButton!
    private var sevenButton: UIButton!
    private var eightButton: UIButton!
    private var nineButton: UIButton!
    private var zeroButton: UIButton!
    private var deleteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setPin(pin: ["0", "1", "2", "3"])
//        setFilledImage(UIImage(named: "bobby")!)
//        setLogoImage(UIImage(named: "duy")!)
        setDefaultPrimaryColor(color: UIColor(red: 0/255, green: 189/255, blue: 190/255, alpha: 1))
        onCorrectPinEntered() {
            let alert = UIAlertController(title: "Success", message: "Pin is Correct", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDefaultPrimaryColor(color: UIColor) {
        primaryColor = color
    }
    
    func setDefaultSecondaryColor(color: UIColor) {
        secondaryColor = color
    }
    
    func setPin(pin: [String]) {
        correctPin = pin
    }
    
    func setLogoImage(image: UIImage) {
        defaultLogoImage = image
    }
    
    func setEmptyImage(image: UIImage) {
        defaultEmptyImage = image
    }
    
    func setFilledImage(image: UIImage) {
        defaultFilledImage = image
    }
    
    func onCorrectPinEntered(completion: () -> ()) {
        onSuccess = completion
    }
    
    func onMaxAttempts(attempts: Int, completion: () -> ()) {
        maxAttempts = attempts
    }

    // MARK: Creating Views
    
    private func configureView() {
        view.backgroundColor = primaryColor
        
        // Numbers
        setupKeyPad()
        
        // Circular Images
        setupCircles()
        
        // Logo
        setupKeyPadLogo()
    }
    
    private func setupKeyPadLogo() {
        let logoImage = UIImageView(frame: CGRect(x: 0, y: keyPadView.frame.minY-190, width: 120, height: 120))
        logoImage.center.x = view.center.x
        logoImage.image = defaultLogoImage
        logoImage.contentMode = .scaleAspectFit
        view.addSubview(logoImage)
    }
    
    private func setupCircles() {
        let circlePadding:CGFloat = 20.0
        let circleSize:CGFloat = 20.0
        
        pinEntryView = UIView(frame: CGRect(x: 0, y: keyPadView.frame.minY-50, width: (circlePadding*3)+(circleSize*4), height: circleSize))
        pinEntryView.center.x = view.center.x
        pinEntryView.backgroundColor = primaryColor
        view.addSubview(pinEntryView)
        
        circleImageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        circleImageView1.image = defaultEmptyImage
        circleImageView1.contentMode = .scaleAspectFill
        pinEntryView.addSubview(circleImageView1)
        
        circleImageView2 = UIImageView(frame: CGRect(x: circleImageView1.frame.maxX+circlePadding, y: 0, width: circleSize, height: circleSize))
        circleImageView2.image = defaultEmptyImage
        circleImageView2.contentMode = .scaleAspectFill
        pinEntryView.addSubview(circleImageView2)
        
        circleImageView3 = UIImageView(frame: CGRect(x: circleImageView2.frame.maxX+circlePadding, y: 0, width: circleSize, height: circleSize))
        circleImageView3.image = defaultEmptyImage
        circleImageView3.contentMode = .scaleAspectFill
        pinEntryView.addSubview(circleImageView3)
        
        circleImageView4 = UIImageView(frame: CGRect(x: circleImageView3.frame.maxX+circlePadding, y: 0, width: circleSize, height: circleSize))
        circleImageView4.image = defaultEmptyImage
        circleImageView4.contentMode = .scaleAspectFill
        pinEntryView.addSubview(circleImageView4)
        
        circleImages.append(circleImageView1)
        circleImages.append(circleImageView2)
        circleImages.append(circleImageView3)
        circleImages.append(circleImageView4)
    }
    
    private func setupKeyPad() {
        let keyPadding:CGFloat = 15.0
        let keySize:CGFloat = 75.0
        
        keyPadView = UIView(frame: CGRect(x: 0, y: 0, width: (keyPadding*2)+(keySize*3), height: (keyPadding*3)+(keySize*4)))
        keyPadView.center.x = view.center.x
        keyPadView.center.y = view.center.y+90
        keyPadView.backgroundColor = primaryColor
        view.addSubview(keyPadView)
        
        oneButton = UIButton(frame: CGRect(x: 0, y: 0, width: keySize, height: keySize))
        oneButton.setTitle("1", for: .normal)
        oneButton.addTarget(self, action: #selector(ViewController.keyPressed), for: .touchUpInside)
        oneButton.addTarget(self, action: #selector(ViewController.buttonHighlight), for: .touchDown)
        oneButton.backgroundColor = primaryColor
        oneButton.setTitleColor(secondaryColor, for: .normal)
        oneButton.titleLabel?.font = UIFont(name: "Helvetica-Light", size: 20)
        oneButton.layer.cornerRadius = oneButton.frame.size.height/2
        oneButton.layer.borderColor = secondaryColor.cgColor
        oneButton.layer.borderWidth = 1.0
        oneButton.layer.masksToBounds = true
        keyPadView.addSubview(oneButton)
        
        twoButton = UIButton(frame: CGRect(x: oneButton.frame.maxX+keyPadding, y: oneButton.frame.minY, width: keySize, height: keySize))
        twoButton.setTitle("2", for: .normal)
        twoButton.addTarget(self, action: #selector(ViewController.keyPressed), for: .touchUpInside)
        twoButton.addTarget(self, action: #selector(ViewController.buttonHighlight), for: .touchDown)
        twoButton.backgroundColor = primaryColor
        twoButton.setTitleColor(secondaryColor, for: .normal)
        twoButton.layer.cornerRadius = twoButton.frame.size.height/2
        twoButton.layer.borderColor = secondaryColor.cgColor
        twoButton.layer.borderWidth = 1.0
        twoButton.layer.masksToBounds = true
        keyPadView.addSubview(twoButton)
        
        threeButton = UIButton(frame: CGRect(x: twoButton.frame.maxX+keyPadding, y: oneButton.frame.minY, width: keySize, height: keySize))
        threeButton.setTitle("3", for: .normal)
        threeButton.addTarget(self, action: #selector(ViewController.keyPressed), for: .touchUpInside)
        threeButton.addTarget(self, action: #selector(ViewController.buttonHighlight), for: .touchDown)
        threeButton.backgroundColor = primaryColor
        threeButton.setTitleColor(secondaryColor, for: .normal)
        threeButton.layer.cornerRadius = threeButton.frame.size.height/2
        threeButton.layer.borderColor = secondaryColor.cgColor
        threeButton.layer.borderWidth = 1.0
        threeButton.layer.masksToBounds = true
        keyPadView.addSubview(threeButton)

        fourButton = UIButton(frame: CGRect(x: oneButton.frame.minX, y: oneButton.frame.maxY+keyPadding, width: keySize, height: keySize))
        fourButton.setTitle("4", for: .normal)
        fourButton.addTarget(self, action: #selector(ViewController.keyPressed), for: .touchUpInside)
        fourButton.addTarget(self, action: #selector(ViewController.buttonHighlight), for: .touchDown)
        fourButton.backgroundColor = primaryColor
        fourButton.setTitleColor(secondaryColor, for: .normal)
        fourButton.layer.cornerRadius = fourButton.frame.size.height/2
        fourButton.layer.borderColor = secondaryColor.cgColor
        fourButton.layer.borderWidth = 1.0
        fourButton.layer.masksToBounds = true
        keyPadView.addSubview(fourButton)
        
        fiveButton = UIButton(frame: CGRect(x: twoButton.frame.minX, y: twoButton.frame.maxY+keyPadding, width: keySize, height: keySize))
        fiveButton.setTitle("5", for: .normal)
        fiveButton.addTarget(self, action: #selector(ViewController.keyPressed), for: .touchUpInside)
        fiveButton.addTarget(self, action: #selector(ViewController.buttonHighlight), for: .touchDown)
        fiveButton.backgroundColor = primaryColor
        fiveButton.setTitleColor(secondaryColor, for: .normal)
        fiveButton.layer.cornerRadius = fiveButton.frame.size.height/2
        fiveButton.layer.borderColor = secondaryColor.cgColor
        fiveButton.layer.borderWidth = 1.0
        fiveButton.layer.masksToBounds = true
        keyPadView.addSubview(fiveButton)
        
        sixButton = UIButton(frame: CGRect(x: threeButton.frame.minX, y: threeButton.frame.maxY+keyPadding, width: keySize, height: keySize))
        sixButton.setTitle("6", for: .normal)
        sixButton.addTarget(self, action: #selector(ViewController.keyPressed), for: .touchUpInside)
        sixButton.addTarget(self, action: #selector(ViewController.buttonHighlight), for: .touchDown)
        sixButton.backgroundColor = primaryColor
        sixButton.setTitleColor(secondaryColor, for: .normal)
        sixButton.layer.cornerRadius = sixButton.frame.size.height/2
        sixButton.layer.borderColor = secondaryColor.cgColor
        sixButton.layer.borderWidth = 1.0
        sixButton.layer.masksToBounds = true
        keyPadView.addSubview(sixButton)
        
        sevenButton = UIButton(frame: CGRect(x: fourButton.frame.minX, y: fourButton.frame.maxY+keyPadding, width: keySize, height: keySize))
        sevenButton.setTitle("7", for: .normal)
        sevenButton.addTarget(self, action: #selector(ViewController.keyPressed), for: .touchUpInside)
        sevenButton.addTarget(self, action: #selector(ViewController.buttonHighlight), for: .touchDown)
        sevenButton.backgroundColor = primaryColor
        sevenButton.setTitleColor(secondaryColor, for: .normal)
        sevenButton.layer.cornerRadius = sevenButton.frame.size.height/2
        sevenButton.layer.borderColor = secondaryColor.cgColor
        sevenButton.layer.borderWidth = 1.0
        sevenButton.layer.masksToBounds = true
        keyPadView.addSubview(sevenButton)
        
        eightButton = UIButton(frame: CGRect(x: fiveButton.frame.minX, y: fiveButton.frame.maxY+keyPadding, width: keySize, height: keySize))
        eightButton.setTitle("8", for: .normal)
        eightButton.addTarget(self, action: #selector(ViewController.keyPressed), for: .touchUpInside)
        eightButton.addTarget(self, action: #selector(ViewController.buttonHighlight), for: .touchDown)
        eightButton.backgroundColor = primaryColor
        eightButton.setTitleColor(secondaryColor, for: .normal)
        eightButton.layer.cornerRadius = eightButton.frame.size.height/2
        eightButton.layer.borderColor = secondaryColor.cgColor
        eightButton.layer.borderWidth = 1.0
        eightButton.layer.masksToBounds = true
        keyPadView.addSubview(eightButton)
        
        nineButton = UIButton(frame: CGRect(x: sixButton.frame.minX, y: sixButton.frame.maxY+keyPadding, width: keySize, height: keySize))
        nineButton.setTitle("9", for: .normal)
        nineButton.addTarget(self, action: #selector(ViewController.keyPressed), for: .touchUpInside)
        nineButton.addTarget(self, action: #selector(ViewController.buttonHighlight), for: .touchDown)
        nineButton.backgroundColor = primaryColor
        nineButton.setTitleColor(secondaryColor, for: .normal)
        nineButton.layer.cornerRadius = nineButton.frame.size.height/2
        nineButton.layer.borderColor = secondaryColor.cgColor
        nineButton.layer.borderWidth = 1.0
        nineButton.layer.masksToBounds = true
        keyPadView.addSubview(nineButton)
        
        zeroButton = UIButton(frame: CGRect(x: eightButton.frame.minX, y: eightButton.frame.maxY+keyPadding, width: keySize, height: keySize))
        zeroButton.setTitle("0", for: .normal)
        zeroButton.addTarget(self, action: #selector(ViewController.keyPressed), for: .touchUpInside)
        zeroButton.addTarget(self, action: #selector(ViewController.buttonHighlight), for: .touchDown)
        zeroButton.backgroundColor = primaryColor
        zeroButton.setTitleColor(secondaryColor, for: .normal)
        zeroButton.layer.cornerRadius = zeroButton.frame.size.height/2
        zeroButton.layer.borderColor = secondaryColor.cgColor
        zeroButton.layer.borderWidth = 1.0
        zeroButton.layer.masksToBounds = true
        keyPadView.addSubview(zeroButton)
        
        deleteButton = UIButton(frame: CGRect(x: nineButton.frame.minX, y: nineButton.frame.maxY+keyPadding, width: keySize, height: keySize))
        deleteButton.setTitle("␡", for: .normal)
        deleteButton.addTarget(self, action: #selector(ViewController.keyPressed), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(ViewController.buttonHighlight), for: .touchDown)
        deleteButton.backgroundColor = primaryColor
        deleteButton.setTitleColor(secondaryColor, for: .normal)
        deleteButton.titleLabel?.font = UIFont(name: "Helvetica", size: 35)
        deleteButton.layer.cornerRadius = deleteButton.frame.size.height/2
        deleteButton.layer.masksToBounds = true
        keyPadView.addSubview(deleteButton)
    }
    
    private func createKeys() {
//        for var i in 0..<9 {
//            if i % 3 == 0 {
//                
//            }
//        }
    }
    
    // MARK: Keypad Action
    
    func keyPressed(sender: AnyObject) {
        let button = sender as! UIButton
        
        button.backgroundColor = primaryColor
        button.setTitleColor(secondaryColor, for: .normal)
        
        let text = (button.titleLabel?.text)! as String
        
        if text != "␡" {
            guessedPin.append(text)
            
            circleImages[guessedPin.count-1].image = defaultFilledImage
            
            if guessedPin.count == 4 {
                if self.pinIsCorrect() && onSuccess != nil{
                    print("pin is correct")
                    onSuccess!()
                } else {
                    print("pin is incorrect")
                    guessedPin = []
                    self.shakeOnIncorrect()
                }
            }
        } else {
            if guessedPin.count > 0 {
                circleImages[guessedPin.count-1].image = defaultEmptyImage
                guessedPin.removeLast()
            }
        }
    }
    
    func buttonHighlight(sender: AnyObject) {
        let button = sender as! UIButton
        
        button.backgroundColor = secondaryColor
        button.setTitleColor(primaryColor, for: .normal)
    }
    
    private func pinIsCorrect() -> Bool{
        if guessedPin == correctPin {
            return true
        }
        
        return false
    }
    
    // MARK: Animations
    
    private func shakeOnIncorrect() {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.07
        shakeAnimation.repeatCount = 2
        shakeAnimation.autoreverses = true
        
        shakeAnimation.setValue("shake", forKey: "animationID")
        shakeAnimation.delegate = self
        
        toggleButtons()
        
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: pinEntryView.center.x - 15.0, y: pinEntryView.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: pinEntryView.center.x + 15.0, y: pinEntryView.center.y))
        pinEntryView.layer.add(shakeAnimation, forKey: "position")
    }
    
    private func resetCircleImages() {
        for imageView in circleImages {
            imageView.image = defaultEmptyImage
        }
    }
    
    private func toggleButtons() {
        if oneButton.isEnabled {
            oneButton.isEnabled = false
            twoButton.isEnabled = false
            threeButton.isEnabled = false
            fourButton.isEnabled = false
            fiveButton.isEnabled = false
            sixButton.isEnabled = false
            sevenButton.isEnabled = false
            eightButton.isEnabled = false
            nineButton.isEnabled = false
            zeroButton.isEnabled = false
            deleteButton.isEnabled = false
        } else {
            oneButton.isEnabled = true
            twoButton.isEnabled = true
            threeButton.isEnabled = true
            fourButton.isEnabled = true
            fiveButton.isEnabled = true
            sixButton.isEnabled = true
            sevenButton.isEnabled = true
            eightButton.isEnabled = true
            nineButton.isEnabled = true
            zeroButton.isEnabled = true
            deleteButton.isEnabled = true
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animationID: AnyObject = anim.value(forKey: "animationID") {
            if animationID as! String == "shake" {
                self.resetCircleImages()
                self.toggleButtons()
            }
        }
    }
}
