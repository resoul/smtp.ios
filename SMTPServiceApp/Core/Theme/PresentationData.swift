import UIKit

struct AuthPresentationData {
    let backgroundColor: UIColor = UIColor.hex("F2F2F2")
    let formBackgroundColor: UIColor = .white
    let headlineColor: UIColor = UIColor.hex("071437")
    let textColor: UIColor = UIColor.hex("444444")
    let textLinkColor: UIColor = UIColor.hex("3f51b5")
}

struct PreviewIntroPresentationData {
    let backgroundColor: UIColor = UIColor.hex("343248")
    let textColor: UIColor = .white
}

struct MainPresentationData {
    let backgroundColor: UIColor = UIColor.hex("F2F2F2")
    let navigationBackgroundColor: UIColor = UIColor.hex("F9F9F9")
    let navigationTextColor: UIColor = UIColor.hex("071437")
    let mainBorderColor: CGColor = UIColor.hex("c2c1c8").cgColor
    let mainTextColor: UIColor = UIColor.hex("404040")
    let deleteIconColor: UIColor = .black
}

struct UserDomainPresentationData {
    let backgroundColor: UIColor = UIColor.hex("FFFFFF")
    let textColor: UIColor = .white
    let dnsContentBackgroundColor: UIColor = UIColor.hex("F2F2F2")
    let dnsHeadlineTextColor: UIColor = UIColor.hex("1f1f1f")
}
