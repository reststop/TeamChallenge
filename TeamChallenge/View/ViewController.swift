//
//  ViewController.swift
//  TeamChallenge
//
//  Created by carl on 4/3/22.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {

    //
    // MARK: - Base data elements for one team member
    //

    var member: Member! = nil
    var imageURLs: [String] = []

    // debug how many images loaded asynchronously
    @IBOutlet weak var labelValue: UILabel!

    // ornamental segment control
    @IBOutlet weak var segmentedControl: UISegmentedControl!


    //
    // MARK: - Components for images, buttons, etc.
    //

    @IBOutlet weak var overlayView: UIView!

    @IBOutlet weak var profileBackgroundView: UIView!

    @IBOutlet weak var photosView: UIView!
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    @IBOutlet weak var bioTextView: UITextView!
    

    @IBOutlet weak var mainAvatarView: UIImageView!

    @IBOutlet weak var topRightAvatarView: UIImageView!
    @IBOutlet weak var middleRightAvatarView: UIImageView!

    @IBOutlet weak var bottomLeftAvatarView: UIImageView!
    @IBOutlet weak var bottomMiddleAvatarView: UIImageView!
    @IBOutlet weak var bottomRightAvatarView: UIImageView!

    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!


    //
    // MARK: - copies of values used to set image origins
    //

    var spacing: CGFloat = 15
    var small: CGFloat = 0
    var large: CGFloat = 0
    var middle: CGFloat = 0
    var edge: CGFloat = 0


    // data for looping through imageViews and buttons
    var imageViews: [UIImageView] = []
    var closeButtons: [UIButton] = []
    var imagesLoaded: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // set title to "Settings" as per description
        self.navigationItem.title = "Settings"
        // select "Photos" in segment 2
        segmentedControl.selectedSegmentIndex = 2

        // initialize data from "team.json"
        // this also attempts to preload images to be used
        Team.initialize()

        // get a random team member
        self.member = Team.getMember()
        // get additional photo images
        self.imageURLs = Team.getImageURLs(self.member)

        // array of imageViews to load secondary images
        self.imageViews = [
            self.mainAvatarView,
            self.topRightAvatarView,
            self.middleRightAvatarView,
            self.bottomLeftAvatarView,
            self.bottomMiddleAvatarView,
            self.bottomRightAvatarView
        ]
        self.closeButtons = [
            self.button0,
            self.button1,
            self.button2,
            self.button3,
            self.button4,
            self.button5
        ]

        // now that we have the imageviews, start setting images
        self.labelValue.isHidden = true
        self.startImageLoad()

        //set initial measurements and locations of imageviews
        self.setupMeasurements()

        // set button tags
        self.setupButtons()

        // gesture recognizer
        self.longPressGesture.minimumPressDuration = 1.5

        // set bio text
        self.bioTextView.text = self.member.bio

    }

//    // try again if not yet loaded
//    override func viewWillAppear(_ animated: Bool) {
//        if self.imagesLoaded < 6 {
//            self.startImageLoad()
//        }
//    }

    // try once again if not yet loaded
    override func viewDidAppear(_ animated: Bool) {
        for imageView in imageViews {
            if imageView.image == nil {
                imageView.image = UIImage(systemName: "person.circle")
                imageView.tintColor = .systemTeal
            }
        }
        // most likely not very effective, however in testing
        // an image was filled in after setting the placeholder
        if self.imagesLoaded < 6 {
            self.startImageLoad()
        }
    }


    //
    // MARK: - Loading Images
    //

    private func startImageLoad() {
        self.imagesLoaded = 0
        TeamImage.getImage(remoteURL: self.member.avatar) { image in
            // fill in asynchronously
            DispatchQueue.main.async {
                self.mainAvatarView.image = image

                // debugging why some images are blank
                self.imagesLoaded += 1
                self.labelValue.text = "\(self.imagesLoaded)"
            }
        }
        // we can do the rest in a loop
        for i in 0...4 {
            TeamImage.getImage(remoteURL: self.imageURLs[i]) { [self] image in

                // fill these in asynchronously
                DispatchQueue.main.async {
                    self.imageViews[i + 1].image = image

                    // debugging why some images are blank
                    self.imagesLoaded += 1
                    self.labelValue.text = "\(self.imagesLoaded)"
                }
            }
        }
    }


    //
    // MARK: - Buttons and ImageViews
    //

    private func setButtonOrigin(_ button: UIButton, _ imageView: UIImageView) {
        button.frame.origin = CGPoint(x: imageView.frame.origin.x + imageView.frame.width - 32 , y: imageView.frame.origin.y + imageView.frame.width - 32)
    }

    private func setupButtons() {
        for i in 0...self.closeButtons.count - 1 {
            let button = closeButtons[i]
            self.setButtonOrigin(button, imageViews[i])
            button.isHidden = true
            button.tag = i
        }
    }

    private func setupMeasurements() {
        // first origin is always 0,0 + spacing,spacing

        let spacing = self.spacing

        let floatWidth = self.view.frame.width
        let floatHeight = self.view.frame.height


        // get sizes needed to place images
        let finalWidth = floatWidth - (4 * spacing)
        let small = finalWidth / 3
        self.small = small
        let large = small + spacing + small
        self.large = large
        let middle = spacing + small + spacing
        self.middle = middle
        let edge = middle + small + spacing
        self.edge = edge


        // shift segmented control so it is centered
        let newX = ((floatWidth - self.segmentedControl.frame.width) / 2)
        self.segmentedControl.frame.origin = CGPoint(x: newX, y: self.segmentedControl.frame.origin.y)


        // set width of overlay view
        self.overlayView.frame.size = CGSize(width: floatWidth, height: self.overlayView.frame.height)

        // set width of grey view
        self.profileBackgroundView.frame.size = CGSize(width: floatWidth, height: self.profileBackgroundView.frame.height)

        // set width of profile view
        self.profileView.frame.size = CGSize(width: floatWidth, height: self.profileView.frame.height)


        // set height of overlayView
        self.overlayView.frame.size = CGSize(width: floatWidth, height: floatHeight - self.overlayView.frame.origin.y)


        // set size of photos gallary view
        self.photosView.frame = CGRect(x: 0, y: 0, width: floatWidth, height: floatWidth)

        // place all the images
        self.mainAvatarView.frame = CGRect(x: spacing, y: spacing, width: large, height: large)
        self.topRightAvatarView.frame = CGRect(x: edge, y: spacing, width: small, height: small)
        self.middleRightAvatarView.frame = CGRect(x: edge, y: middle, width: small, height: small)
        self.bottomLeftAvatarView.frame = CGRect(x: spacing, y: edge, width: small, height: small)
        self.bottomMiddleAvatarView.frame = CGRect(x: middle, y: edge, width: small, height: small)
        self.bottomRightAvatarView.frame = CGRect(x: edge, y: edge, width: small, height: small)


        // set positions on profile view
        let newProfileY = self.photosView.frame.height
        self.profileView.frame.origin = CGPoint(x: 0, y: newProfileY)
        self.infoLabel.frame.origin = CGPoint(x: spacing, y: self.infoLabel.frame.origin.y)
        self.countLabel.frame.origin = CGPoint(x: (floatWidth - (spacing + self.countLabel.frame.width)), y: self.infoLabel.frame.origin.y)

        // set position of bio textView
        let newBioY = newProfileY + self.profileView.frame.height + spacing
        self.bioTextView.frame.origin = CGPoint(x: spacing, y: newBioY)
        let newBioW = floatWidth - (2 * spacing)
        self.bioTextView.frame.size = CGSize(width: newBioW, height: self.bioTextView.frame.height)


    }


    //
    // MARK: - Close buttons and long press gesture
    //

    private var longPressState: Bool = false

    @IBAction func markButtonAction(_ sender: UIButton) {
        debugPrint("Button Pressed: \(sender.tag)")
        if sender.tag < 0 || sender.tag > imageViews.count {
            return
        }

        // use tag to identify corresponding image
        let imageView = imageViews[sender.tag]
        // make the image and button disappear (hidden)
        imageView.isHidden = true
        sender.isHidden = true

        // based on which image is removed
        // move the images on the right as appropriate
        switch sender.tag {
        case 0:
            // move images 1 & 2
            imageViews[1].frame.origin = imageViews[0].frame.origin
            self.setButtonOrigin(closeButtons[1], imageViews[1])
            imageViews[2].frame.origin = CGPoint(x: imageViews[0].frame.origin.x, y: imageViews[2].frame.origin.y)
            self.setButtonOrigin(closeButtons[2], imageViews[2])
        case 1:
            // just hide the image
            break
        case 2:
            // just hide the image
            break
        case 3:
            // shift 4->3 and 5->4
            imageViews[5].frame.origin = imageViews[4].frame.origin
            self.setButtonOrigin(closeButtons[5], imageViews[5])
            imageViews[4].frame.origin = imageViews[3].frame.origin
            self.setButtonOrigin(closeButtons[4], imageViews[4])
        case 4:
            // shift 5->4, then 4->3
            imageViews[5].frame.origin = imageViews[4].frame.origin
            self.setButtonOrigin(closeButtons[5], imageViews[5])
            imageViews[4].frame.origin = imageViews[3].frame.origin
            self.setButtonOrigin(closeButtons[4], imageViews[4])
        case 5:
            // just hide the image
            break
        default:
            // nothing to do
            break
        }
        // attempt to redisplay to see if it cleans up
        // no change -- comment out
        // imageView.setNeedsDisplay()
        // self.photosView.setNeedsDisplay()
    }
    


    @IBAction func longPressGestureAction(_ sender: UILongPressGestureRecognizer) {

        if sender.state == .began {
            // toggle state of buttons
            let views = self.photosView.subviews
            for i in 0...views.count - 1 {
                let v = views[i]
                if v is UIButton {
                    if imageViews[v.tag].isHidden == false {
                        v.isHidden = self.longPressState
                    }
                }
            }
            self.longPressState = !self.longPressState
        }
    }


    //
    // MARK: - Save button, screenshot, sending email
    //
    
    @IBAction func saveButtonAction(_ sender: UIButton) {

        // take screenshot
        UIGraphicsBeginImageContextWithOptions(self.view.layer.frame.size, false, UIScreen.main.scale);
        guard let context = UIGraphicsGetCurrentContext() else {return }
        self.view.layer.render(in:context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        postEmail(image)
    }

    func returnEmailStringBase64EncodedImage(image:UIImage) -> String {
        let imgData:NSData = image.pngData()! as NSData;
        let dataString = imgData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return dataString
    }

    private func  postEmail(_ image: UIImage) {
        let mail:MFMailComposeViewController = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["carl@reststop.com", "obrand@ingenio.com"])
        mail.setSubject("Screenshot from Team Challenge")

        let imageString = returnEmailStringBase64EncodedImage(image: image)
        let emailBody = "<img src='data:image/png;base64,\(imageString)' width='\(image.size.width)' height='\(image.size.height)'>"

        mail.setMessageBody(emailBody, isHTML:true)

        if MFMailComposeViewController.canSendMail() {
            self.present(mail, animated: true, completion:nil)
        }
        else {
            showSendMailErrorAlert()
        }
    }

    func showSendMailErrorAlert() {
        // Create new Alert
        let alertView = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })

        //Add OK button to a dialog message
        alertView.addAction(ok)
        // Present Alert to
        self.present(alertView, animated: true, completion: nil)
    }

    
}

