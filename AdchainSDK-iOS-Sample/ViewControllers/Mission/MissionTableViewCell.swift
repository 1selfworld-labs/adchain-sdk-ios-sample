import UIKit
import AdchainSDK

class MissionTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let pointsLabel = UILabel()
    
    private var mission: Mission?
    private var missionSdk: AdchainMission?
    private weak var viewController: UIViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupGestures()
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // Container view with card styling
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 2
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Icon image view
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 8
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        // Title label
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Subtitle label
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)
        
        // Points label with purple background
        pointsLabel.font = .systemFont(ofSize: 14, weight: .bold)
        pointsLabel.textColor = .systemPurple
        pointsLabel.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.1)
        pointsLabel.layer.cornerRadius = 6
        pointsLabel.clipsToBounds = true
        pointsLabel.textAlignment = .center
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(pointsLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Icon image view
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 56),
            iconImageView.heightAnchor.constraint(equalToConstant: 56),
            
            // Title label
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: pointsLabel.leadingAnchor, constant: -8),
            
            // Subtitle label
            subtitleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: pointsLabel.leadingAnchor, constant: -8),
            
            // Points label
            pointsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            pointsLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            pointsLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            pointsLabel.heightAnchor.constraint(equalToConstant: 28),
        ])
        
        // Add padding to points label
        pointsLabel.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        guard let mission = mission,
              let missionSdk = missionSdk,
              let viewController = viewController else { return }
        
        // SDK의 통합 메서드 사용 - 클릭 추적 + WebView 열기
        missionSdk.clickMission(mission, from: viewController)
    }
    
    func configure(with mission: Mission, missionSdk: AdchainMission, viewController: UIViewController) {
        self.mission = mission
        self.missionSdk = missionSdk
        self.viewController = viewController
        
        // 직접 데이터 바인딩
        titleLabel.text = mission.title
        subtitleLabel.text = mission.description
        
        // 리워드 포인트 표시 (point는 String으로 제공됨, pts 중복 제거)
        pointsLabel.text = mission.point
        
        // 아이콘 이미지 로드 (image_url 필드 사용)
        if !mission.imageUrl.isEmpty {
            iconImageView.loadImage(from: mission.imageUrl)
        } else {
            // 기본 아이콘 설정
            iconImageView.image = UIImage(systemName: "star.fill")
            iconImageView.tintColor = .systemPurple
        }
        
        // 임프레션 이벤트 트래킹
        missionSdk.onMissionImpressed(mission)
    }
}

// MARK: - UIImageView Extension for Image Loading
extension UIImageView {
    func loadImage(from urlString: String) {
        // 이미지 캐시 키
        let cacheKey = urlString
        
        // 캐시에서 이미지 확인
        if let cachedImage = ImageCache.shared.getImage(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { 
            self.image = UIImage(systemName: "photo")
            return 
        }
        
        // 로딩 중 표시
        self.image = UIImage(systemName: "photo")
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.image = UIImage(systemName: "photo")
                }
                return
            }
            
            // 캐시에 저장
            ImageCache.shared.setImage(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}

// MARK: - Simple Image Cache
class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
