//
//  ImageShownViewController.swift
//  TextArt
//
//  Created by Macbook pro 2020 M1 on 15/10/22.
//

import UIKit
import Kingfisher

class ImageShownViewController: UIViewController {
    var imageDetailArrayF = [ImageDetails]()
    
    @IBOutlet weak var collectionViewForImage: UICollectionView!
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionViewForImage.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        collectionViewForImage.delegate = self
        collectionViewForImage.dataSource = self
        // Do any additional setup after loading the view.
    }
    
}
extension ImageShownViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDetailArrayF.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let mainViewWidth = UIScreen.main.bounds.width
        let viewWidth = (mainViewWidth - 4 * 10) / 3
        let height = (viewWidth * 2500) / 1500
        
        return CGSize(width: viewWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reusableID, for: indexPath as IndexPath) as! ColorCell
        
        let imageValue = imageDetailArrayF[indexPath.row]
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))
                      //|> RoundCornerImageProcessor(cornerRadius: 10)
        cell.gradietImv.kf.indicatorType = .activity
        
        cell.gradietImv.kf.setImage(
            with: URL(string: imageValue.downloadURL ?? ""),
            placeholder: UIImage(named: "bg"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.25))
                //.lowDataMode(.network(lowResolutionURL))
            ],
            progressBlock: { receivedSize, totalSize in
                print("progress: \(receivedSize) Bytes")
            },
            completionHandler: { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        )

        cell.holderView.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imageValue = imageDetailArrayF[indexPath.row]
                
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: EditVc = storyboard.instantiateViewController(withIdentifier: "EditVc") as! EditVc
        vc.modalPresentationStyle = .fullScreen
        let cell = collectionView.cellForItem(at: indexPath) as? ColorCell
        
        downloadImage(with: imageValue.downloadURL ?? "") { image in
            guard let image else {
                print("There is no downloaded image for: \(imageValue.downloadURL)")
                return
            }
             // do what you need with the returned image.
            print("Image is set: \(image.size)")
            vc.mainImage = image
        }
        
        present(vc, animated: true, completion: nil)
    }
}

extension ImageShownViewController {
    func downloadImage(with urlString : String , imageCompletionHandler: @escaping (UIImage?) -> Void){
        guard let url = URL.init(string: urlString) else {
            return  imageCompletionHandler(nil)
        }
        let resource = ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                imageCompletionHandler(value.image)
            case .failure:
                imageCompletionHandler(nil)
            }
        }
    }
}
