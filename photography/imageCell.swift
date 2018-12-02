
import UIKit

class ImageViewCell: UITableViewCell {
    
    var mainImageView : UIImageView  = {
        var imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // setup image layout to table view cell
        self.addSubview(mainImageView)
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
