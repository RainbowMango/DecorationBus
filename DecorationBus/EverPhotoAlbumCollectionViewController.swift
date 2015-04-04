//
//  EverPhotoAlbumCollectionViewController.swift
//  DecorationBus
//
//  Created by ruby on 15-3-14.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

let reuseIdentifier = "EverPhotoCollectionCell"

class EverPhotoAlbumCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, EverPhotoPlayerViewControllerDelegate {

    var albumName:String = String()
    var imageURLs: Array<String> = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 放置添加按钮到导航栏
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: .Bordered, target: self, action: "addPhoto:")
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueImagePlayer" {
            var destinationView = segue.destinationViewController as EverPhotoPlayerViewController
            let selectedRow = (self.collectionView?.indexPathsForSelectedItems() as Array<NSIndexPath>)[0].row
            destinationView.setValue(selectedRow, forKey: "curImageIndex")
            destinationView.setValue(imageURLs, forKey: "imageURLs")
            destinationView.setValue(albumName, forKey: "albumName")
            destinationView.setValue(self, forKey: "parentView")
            
            // 下个view隐藏tabbar, 给予用户更多浏览空间
            self.hidesBottomBarWhenPushed = true
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // 取得图片列表
        self.imageURLs = AlbumHandler().getURLList(albumName)
        println(self.imageURLs)
        
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageURLs.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
    
        (cell.contentView.viewWithTag(1) as UIImageView).image = UIImage(contentsOfFile: imageURLs[indexPath.row])
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("segueImagePlayer", sender: self.view)
    }

    /*添加照片，目前只支持从照片库中添加，后期可以扩展到三种方式：照片库、相册和相机*/
    func addPhoto(_: UIBarButtonItem!) {
        println("开始导入图片")
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image: UIImage = info["UIImagePickerControllerOriginalImage"] as UIImage
        println(info.description)
        //self.imageView01.image = image
        AlbumHandler().saveImageToSandbox(albumName, image: image)
        println("保存照片到\(albumName)")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        /*添加图片后刷新view*/
        self.collectionView?.reloadData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func currentImageURLs(curImageURLs: Array<String>) -> Void {
        if curImageURLs != imageURLs {
            println("导航回来刷新数据")
            imageURLs = curImageURLs
            self.collectionView?.reloadData()
        }
    }
}
