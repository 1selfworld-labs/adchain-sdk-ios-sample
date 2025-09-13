import UIKit
import AdchainSDK

class OfferwallPromotionTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let pointButton = UIButton(type: .system)
    private let coinImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // Container view with gradient background
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.05
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Coin image
        coinImageView.image = UIImage(systemName: "bitcoinsign.circle.fill")
        coinImageView.tintColor = .systemYellow
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(coinImageView)
        
        // Title label
        titleLabel.text = "800만 포인트 받으러 가기"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Subtitle label
        subtitleLabel.text = "더 많은 포인트를 받을 수 있습니다"
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)
        
        // Arrow icon
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .systemGray3
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.heightAnchor.constraint(equalToConstant: 80),
            
            // Coin image
            coinImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            coinImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 40),
            coinImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Title label
            titleLabel.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -16),
            
            // Subtitle label
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Arrow icon
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        // Add gradient background
        addGradientBackground()
    }
    
    private func addGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemPurple.withAlphaComponent(0.05).cgColor,
            UIColor.systemPurple.withAlphaComponent(0.02).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = containerView.bounds
        gradientLayer.cornerRadius = 12
        
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update gradient frame when layout changes
        if let gradientLayer = containerView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = containerView.bounds
        }
    }
    
    func configure(with mission: Mission) {
        // 직접 데이터 바인딩
        titleLabel.text = mission.title.isEmpty ? "800만 포인트 받으러 가기" : mission.title
        subtitleLabel.text = mission.description.isEmpty ? "더 많은 포인트를 받을 수 있습니다" : mission.description
        
        // 아이콘 이미지 설정 (image_url 필드 사용)
        if !mission.imageUrl.isEmpty {
            // 커스텀 아이콘이 있으면 로드
            coinImageView.loadImage(from: mission.imageUrl)
        } else {
            // 기본 코인 아이콘 유지
            coinImageView.image = UIImage(systemName: "bitcoinsign.circle.fill")
            coinImageView.tintColor = .systemYellow
        }
    }
}
