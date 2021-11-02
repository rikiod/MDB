//
//  SignUpVC.swift
//  MDB Social
//
//  Created by Rikio Dahlgren on 10/29/21.
//

import UIKit
import NotificationBannerSwift

class SignUpVC: UIViewController {

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 15

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome,"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let titleSecLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Let's make a new account"
        lbl.textColor = .secondaryText
        lbl.font = .systemFont(ofSize: 17, weight: .medium)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let fullnameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Full Name:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let emailTextField: AuthTextField = {
        let tf = AuthTextField(title: "Email:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let usernameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Username:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField: AuthTextField = {
        let tf = AuthTextField(title: "Password:")
        tf.textField.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let confirmPasswordTextField: AuthTextField = {
        let tf = AuthTextField(title: "Confirm Password:")
        tf.textField.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let cancelButton: UIButton = {
        let btn = UIButton()
        btn.layer.backgroundColor = UIColor.primary.cgColor
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.isUserInteractionEnabled = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let signupButton: LoadingButton = {
        let btn = LoadingButton()
        btn.layer.backgroundColor = UIColor.primary.cgColor
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.isUserInteractionEnabled = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 30, left: 40, bottom: 30, right: 40)
    
    private let buttonHeight: CGFloat = 44.0
    
    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        view.addSubview(titleLabel)
        view.addSubview(titleSecLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: contentEdgeInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: contentEdgeInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: contentEdgeInset.right),
            titleSecLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                               constant: 3),
            titleSecLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleSecLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        view.addSubview(stack)
        stack.addArrangedSubview(fullnameTextField)
        stack.addArrangedSubview(emailTextField)
        stack.addArrangedSubview(usernameTextField)
        stack.addArrangedSubview(passwordTextField)
        stack.addArrangedSubview(confirmPasswordTextField)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: titleSecLabel.bottomAnchor,
                                       constant: 30)
        ])
        
        view.addSubview(cancelButton)
        view.addSubview(signupButton)
        NSLayoutConstraint.activate([
            signupButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            signupButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
            signupButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            cancelButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -10),
            cancelButton.heightAnchor.constraint(equalToConstant: buttonHeight),

        ])
        
        cancelButton.layer.cornerRadius = buttonHeight / 2
        signupButton.layer.cornerRadius = buttonHeight / 2
        
        cancelButton.addTarget(self, action: #selector(didTapCancel(_:)), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(didTapSignUp(_:)), for: .touchUpInside)
    }
    
    @objc func didTapCancel(_ sender: UIButton) {
        let vc = SigninVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func didTapSignUp(_ sender: UIButton) {
        // vc =
        guard let email = emailTextField.text, email != "" else {
            showErrorBanner(withTitle: "Missing email", subtitle: "Please provide an email")
            return
        }
        guard let username = usernameTextField.text, username != "" else {
            showErrorBanner(withTitle: "Missing username", subtitle: "Please provide a username")
            return
        }
        guard let fullName = fullnameTextField.text, fullName != "" else {
            showErrorBanner(withTitle: "Missing name", subtitle: "Please provide your full name")
            return
        }
        guard let password = passwordTextField.text, password != "" else {
            showErrorBanner(withTitle: "Missing password", subtitle: "Please provide a password")
            return
        }
        guard let confirmPassword = confirmPasswordTextField.text, confirmPassword != "" else {
            showErrorBanner(withTitle: "Missing password", subtitle: "Please confirm your password")
            return
        }
        guard password == confirmPassword else {
            showErrorBanner(withTitle: "Passwords don't match", subtitle: "Please confirm your password")
            return
        }
        
        signupButton.showLoading()
        
        SOCAuthManager.shared.signUp(withFullname: fullName, withEmail: email, withUsername: username,
                                              withPassword: password) { [weak self] result in
            defer {
                self?.signupButton.hideLoading()
            }
            
            switch result {
            case .success:
                guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                window.rootViewController = vc
                let options: UIView.AnimationOptions = .transitionCrossDissolve
                let duration: TimeInterval = 0.3
                UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
            case .failure(let error):
                self?.showErrorBanner(withTitle: error.localizedDescription)
            }
        }
    }
    
    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: subtitle != nil ?
                                                    .systemFont(ofSize: 14, weight: .regular) : nil,
                                                style: .warning)
        
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                    cornerRadius: 10,
                    shadowColor: .primaryText,
                    shadowOpacity: 0.3,
                    shadowBlurRadius: 10)
    }
    
}


