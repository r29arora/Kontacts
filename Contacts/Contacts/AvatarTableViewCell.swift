//
//  AvatarTableViewCell.swift
//  Contacts
//
//  Created by Zayaan Khatib on 2015-09-19.
//  Copyright © 2015 Rajul Arora. All rights reserved.
//

class AvatarTableViewCell:UITableViewCell {
    struct Constants {
        static let imageSize = CGSize(width: 40.0, height: 40.0)
    }
    
    lazy var avatarView: UIImageView = {
        let avatarView = UIImageView(frame: CGRect(origin: .zero, size: Constants.imageSize))
        avatarView.layer.cornerRadius = Constants.imageSize.height / 2.0
        avatarView.layer.borderWidth = 0.0
        avatarView.clipsToBounds = true
        avatarView.contentMode = UIViewContentMode.ScaleAspectFill
        return avatarView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.avatarView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UIView

extension AvatarTableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.avatarView.frame = CGRect(
            origin: CGPoint(x: 10.0, y: (self.contentView.frame.height - Constants.imageSize.height) / 2.0),
            size: Constants.imageSize
        )
        
        self.textLabel?.frame = CGRect(x: 60.0, y: 0.0, width: self.contentView.frame.width - 60.0, height: self.contentView.frame.height)
    }
}