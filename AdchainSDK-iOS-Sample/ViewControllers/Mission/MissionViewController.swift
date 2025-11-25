import UIKit
import AdchainSDK

class MissionViewController: UIViewController {
    
    private let TAG = "MissionActivity"
    
    // Progress UI - EXACT Android layout
    private let progressCard = UIView()
    private let checkBox1 = UIImageView()
    private let checkBox2 = UIImageView()
    private let checkBox3 = UIImageView()
    private let progressLine1 = UIView()
    private let progressLine2 = UIView()
    
    // Mission List UI
    private let missionTableView = UITableView()
    private let missionProgressIndicator = UIActivityIndicatorView(style: .large)
    private let missionEmptyLabel = UILabel()
    private let missionEmptyBanner = UIView()
    private let missionErrorContainer = UIView()
    private let retryButton = UIButton(type: .system)
    
    // Reward UI
    private let rewardContainer = UIView()
    private let claimRewardButton = UIButton(type: .system)
    
    // Mission SDK
    private var adchainMission: AdchainMission?
    private var missions: [Mission] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Mission System"
        view.backgroundColor = .systemBackground
        
        setupUI()
        initializeViews()
        setupTableView()
        loadMissionData()
    }
    
    private func setupUI() {
        // Progress card
        progressCard.backgroundColor = .secondarySystemBackground
        progressCard.layer.cornerRadius = 8
        progressCard.layer.shadowColor = UIColor.black.cgColor
        progressCard.layer.shadowOpacity = 0.1
        progressCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        progressCard.layer.shadowRadius = 4
        progressCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressCard)
        
        // Progress checkboxes
        [checkBox1, checkBox2, checkBox3].forEach { checkbox in
            checkbox.contentMode = .scaleAspectFit
            checkbox.translatesAutoresizingMaskIntoConstraints = false
            checkbox.image = UIImage(systemName: "circle")
            checkbox.tintColor = .systemGray3
            progressCard.addSubview(checkbox)
        }
        
        // Progress lines
        [progressLine1, progressLine2].forEach { line in
            line.backgroundColor = .systemGray5
            line.translatesAutoresizingMaskIntoConstraints = false
            progressCard.addSubview(line)
        }
        
        // Mission table view
        missionTableView.translatesAutoresizingMaskIntoConstraints = false
        missionTableView.isHidden = true
        view.addSubview(missionTableView)
        
        // Progress indicator
        missionProgressIndicator.translatesAutoresizingMaskIntoConstraints = false
        missionProgressIndicator.isHidden = true
        view.addSubview(missionProgressIndicator)
        
        // Empty label
        missionEmptyLabel.text = "No missions available"
        missionEmptyLabel.textAlignment = .center
        missionEmptyLabel.translatesAutoresizingMaskIntoConstraints = false
        missionEmptyLabel.isHidden = true
        view.addSubview(missionEmptyLabel)
        
        // Empty banner
        missionEmptyBanner.backgroundColor = .systemGray6
        missionEmptyBanner.layer.cornerRadius = 8
        missionEmptyBanner.translatesAutoresizingMaskIntoConstraints = false
        missionEmptyBanner.isHidden = true
        view.addSubview(missionEmptyBanner)
        
        let emptyLabel = UILabel()
        emptyLabel.text = "No missions available\nTap to open Adchain Hub"
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        missionEmptyBanner.addSubview(emptyLabel)
        
        // Error container
        missionErrorContainer.translatesAutoresizingMaskIntoConstraints = false
        missionErrorContainer.isHidden = true
        view.addSubview(missionErrorContainer)
        
        let errorLabel = UILabel()
        errorLabel.text = "Failed to load missions"
        errorLabel.textAlignment = .center
        errorLabel.textColor = .systemRed
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        missionErrorContainer.addSubview(errorLabel)
        
        // Retry button
        retryButton.setTitle("Retry", for: .normal)
        retryButton.backgroundColor = .systemBlue
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.layer.cornerRadius = 6
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        missionErrorContainer.addSubview(retryButton)
        
        // Reward container
        rewardContainer.translatesAutoresizingMaskIntoConstraints = false
        rewardContainer.isHidden = true
        view.addSubview(rewardContainer)
        
        let rewardLabel = UILabel()
        rewardLabel.text = "All missions completed!"
        rewardLabel.font = .systemFont(ofSize: 20, weight: .bold)
        rewardLabel.textAlignment = .center
        rewardLabel.translatesAutoresizingMaskIntoConstraints = false
        rewardContainer.addSubview(rewardLabel)
        
        // Claim reward button
        claimRewardButton.setTitle("Claim Reward", for: .normal)
        claimRewardButton.backgroundColor = .systemPurple
        claimRewardButton.setTitleColor(.white, for: .normal)
        claimRewardButton.layer.cornerRadius = 6
        claimRewardButton.translatesAutoresizingMaskIntoConstraints = false
        rewardContainer.addSubview(claimRewardButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Progress card
            progressCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            progressCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressCard.heightAnchor.constraint(equalToConstant: 80),
            
            // Checkboxes
            checkBox1.leadingAnchor.constraint(equalTo: progressCard.leadingAnchor, constant: 40),
            checkBox1.centerYAnchor.constraint(equalTo: progressCard.centerYAnchor),
            checkBox1.widthAnchor.constraint(equalToConstant: 30),
            checkBox1.heightAnchor.constraint(equalToConstant: 30),
            
            checkBox2.centerXAnchor.constraint(equalTo: progressCard.centerXAnchor),
            checkBox2.centerYAnchor.constraint(equalTo: progressCard.centerYAnchor),
            checkBox2.widthAnchor.constraint(equalToConstant: 30),
            checkBox2.heightAnchor.constraint(equalToConstant: 30),
            
            checkBox3.trailingAnchor.constraint(equalTo: progressCard.trailingAnchor, constant: -40),
            checkBox3.centerYAnchor.constraint(equalTo: progressCard.centerYAnchor),
            checkBox3.widthAnchor.constraint(equalToConstant: 30),
            checkBox3.heightAnchor.constraint(equalToConstant: 30),
            
            // Progress lines
            progressLine1.leadingAnchor.constraint(equalTo: checkBox1.trailingAnchor, constant: 4),
            progressLine1.trailingAnchor.constraint(equalTo: checkBox2.leadingAnchor, constant: -4),
            progressLine1.centerYAnchor.constraint(equalTo: progressCard.centerYAnchor),
            progressLine1.heightAnchor.constraint(equalToConstant: 2),
            
            progressLine2.leadingAnchor.constraint(equalTo: checkBox2.trailingAnchor, constant: 4),
            progressLine2.trailingAnchor.constraint(equalTo: checkBox3.leadingAnchor, constant: -4),
            progressLine2.centerYAnchor.constraint(equalTo: progressCard.centerYAnchor),
            progressLine2.heightAnchor.constraint(equalToConstant: 2),
            
            // Mission table view
            missionTableView.topAnchor.constraint(equalTo: progressCard.bottomAnchor, constant: 16),
            missionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            missionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            missionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Progress indicator
            missionProgressIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            missionProgressIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Empty label
            missionEmptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            missionEmptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Empty banner
            missionEmptyBanner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            missionEmptyBanner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            missionEmptyBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            missionEmptyBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            missionEmptyBanner.heightAnchor.constraint(equalToConstant: 120),
            
            emptyLabel.centerXAnchor.constraint(equalTo: missionEmptyBanner.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: missionEmptyBanner.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: missionEmptyBanner.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: missionEmptyBanner.trailingAnchor, constant: -16),
            
            // Error container
            missionErrorContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            missionErrorContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            missionErrorContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            missionErrorContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            errorLabel.topAnchor.constraint(equalTo: missionErrorContainer.topAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: missionErrorContainer.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: missionErrorContainer.trailingAnchor),
            
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: missionErrorContainer.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 120),
            retryButton.heightAnchor.constraint(equalToConstant: 44),
            retryButton.bottomAnchor.constraint(equalTo: missionErrorContainer.bottomAnchor),
            
            // Reward container
            rewardContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rewardContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rewardContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            rewardContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            rewardLabel.topAnchor.constraint(equalTo: rewardContainer.topAnchor),
            rewardLabel.leadingAnchor.constraint(equalTo: rewardContainer.leadingAnchor),
            rewardLabel.trailingAnchor.constraint(equalTo: rewardContainer.trailingAnchor),
            
            claimRewardButton.topAnchor.constraint(equalTo: rewardLabel.bottomAnchor, constant: 24),
            claimRewardButton.centerXAnchor.constraint(equalTo: rewardContainer.centerXAnchor),
            claimRewardButton.widthAnchor.constraint(equalToConstant: 200),
            claimRewardButton.heightAnchor.constraint(equalToConstant: 50),
            claimRewardButton.bottomAnchor.constraint(equalTo: rewardContainer.bottomAnchor),
        ])
    }
    
    private func initializeViews() {
        // Set up tap gesture for empty banner
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(emptyBannerTapped))
        missionEmptyBanner.addGestureRecognizer(tapGesture)
        
        // Set up buttons
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        claimRewardButton.addTarget(self, action: #selector(claimRewardButtonTapped), for: .touchUpInside)
    }
    
    @objc private func emptyBannerTapped() {
        print("\(TAG): Opening offerwall from empty banner")
        AdchainSdk.shared.openOfferwall(
            presentingViewController: self,
            placementId: "mission_empty_banner"
        )
    }
    
    @objc private func retryButtonTapped() {
        print("\(TAG): Retrying mission load")
        loadMissionData()
    }
    
    @objc private func claimRewardButtonTapped() {
        print("\(TAG): Claim reward button clicked")
        // SDK의 올바른 메소드 사용 - 리워드 버튼 클릭 처리
        adchainMission?.onRewardButtonClicked(from: self)
    }
    
    private func setupTableView() {
        missionTableView.delegate = self
        missionTableView.dataSource = self
        
        // Register mission cells
        missionTableView.register(MissionTableViewCell.self, forCellReuseIdentifier: "MissionCell")
        missionTableView.register(OfferwallPromotionTableViewCell.self, forCellReuseIdentifier: "OfferwallPromotionCell")
        
        missionTableView.separatorStyle = .none
        missionTableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    private func loadMissionData() {
        print("\(TAG): Loading mission data...")
        showLoadingState()

        // AdchainMission initialization (unitId removed in latest SDK)
        adchainMission = AdchainMission()

        // EXACT Android event listener pattern
        adchainMission?.eventsListener = self
        
        // EXACT Android load pattern with progress
        adchainMission?.load(
            onSuccess: { [weak self] missions, progress in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    // Update progress from server response
                    self.updateProgress(progress)
                    
                    // EXACT Android state logic
                    if progress.current >= progress.total && progress.total > 0 {
                        print("\(self.TAG): All missions completed (\(progress.current)/\(progress.total)), showing reward button")
                        self.showRewardState()
                    } else if missions.isEmpty {
                        print("\(self.TAG): No missions available")
                        self.showEmptyState()
                    } else {
                        print("\(self.TAG): Loaded \(missions.count) missions")
                        self.showSuccessState(missions: missions)
                    }
                }
            },
            onFailure: { [weak self] error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    print("\(self.TAG): Failed to load missions: \(error)")
                    self.showErrorState()
                }
            }
        )
    }
    
    // EXACT Android progress update algorithm
    private func updateProgress(_ progress: MissionProgress) {
        print("\(TAG): Updating progress: \(progress.current)/\(progress.total)")
        
        let count = progress.current
        
        // EXACT Android checkbox and line update logic
        switch count {
        case 0:
            // All empty
            checkBox1.image = UIImage(systemName: "circle")
            checkBox2.image = UIImage(systemName: "circle")
            checkBox3.image = UIImage(systemName: "circle")
            checkBox1.tintColor = .systemGray3
            checkBox2.tintColor = .systemGray3
            checkBox3.tintColor = .systemGray3
            progressLine1.backgroundColor = .systemGray5
            progressLine2.backgroundColor = .systemGray5
            
        case 1:
            // First completed
            checkBox1.image = UIImage(systemName: "checkmark.circle.fill")
            checkBox2.image = UIImage(systemName: "circle")
            checkBox3.image = UIImage(systemName: "circle")
            checkBox1.tintColor = .systemPurple
            checkBox2.tintColor = .systemGray3
            checkBox3.tintColor = .systemGray3
            progressLine1.backgroundColor = .systemGray5
            progressLine2.backgroundColor = .systemGray5
            
        case 2:
            // First and second completed
            checkBox1.image = UIImage(systemName: "checkmark.circle.fill")
            checkBox2.image = UIImage(systemName: "checkmark.circle.fill")
            checkBox3.image = UIImage(systemName: "circle")
            checkBox1.tintColor = .systemPurple
            checkBox2.tintColor = .systemPurple
            checkBox3.tintColor = .systemGray3
            progressLine1.backgroundColor = .systemPurple
            progressLine2.backgroundColor = .systemGray5
            
        case 3:
            // All completed
            checkBox1.image = UIImage(systemName: "checkmark.circle.fill")
            checkBox2.image = UIImage(systemName: "checkmark.circle.fill")
            checkBox3.image = UIImage(systemName: "checkmark.circle.fill")
            checkBox1.tintColor = .systemPurple
            checkBox2.tintColor = .systemPurple
            checkBox3.tintColor = .systemPurple
            progressLine1.backgroundColor = .systemPurple
            progressLine2.backgroundColor = .systemPurple
            
        default:
            // For any count > 3, show all completed
            checkBox1.image = UIImage(systemName: "checkmark.circle.fill")
            checkBox2.image = UIImage(systemName: "checkmark.circle.fill")
            checkBox3.image = UIImage(systemName: "checkmark.circle.fill")
            checkBox1.tintColor = .systemPurple
            checkBox2.tintColor = .systemPurple
            checkBox3.tintColor = .systemPurple
            progressLine1.backgroundColor = .systemPurple
            progressLine2.backgroundColor = .systemPurple
        }
    }
    
    // EXACT Android state management methods
    private func showLoadingState() {
        missionProgressIndicator.startAnimating()
        missionProgressIndicator.isHidden = false
        missionTableView.isHidden = true
        missionEmptyLabel.isHidden = true
        missionEmptyBanner.isHidden = true
        missionErrorContainer.isHidden = true
        rewardContainer.isHidden = true
    }
    
    private func showSuccessState(missions: [Mission]) {
        missionProgressIndicator.stopAnimating()
        missionProgressIndicator.isHidden = true
        missionTableView.isHidden = false
        missionEmptyLabel.isHidden = true
        missionEmptyBanner.isHidden = true
        missionErrorContainer.isHidden = true
        rewardContainer.isHidden = true
        
        self.missions = missions
        missionTableView.reloadData()
    }
    
    private func showEmptyState() {
        missionProgressIndicator.stopAnimating()
        missionProgressIndicator.isHidden = true
        missionTableView.isHidden = true
        missionEmptyLabel.isHidden = true
        missionEmptyBanner.isHidden = false
        missionErrorContainer.isHidden = true
        rewardContainer.isHidden = true
    }
    
    private func showErrorState() {
        missionProgressIndicator.stopAnimating()
        missionProgressIndicator.isHidden = true
        missionTableView.isHidden = true
        missionEmptyLabel.isHidden = true
        missionEmptyBanner.isHidden = true
        missionErrorContainer.isHidden = false
        rewardContainer.isHidden = true
    }
    
    private func showRewardState() {
        missionProgressIndicator.stopAnimating()
        missionProgressIndicator.isHidden = true
        missionTableView.isHidden = true
        missionEmptyLabel.isHidden = true
        missionEmptyBanner.isHidden = true
        missionErrorContainer.isHidden = true
        rewardContainer.isHidden = false
    }
}

// MARK: - TableView DataSource & Delegate
extension MissionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mission = missions[indexPath.row]
        
        // Check mission type
        if mission.type == .offerwallPromotion {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferwallPromotionCell", for: indexPath) as! OfferwallPromotionTableViewCell
            cell.configure(with: mission)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MissionCell", for: indexPath) as! MissionTableViewCell
            cell.configure(with: mission, missionSdk: adchainMission!, viewController: self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mission = missions[indexPath.row]
        if mission.type == .offerwallPromotion {
            return 96  // Slightly different height for promotion cell
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mission = missions[indexPath.row]

        // Handle offerwall promotion tap
        if mission.type == .offerwallPromotion {
            print("\(TAG): Offerwall promotion tapped")
            AdchainSdk.shared.openOfferwall(
                presentingViewController: self,
                placementId: "mission_offerwall_promotion"
            )
        }
        // Regular missions are handled by the cell itself
    }
}

// MARK: - AdchainMissionEventsListener
extension MissionViewController: AdchainMissionEventsListener {

    func onImpressed(_ mission: Mission) {
        print("\(TAG): Mission impressed: \(mission.id)")
    }

    func onClicked(_ mission: Mission) {
        print("\(TAG): Mission clicked: \(mission.id)")
        // SDK will handle opening the WebView internally
    }

    func onCompleted(_ mission: Mission) {
        print("\(TAG): Mission completed: \(mission.id)")
        // Refresh the list
        loadMissionData()
    }

    func onProgressed(_ mission: Mission) {
        print("\(TAG): Mission progressed: \(mission.id)")
        // Optionally refresh or update UI based on progress
    }

    func onRefreshed(unitId: String?) {
        print("\(TAG): Mission list refreshed, unitId: \(unitId ?? "nil")")
        // Refresh the mission list
        loadMissionData()
    }
}
