//
//  EverPhotoAlbumCollectionViewController.swift
//  DecorationBus
//
//  Created by ruby on 15-3-14.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

let reuseIdentifier = "EverPhotoCollectionCell"

class EverPhotoAlbumCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MWPhotoBrowserDelegate, EverPhotoPlayerViewControllerDelegate {

    var albumName:String = String()
    var imageURLs: Array<String> = Array<String>()
    
    var _photos = NSMutableArray() //图片展示列表
    var _thumbs = NSMutableArray() //缩略图列表
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 放置添加按钮到导航栏
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "addPhotoButtonPressed:")
        
        // 将相册名称放入导航栏标题中
        self.navigationItem.title = albumName
        
        // 使用统一的背景颜色
        self.view.backgroundColor = ColorScheme().viewBackgroundColor
        self.collectionView?.backgroundColor = ColorScheme().viewBackgroundColor
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueImagePlayer" {
            let selectedRow = (self.collectionView?.indexPathsForSelectedItems() as! Array<NSIndexPath>)[0].row
            var destinationView = segue.destinationViewController as! EverPhotoPlayerViewController
            destinationView.delegate = self
            destinationView.setCurrentPhotoIndex(UInt(selectedRow))
            destinationView.setValue(self, forKey: "parentView")
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // 取得图片列表
        self.imageURLs = AlbumHandler().getURLList(albumName)
        println(self.imageURLs)
        
        var photo = MWPhoto()
        _photos.removeAllObjects()
        for imageURL in imageURLs {
            var myImage = UIImage(contentsOfFile: imageURL)
            photo = MWPhoto(image: myImage)
            photo.caption = ""
            _photos.addObject(photo)
        }
        
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageURLs.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photoCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionPhotoCell
        photoCell.photoImageView.image = UIImage(contentsOfFile: imageURLs[indexPath.row])
        photoCell.photoImageView.alpha = 0
        UIView.animateWithDuration(0.2, animations: {
            photoCell.photoImageView.alpha = 1.0
        })
        
        return photoCell;
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("segueImagePlayer", sender: self.view)
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        // 每个cell横向间隔为10, 每行放置三个cell
        let cellEdge = (CGRectGetWidth(UIScreen.mainScreen().bounds) - 20) / 3
        return CGSizeMake(cellEdge, cellEdge)
    }

    /*添加照片，目前只支持从照片库中添加，后期可以扩展到三种方式：照片库、相册和相机*/
    func addPhotoButtonPressed(_: UIBarButtonItem!) {
        println("开始导入图片")
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        AlbumHandler().saveImageToSandbox(albumName, image: image)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        /*添加图片后刷新view*/
        self.collectionView?.reloadData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func EverPhotoPlayerView(willRemoveImage index: UInt) {
        // 删除sandbox图片
        AlbumHandler().removeImageFromSandbox(albumName, imageURL: imageURLs[Int(index)])
        
        // 从collection列表中删除图片
        imageURLs.removeAtIndex(Int(index))
        
        // 从player列表中删除图片
        _photos.removeObjectAtIndex(Int(index))
        
        self.collectionView?.reloadData()
    }
    
    // MARK: MWPhotoBrowserDelegate
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(_photos.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if (index < UInt(_photos.count)) {
            return _photos.objectAtIndex(Int(index)) as! MWPhotoProtocol
        }
        
        return nil;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.None
    }
}
