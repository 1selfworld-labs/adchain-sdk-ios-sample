import UIKit
import AdchainSDK

class NativeAdViewController: UIViewController {
    
    private let TAG = "NativeAdActivity"
    
    // Quiz Components
    private let quizTableView = UITableView()
    private let quizProgressIndicator = UIActivityIndicatorView(style: .large)
    private let quizEmptyLabel = UILabel()
    private let emptyBannerView = UIView()
    private let errorContainerView = UIView()
    private let retryButton = UIButton(type: .system)
    
    private var adchainQuiz: AdchainQuiz?
    private var quizEvents: [QuizEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Quiz Test"
        view.backgroundColor = .systemBackground
        
        setupUI()
        initializeViews()
        setupTableView()
        loadQuizEvents()
    }
    
    private func setupUI() {
        // Quiz table view
        quizTableView.translatesAutoresizingMaskIntoConstraints = false
        quizTableView.isHidden = true
        view.addSubview(quizTableView)
        
        // Progress indicator
        quizProgressIndicator.translatesAutoresizingMaskIntoConstraints = false
        quizProgressIndicator.isHidden = true
        view.addSubview(quizProgressIndicator)
        
        // Empty label
        quizEmptyLabel.text = "No quiz events available"
        quizEmptyLabel.textAlignment = .center
        quizEmptyLabel.translatesAutoresizingMaskIntoConstraints = false
        quizEmptyLabel.isHidden = true
        view.addSubview(quizEmptyLabel)
        
        // Empty banner view
        emptyBannerView.backgroundColor = .systemGray6
        emptyBannerView.layer.cornerRadius = 8
        emptyBannerView.translatesAutoresizingMaskIntoConstraints = false
        emptyBannerView.isHidden = true
        view.addSubview(emptyBannerView)
        
        let emptyLabel = UILabel()
        emptyLabel.text = "No quizzes available\nTap to open Adchain Hub"
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyBannerView.addSubview(emptyLabel)
        
        // Error container
        errorContainerView.translatesAutoresizingMaskIntoConstraints = false
        errorContainerView.isHidden = true
        view.addSubview(errorContainerView)
        
        let errorLabel = UILabel()
        errorLabel.text = "Failed to load quiz events"
        errorLabel.textAlignment = .center
        errorLabel.textColor = .systemRed
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorContainerView.addSubview(errorLabel)
        
        // Retry button
        retryButton.setTitle("Retry", for: .normal)
        retryButton.backgroundColor = .systemBlue
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.layer.cornerRadius = 6
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        errorContainerView.addSubview(retryButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Quiz table view
            quizTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            quizTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            quizTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            quizTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Progress indicator
            quizProgressIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quizProgressIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Empty label
            quizEmptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quizEmptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Empty banner
            emptyBannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyBannerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyBannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyBannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            emptyBannerView.heightAnchor.constraint(equalToConstant: 120),
            
            emptyLabel.centerXAnchor.constraint(equalTo: emptyBannerView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: emptyBannerView.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: emptyBannerView.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: emptyBannerView.trailingAnchor, constant: -16),
            
            // Error container
            errorContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            errorContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            errorLabel.topAnchor.constraint(equalTo: errorContainerView.topAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: errorContainerView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: errorContainerView.trailingAnchor),
            
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: errorContainerView.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 120),
            retryButton.heightAnchor.constraint(equalToConstant: 44),
            retryButton.bottomAnchor.constraint(equalTo: errorContainerView.bottomAnchor),
        ])
    }
    
    private func initializeViews() {
        // Set up tap gesture for empty banner
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(emptyBannerTapped))
        emptyBannerView.addGestureRecognizer(tapGesture)
        
        // Set up retry button
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
    
    @objc private func emptyBannerTapped() {
        print("\(TAG): Opening offerwall from empty banner")
        AdchainSdk.shared.openOfferwall(presentingViewController: self)
    }
    
    @objc private func retryButtonTapped() {
        print("\(TAG): Retrying quiz load")
        loadQuizEvents()
    }
    
    private func setupTableView() {
        quizTableView.delegate = self
        quizTableView.dataSource = self
        
        // Register quiz cell
        quizTableView.register(QuizTableViewCell.self, forCellReuseIdentifier: "QuizCell")
        
        quizTableView.separatorStyle = .none
        quizTableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    private func loadQuizEvents() {
        print("\(TAG): Loading quiz events...")
        showLoadingState()
        
        // EXACT Android AdchainQuiz initialization
        adchainQuiz = AdchainQuiz(unitId: "quiz_unit_id")
        
        // EXACT Android event listener pattern
        adchainQuiz?.setQuizEventsListener(self)
        
        // EXACT Android load pattern with callbacks
        adchainQuiz?.load(
            onSuccess: { [weak self] events in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if events.isEmpty {
                        print("\(self.TAG): No quiz events available")
                        self.showEmptyState()
                    } else {
                        print("\(self.TAG): Loaded \(events.count) quiz events")
                        self.showSuccessState(events: Array(events.prefix(3))) // Show max 3 items like Android
                    }
                }
            },
            onFailure: { [weak self] error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    print("\(self.TAG): Failed to load quiz events: \(error)")
                    self.showErrorState()
                }
            }
        )
    }
    
    // EXACT Android state management methods
    private func showLoadingState() {
        quizProgressIndicator.startAnimating()
        quizProgressIndicator.isHidden = false
        quizTableView.isHidden = true
        quizEmptyLabel.isHidden = true
        emptyBannerView.isHidden = true
        errorContainerView.isHidden = true
    }
    
    private func showSuccessState(events: [QuizEvent]) {
        quizProgressIndicator.stopAnimating()
        quizProgressIndicator.isHidden = true
        quizTableView.isHidden = false
        quizEmptyLabel.isHidden = true
        emptyBannerView.isHidden = true
        errorContainerView.isHidden = true
        
        self.quizEvents = events
        quizTableView.reloadData()
    }
    
    private func showEmptyState() {
        quizProgressIndicator.stopAnimating()
        quizProgressIndicator.isHidden = true
        quizTableView.isHidden = true
        quizEmptyLabel.isHidden = true
        emptyBannerView.isHidden = false
        errorContainerView.isHidden = true
    }
    
    private func showErrorState() {
        quizProgressIndicator.stopAnimating()
        quizProgressIndicator.isHidden = true
        quizTableView.isHidden = true
        quizEmptyLabel.isHidden = true
        emptyBannerView.isHidden = true
        errorContainerView.isHidden = false
    }
}

// MARK: - TableView DataSource & Delegate
extension NativeAdViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! QuizTableViewCell
        let quizEvent = quizEvents[indexPath.row]
        cell.configure(with: quizEvent, quiz: adchainQuiz!, viewController: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - AdchainQuizEventsListener
extension NativeAdViewController: AdchainQuizEventsListener {
    
    func onImpressed(_ quizEvent: QuizEvent) {
        print("\(TAG): Quiz impressed: \(quizEvent.id)")
    }
    
    func onClicked(_ quizEvent: QuizEvent) {
        print("\(TAG): Quiz clicked: \(quizEvent.id)")
    }
    
    func onQuizCompleted(_ quizEvent: QuizEvent, rewardAmount: Int) {
        print("\(TAG): Quiz completed: \(quizEvent.id), Reward: \(rewardAmount)")
        
        let alert = UIAlertController(title: "Quiz Completed!",
                                       message: "Reward: \(rewardAmount) points",
                                       preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}