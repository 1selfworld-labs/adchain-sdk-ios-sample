import UIKit
import AdchainSDK

class QuizTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let pointsLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    private var quizEvent: QuizEvent?
    private var quiz: AdchainQuiz?
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
        containerView.layer.shadowRadius = 4
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
        
        // Description label
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 1
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)
        
        // Points label
        pointsLabel.font = .systemFont(ofSize: 12, weight: .bold)
        pointsLabel.textColor = .systemPurple
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(pointsLabel)
        
        // Arrow image view
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .systemPurple
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(arrowImageView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Icon image view
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 48),
            iconImageView.heightAnchor.constraint(equalToConstant: 48),
            
            // Title label
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: pointsLabel.leadingAnchor, constant: -8),
            
            // Description label
            descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: arrowImageView.leadingAnchor, constant: -8),
            
            // Points label
            pointsLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            pointsLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            // Arrow image view
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        guard let quizEvent = quizEvent,
              let quiz = quiz,
              let viewController = viewController else { return }
        
        // SDK의 통합 메서드 사용 - 클릭 추적 + WebView 열기
        quiz.clickQuiz(quizEvent, from: viewController)
    }
    
    func configure(with quizEvent: QuizEvent, quiz: AdchainQuiz, viewController: UIViewController) {
        self.quizEvent = quizEvent
        self.quiz = quiz
        self.viewController = viewController
        
        // 직접 데이터 바인딩
        titleLabel.text = quizEvent.title
        descriptionLabel.text = quizEvent.description
        
        // 리워드 포인트 표시 (point는 String으로 제공됨, pts 중복 제거)
        pointsLabel.text = quizEvent.point
        
        // 아이콘 이미지 로드 (image_url 필드 사용)
        if !quizEvent.imageUrl.isEmpty {
            iconImageView.loadImage(from: quizEvent.imageUrl)
        } else {
            // 기본 아이콘 설정
            iconImageView.image = UIImage(systemName: "questionmark.circle.fill")
            iconImageView.tintColor = .systemPurple
        }
        
        // 화살표 아이콘은 유지
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .systemPurple
        
        // 임프레션 이벤트는 리스너를 통해 처리됨
        // SDK가 자동으로 리스너의 onImpressed를 호출함
    }
}
