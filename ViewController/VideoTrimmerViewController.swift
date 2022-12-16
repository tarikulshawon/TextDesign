//
//  ViewController.swift
//  PryntTrimmerView
//
//  Created by Henry on 27/03/2017.
//  Copyright © 2017 Prynt. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos

/// A view controller to demonstrate the trimming of a video. Make sure the scene is selected as the initial
// view controller in the storyboard
class VideoTrimmerViewController: UIViewController, filterIndexDelegate, sendSticker, StickerViewDelegate, sendShape, sendValueForAdjust, sendFrames {
    func sendFramesIndex(frames: String) {
        self.addSticker(test: UIImage(named: frames)!)
    }
    
    func sendAdjustValue(value: Float, index: Int) {
        if index == 0 {
            Brightness = value
        }else if index == 1 {
            Saturation = value
        }
        else if index == 2 {
            hue = value
        }
        else if index == 3 {
            sharpen = value
        }
        else if index == 4 {
            Contrast = value
        }
    }
    
    func sendShape(sticker: String) {
        self.addSticker(test: UIImage(named: sticker) ?? UIImage())
        
    }
    
    func stickerViewDidBeginMoving(_ stickerView: StickerView) {
        currentStickerView = stickerView
    }
    
    @IBOutlet weak var bottomSpaceForShape: NSLayoutConstraint!
    func stickerViewDidChangeMoving(_ stickerView: StickerView) {
        currentStickerView = stickerView
    }
    
    func stickerViewDidEndMoving(_ stickerView: StickerView) {
        currentStickerView = stickerView
    }
    
    func stickerViewDidBeginRotating(_ stickerView: StickerView) {
        currentStickerView = stickerView
    }
    
    func stickerViewDidChangeRotating(_ stickerView: StickerView) {
        currentStickerView = stickerView
    }
    
    func stickerViewDidEndRotating(_ stickerView: StickerView) {
        currentStickerView = stickerView
    }
    
    func stickerViewDidClose(_ stickerView: StickerView) {
        currentStickerView = stickerView
    }
    
    func stickerViewDidTap(_ stickerView: StickerView) {
        currentStickerView = stickerView
    }
    
    
    
    func sendSticker(sticker: String) {
        guard let image = UIImage(named: sticker) else { return }
        self.addSticker(test: image)
    }
    
    
    func addSticker(test: UIImage) {
        let testImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        testImage.image = test
        let stickerView3 = StickerView.init(contentView: testImage)
        stickerView3.backgroundColor = UIColor.clear
        stickerView3.center = CGPoint.init(x: 50, y: 50)
        stickerView3.delegate = self
        stickerView3.setImage(UIImage.init(named: "Close")!, forHandler: StickerViewHandler.close)
        stickerView3.setImage(UIImage.init(named: "Rotate")!, forHandler: StickerViewHandler.rotate)
        stickerView3.setImage(UIImage.init(named: "Flip")!, forHandler: StickerViewHandler.flip)
        stickerView3.showEditingHandlers = false
        stickerView3.tag = -1
        stickerView.addSubview(stickerView3)
        stickerView.clipsToBounds = true
        stickerView3.showEditingHandlers = true
        stickerView3.showEditingHandlers = true
    }
    
    func filterNameWithIndex(dic: Dictionary<String, Any>?) {
        currentFilterDic = dic
    }
    
    let adjustVc = Bundle.main.loadNibNamed("Adjust", owner: nil, options: nil)![0] as! Adjust
    
    @IBOutlet weak var frameHolderVc: UIView!
    @IBOutlet weak var bottomSpaceFrame: NSLayoutConstraint!
    @IBOutlet weak var adjustViewHolder: UIView!
    @IBOutlet weak var botomSpaceForAdjust: NSLayoutConstraint!
    @IBOutlet weak var shapeViewHolder: UIView!
    @IBOutlet weak var stickerView: UIView!
    @IBOutlet weak var heightForStickerView: NSLayoutConstraint!
    @IBOutlet weak var widthForStickerView: NSLayoutConstraint!
    let shapeVc = Bundle.main.loadNibNamed("ShapeVc", owner: nil, options: nil)![0] as! ShapeVc
    
    @IBOutlet weak var stickerViewHolder: UIView!
    @IBOutlet weak var bottomSpaceForSticker: NSLayoutConstraint!
    
    var currentFilterDic:Dictionary<String, Any>!
    @IBOutlet weak var filterViewHolder: UIView!
    @IBOutlet weak var bottomSpaceTrim: NSLayoutConstraint!
    let filterVc =  Bundle.main.loadNibNamed("FilterVc", owner: nil, options: nil)![0] as! FilterVc
    let stickerVc = Bundle.main.loadNibNamed("StickerVc", owner: nil, options: nil)![0] as! StickerVc
    let frameVc =  Bundle.main.loadNibNamed("FrameVc", owner: nil, options: nil)![0] as! FrameVc
    @IBOutlet weak var collectionViewForBtn: UICollectionView!
    @IBOutlet weak var selectAssetButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var trimmerView: TrimmerView!
    var currentlyActiveIndex  = -1
    var plistArray2:NSArray!
    var asset:AVAsset!
    var cellWidth:CGFloat = 60
    var cellGap:CGFloat = 0
    var player: AVPlayer?
    var playbackTimeCheckerTimer: Timer?
    var trimmerPositionChangedTimer: Timer?
    @IBOutlet weak var bottomSpaceForFilter: NSLayoutConstraint!
    var trimmmedComposition:AVMutableComposition!
    var playerItem:AVPlayerItem!
    var videoUrl: URL!
    var compositionVideoTrack: AVMutableCompositionTrack!
    var assetTrack: AVAssetTrack!
    var currentStickerView: StickerView!
    
    var Brightness: Float = 0.0
    var max_brightness:Float = 0.7
    var min_brightness:Float = -0.7
    
    var Saturation: Float = 1.0
    var max_saturation:Float = 3
    var min_saturation:Float = -1
    
    var hue: Float = 0.0
    var max_hue:Float = 1.0
    var min_hue:Float = -1.0
    
    var Contrast: Float = 1.0
    var max_contrast:Float = 1.5
    var min_contrast:Float = 0.5
    
    var sharpen:Float = 0
    var max_sharpen:Float = 4.0
    var min_sharpen:Float = -4.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trimmerView.handleColor = UIColor.white
        trimmerView.mainColor = UIColor.darkGray
        let path = Bundle.main.path(forResource: "VideoEdit", ofType: "plist")
        plistArray2 = NSArray(contentsOfFile: path!)
        
        let nibName = UINib(nibName: RatioCell.reusableID, bundle: nil)
        collectionViewForBtn.register(nibName, forCellWithReuseIdentifier:  RatioCell.reusableID)
        
        
        self.perform(#selector(self.targetMethod), with: self, afterDelay: 0.1)
        
        
    }
    
    func createComposition(withMuteStatus isMute: Bool) -> AVMutableComposition? {
        let range = CMTimeRangeMake(start: .zero, duration: asset.duration)
        let tempMixComposition = AVMutableComposition()
        
        compositionVideoTrack = tempMixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        assetTrack = asset.tracks(withMediaType: .video).first
        
        try? compositionVideoTrack?.insertTimeRange(range, of: assetTrack, at: .zero)
    
        
        if ((asset as? AVAsset)?.tracks(withMediaType: .audio).count ?? 0) != 0 {
            let audioAsset = asset.tracks(withMediaType: .audio).last
            let compositionCommentaryTrack = tempMixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            if let audioAsset {
                try? compositionCommentaryTrack?.insertTimeRange(
                    CMTimeRangeMake(start: .zero, duration: tempMixComposition.duration),
                    of: audioAsset,
                    at: .zero)
            }
        }
        let assetVideoTrack = asset.tracks(withMediaType: .video).last
        
        if assetVideoTrack != nil && compositionVideoTrack != nil {
            if let preferredTransform = assetVideoTrack?.preferredTransform {
                compositionVideoTrack?.preferredTransform = preferredTransform
            }
        }
        return tempMixComposition
    }
    
    func prepareForComposition() {
        
        playerItem.videoComposition = AVVideoComposition(asset: trimmmedComposition, applyingCIFiltersWithHandler: { request in
            
            var output:CIImage?
            do {
                output = getFilteredCImage(withInfo: self.currentFilterDic, for: request.sourceImage)
                print(self.currentFilterDic)
            } catch {
                print("sadiq")
            }
            
            request.finish(with: output ?? request.sourceImage, context: nil)
            
        })
        
    }
    
    
    
    func updateValue() {
        
        UIView.animate(withDuration: 0.2, animations: { [self] in
            
            if self.currentlyActiveIndex != BtnNameVIDEOInt.Trim.rawValue {
                self.bottomSpaceTrim.constant = -1000
            }
            if self.currentlyActiveIndex != BtnNameVIDEOInt.Filter.rawValue {
                self.bottomSpaceForFilter.constant = -1000
            }
            if self.currentlyActiveIndex != BtnNameVIDEOInt.Graphics.rawValue {
                self.bottomSpaceForSticker.constant = -1000
            }
            if self.currentlyActiveIndex != BtnNameVIDEOInt.Shape.rawValue {
                self.bottomSpaceForShape.constant = -1000
            }
            if self.currentlyActiveIndex != BtnNameVIDEOInt.Adjust.rawValue {
                self.botomSpaceForAdjust.constant = -1000
            }
            if self.currentlyActiveIndex != BtnNameVIDEOInt.Frames.rawValue {
                self.bottomSpaceFrame.constant = -1000
            }
            
            if currentlyActiveIndex >= 0 {
                if self.currentlyActiveIndex == BtnNameVIDEOInt.Filter.rawValue {
                    self.bottomSpaceForFilter.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameVIDEOInt.Trim.rawValue {
                    self.bottomSpaceTrim.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameVIDEOInt.Graphics.rawValue {
                    self.bottomSpaceForSticker.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameVIDEOInt.Shape.rawValue {
                    self.bottomSpaceForShape.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameVIDEOInt.Adjust.rawValue {
                    self.botomSpaceForAdjust.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameVIDEOInt.Frames.rawValue {
                    self.bottomSpaceFrame.constant = 0
                }
            }
            self.view.layoutIfNeeded()
            
        }, completion: {_ in
            
        })
    }
    
    @IBAction func gotoExport(_ sender: Any) {
        makeBirthdayCard(fromVideoAt: videoUrl, forName: "TIS") { url in
            print("DONE?")
            PHPhotoLibrary.requestAuthorization { [weak self] status in
              switch status {
              case .authorized:
                  self?.saveVideoToPhotos(url!)
              default:
                print("Photos permissions not granted.")
                return
              }
            }
        }
    }
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        player?.pause()
        self.dismiss(animated: true)
    }
    
    @IBAction func selectAsset(_ sender: Any) {
        
    }
    
    @objc fileprivate func targetMethod(){
        
        let totalCellWidth = cellWidth * CGFloat(plistArray2.count)
        let totalSpacingWidth = cellGap * CGFloat((plistArray2.count - 1))
        
//        _ = (collectionViewForBtn.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumInteritemSpacing = cellGap
        layout.minimumLineSpacing = cellGap
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewForBtn?.collectionViewLayout = layout
        
        
        trimmerView.asset = asset
        trimmerView.delegate = self
        addVideoPlayer(with: asset, playerView: playerView)
        
        filterVc.frame = CGRect(x: 0,y: 0,width: filterViewHolder.frame.width,height: filterViewHolder.frame.height)
        filterVc.delegateForFilter = self
        filterViewHolder.addSubview(filterVc)
        
        stickerVc.frame = CGRect(x: 0,y: 0,width: stickerViewHolder.frame.width,height: stickerViewHolder.frame.height)
        stickerVc.delegateForSticker = self
        stickerViewHolder.addSubview(stickerVc)
        
        
        shapeVc.frame = CGRect(x: 0,y: 0,width: shapeViewHolder.frame.width,height: shapeViewHolder.frame.height)
        shapeVc.delegateForShape = self
        shapeViewHolder.addSubview(shapeVc)
        
        
        adjustVc.frame = CGRect(x: 0,y: 0,width: adjustViewHolder.frame.width,height: adjustViewHolder.frame.height)
        adjustVc.delegate = self
        adjustViewHolder.addSubview(adjustVc)
        
        frameVc.frame = CGRect(x: 0,y: 0,width: frameHolderVc.frame.width,height: frameHolderVc.frame.height)
        frameVc.delegateForFramesr = self
        frameHolderVc.addSubview(frameVc)
        
        guard let videoSize = resolutionForLocalVideo() else { return   }
        
        let size = AVMakeRect(aspectRatio: videoSize , insideRect: CGRect(x: 0, y: 0, width:   playerView.frame.width ,height:   playerView.frame.height))
        
        widthForStickerView.constant = size.width
        heightForStickerView.constant = size.height
        
        
    }
    
    @IBAction func play(_ sender: Any) {
        
        guard let player = player else { return }
        
        if !player.isPlaying {
            player.play()
            startPlaybackTimeChecker()
        } else {
            player.pause()
            stopPlaybackTimeChecker()
        }
    }
    
    private func addVideoPlayer(with asset: AVAsset, playerView: UIView) {
        trimmmedComposition = self.createComposition(withMuteStatus: true) // sound is muted
        playerItem = AVPlayerItem(asset: trimmmedComposition)
        player = AVPlayer(playerItem: playerItem)
        
        self.prepareForComposition()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(VideoTrimmerViewController.itemDidFinishPlaying(_:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        let layer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: playerView.frame.width, height: playerView.frame.height)
        // layer.frame = playerView.bounds
        
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        playerView.layer.addSublayer(layer)
        
      
        
        
        
        
        
    }
    
    private func resolutionForLocalVideo() -> CGSize? {
        guard let track = asset.tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
    
    @objc func itemDidFinishPlaying(_ notification: Notification) {
        if let startTime = trimmerView.startTime {
            player?.seek(to: startTime)
            if (player?.isPlaying != true) {
                player?.play()
            }
        }
    }
    
    func startPlaybackTimeChecker() {
        
        stopPlaybackTimeChecker()
        playbackTimeCheckerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                        selector:
                                                            #selector(VideoTrimmerViewController.onPlaybackTimeChecker), userInfo: nil, repeats: true)
    }
    
    func stopPlaybackTimeChecker() {
        
        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
    }
    
    
    
    @objc func onPlaybackTimeChecker() {
        
        guard let startTime = trimmerView.startTime, let endTime = trimmerView.endTime, let player = player else {
            return
        }
        
        let playBackTime = player.currentTime()
        trimmerView.seek(to: playBackTime)
        
        if playBackTime >= endTime {
            player.seek(to: startTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            trimmerView.seek(to: startTime)
        }
    }
}

extension VideoTrimmerViewController: TrimmerViewDelegate {
    func positionBarStoppedMoving(_ playerTime: CMTime) {
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        player?.play()
        startPlaybackTimeChecker()
    }
    
    func didChangePositionBar(_ playerTime: CMTime) {
        stopPlaybackTimeChecker()
        player?.pause()
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        let duration = (trimmerView.endTime! - trimmerView.startTime!).seconds
        //print"duration)
    }
}

extension VideoTrimmerViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plistArray2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(cellGap)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RatioCell.reusableID,
            for: indexPath) as? RatioCell else {
            return RatioCell()
        }
        
        if let value = plistArray2[indexPath.row] as? String  {
            
            cell.iconImv.image = UIImage(named: value)?.withRenderingMode(.alwaysTemplate)
            if indexPath.row == currentlyActiveIndex {
                cell.iconImv.tintColor = titleColor
                cell.iconLabel.textColor = titleColor
            } else {
                cell.iconImv.tintColor = unselectedColor
                cell.iconLabel.textColor = unselectedColor
            }
            
            cell.iconLabel.text = value
        }
        cell.heightForLabel.constant = 20.0
        return cell
    }
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let cell = collectionView.cellForItem(at: indexPath) as? RatioCell
        
        if let btnValue = cell?.iconLabel.text {
            
            if btnValue == BtnNameVIDEO.Trim.rawValue {
                let p = self.bottomSpaceTrim.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameVIDEOInt.Trim.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
            }
            
            if btnValue == BtnNameVIDEO.Adjust.rawValue {
                let p = self.botomSpaceForAdjust.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameVIDEOInt.Adjust.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
            }
            
            if btnValue == BtnNameVIDEO.Filter.rawValue {
                let p = self.bottomSpaceForFilter.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameVIDEOInt.Filter.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
            }
            if btnValue == BtnNameVIDEO.Graphics.rawValue {
                let p = self.bottomSpaceForSticker.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameVIDEOInt.Graphics.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
            }
            if btnValue == BtnNameVIDEO.Shape.rawValue {
                let p = self.bottomSpaceForShape.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameVIDEOInt.Shape.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
            }
            if btnValue == BtnNameVIDEO.Frames.rawValue {
                let p = self.bottomSpaceFrame.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameVIDEOInt.Frames.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
            }
            updateValue()
        }
        
    }
}

extension VideoTrimmerViewController {
    private func allLayerComposition(imageName: String, videoSize: CGSize) -> AVMutableVideoComposition {
        let videoLayer = CALayer()
        videoLayer.frame = CGRect(origin: .zero, size: videoSize)
        let overlayLayer = CALayer()
        overlayLayer.frame = CGRect(origin: .zero, size: videoSize)
        
        //
        let image = UIImage(named: imageName)!
        let imageLayer = CALayer()
        
        let aspect: CGFloat = image.size.width / image.size.height
        let width = videoSize.width
        let height = width / aspect
        imageLayer.frame = CGRect(
            x: 0,
            y: -height * 0.15,
            width: width,
            height: height)
        
        imageLayer.contents = image.cgImage
        overlayLayer.addSublayer(imageLayer)
        //
        
        let outputLayer = CALayer()
        outputLayer.frame = CGRect(origin: .zero, size: videoSize)
        outputLayer.addSublayer(videoLayer)
        outputLayer.addSublayer(overlayLayer)
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(
            postProcessingAsVideoLayer: videoLayer,
            in: outputLayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(
            start: .zero,
            duration: trimmmedComposition.duration)
        videoComposition.instructions = [instruction]
        let layerInstruction = compositionLayerInstruction(
            for: compositionVideoTrack,
            assetTrack: assetTrack)
        instruction.layerInstructions = [layerInstruction]
        
        return videoComposition
    }
    
    private func compositionLayerInstruction(
        for track: AVCompositionTrack,
        assetTrack: AVAssetTrack) -> AVMutableVideoCompositionLayerInstruction
    {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let transform = assetTrack.preferredTransform
        
        instruction.setTransform(transform, at: .zero)
        
        return instruction
    }
    
    private func saveVideoToPhotos(_ url: URL) {
        PHPhotoLibrary.shared().performChanges( {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { [weak self] (isSaved, error) in
            if isSaved {
                print("Video saved.")
            } else {
                print("Cannot save video.")
                print(error ?? "unknown error")
            }
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension VideoTrimmerViewController {
    func makeBirthdayCard(fromVideoAt videoURL: URL, forName name: String, onComplete: @escaping (URL?) -> Void) {
        let asset = AVURLAsset(url: videoURL)
        let composition = AVMutableComposition()
        
        guard
            let compositionTrack = composition.addMutableTrack(
                withMediaType: .video,
                preferredTrackID: kCMPersistentTrackID_Invalid
            ),
            let assetTrack = asset.tracks(withMediaType: .video).first
        else {
            print("Something is wrong with the asset.")
            onComplete(nil)
            return
        }
        
        do {
            let timeRange = CMTimeRange(start: .zero, duration: asset.duration)
            try compositionTrack.insertTimeRange(timeRange, of: assetTrack, at: .zero)
            
            if let audioAssetTrack = asset.tracks(withMediaType: .audio).first,
               let compositionAudioTrack = composition.addMutableTrack(
                withMediaType: .audio,
                preferredTrackID: kCMPersistentTrackID_Invalid) {
                try compositionAudioTrack.insertTimeRange(
                    timeRange,
                    of: audioAssetTrack,
                    at: .zero
                )
            }
        } catch {
            print(error)
            onComplete(nil)
            return
        }
        
        compositionTrack.preferredTransform = assetTrack.preferredTransform
        let videoInfo = orientation(from: assetTrack.preferredTransform)
        
        let videoSize: CGSize
        
        if videoInfo.isPortrait {
            videoSize = CGSize(
                width: assetTrack.naturalSize.height,
                height: assetTrack.naturalSize.width
            )
        } else {
            videoSize = assetTrack.naturalSize
        }

        let backgroundLayer = CALayer()
        backgroundLayer.frame = CGRect(origin: .zero, size: videoSize)
        let videoLayer = CALayer()
        videoLayer.frame = CGRect(origin: .zero, size: videoSize)
        let overlayLayer = CALayer()
        overlayLayer.frame = CGRect(origin: .zero, size: videoSize)
        
        addImage(to: overlayLayer, videoSize: videoSize)
        
        let outputLayer = CALayer()
        outputLayer.frame = CGRect(origin: .zero, size: videoSize)
        outputLayer.addSublayer(backgroundLayer)
        outputLayer.addSublayer(videoLayer)
        outputLayer.addSublayer(overlayLayer)
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(
            postProcessingAsVideoLayer: videoLayer,
            in: outputLayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(
            start: .zero,
            duration: composition.duration)
        
        videoComposition.instructions = [instruction]
        let layerInstruction = compositionLayerInstruction(
            for: compositionTrack,
            assetTrack: assetTrack
        )
        
        instruction.layerInstructions = [layerInstruction]
        
        guard let export = AVAssetExportSession(
            asset: composition,
            presetName: AVAssetExportPresetHighestQuality)
        else {
            print("Cannot create export session.")
            onComplete(nil)
            return
        }
        
        let videoName = UUID().uuidString
        let exportURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(videoName)
            .appendingPathExtension("mov")
        
        export.videoComposition = videoComposition
        export.outputFileType = .mov
        export.outputURL = exportURL
        
        export.exportAsynchronously {
            DispatchQueue.main.async {
                switch export.status {
                case .completed:
                    onComplete(exportURL)
                default:
                    print("Something went wrong during export.")
                    print(export.error ?? "unknown error")
                    onComplete(nil)
                    break
                }
            }
        }
    }
    
    private func orientation(from transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }
        
        return (assetOrientation, isPortrait)
    }
    
    private func addImage(to layer: CALayer, videoSize: CGSize) {
        guard let currentStickerView else {
            print("view is nil")
            return
        }
        print("video size: \(videoSize)")
        if let image = currentStickerView.contentView.image {
            let imageLayer = CALayer()
            //CGRect(origin: .zero, size: videoSize)
            let aspect: CGFloat = image.size.width / image.size.height
            let width = videoSize.width
            let height = width / aspect
            //currentStickerView.contentView.frame
            //imageLayer.frame = currentStickerView.contentView.frame
            //imageLayer.backgroundColor = UIColor.red.cgColor
            print("Position: \(currentStickerView.frame), aspect: \(aspect)")
            imageLayer.frame = CGRect(
                origin: .zero,
                size: currentStickerView.frame.size
            )
//            imageLayer.frame = CGRect(
//                x: 0,
//                y: -height * 0.15,
//                width: width, //currentStickerView.frame.width,
//                height: height) //currentStickerView.frame.height)
            
            print("Position image: \(imageLayer.frame)")
            imageLayer.contents = image.cgImage
            layer.addSublayer(imageLayer)
        } else {
            print("Image is nil")
        }
    }
}
