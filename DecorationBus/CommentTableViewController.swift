//
//  CommentTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 16/3/20.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit
import InfiniteCollectionView

class CommentTableViewController: UITableViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var reviewItems = Array<String>() //评论项目，由前面controller传入
    var images      = Array<ImageCollectionViewCellData>() // 用户选取的图片

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate   = self
        collectionView.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     发布评价
     
     - parameter sender: 触发事件的view
     */
    @IBAction func publishComments(sender: AnyObject) {
        print("发布评价")
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StarReviewCell", forIndexPath: indexPath) as! StarReviewTableViewCell

        cell.configure(reviewItems[indexPath.row])

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CommentTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageCollectionViewCell.identifier, forIndexPath: indexPath) as! ImageCollectionViewCell
        
        if(indexPath.row % 2 == 0) {
            cell.configure("camera")
        }
        else{
            cell.configure("userDefaultAvatar")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        /**
         *  判断选择的cell是引导图片还是已经选择的图片
         *  选取cell的index    用户已经选择的图片数    是否引导图
         *        0                   0               true
         *        0                 >=1               false
         *        1                   1               true
         *        1                  >1               false
         */
        if(indexPath.row == images.count) { //添加图片
            
            let alertVC = UIAlertController(title: "添加图片", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            // 检测是否支持拍照（模拟器不支持会引起crash, 真机中访问控制相机被禁后也会crash）
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                let cameraSheet = UIAlertAction(title: HCImagePickerHandler().actionSheetTitleCamera, style: UIAlertActionStyle.Default) { (action) -> Void in
                    if(!DeviceLimitHandler().allowCamera()) {
                        //用户隐私设置禁用相机，弹出alert
                        let alertView = UIAlertView(title: nil, message: "请在“设置-隐私-相机”选项中允许“装修巴士”访问您的相机。", delegate: self, cancelButtonTitle: "确定")
                        alertView.show()
                        return
                    }
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = true
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                    imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeMedium // 获取低质量图片已经足够使用，避免内存使用过多引起内存警告
                    
                    /*
                     * 调用相机时会产生一条log, 应该是IOS8.1的一个bug：
                     Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.
                     */
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
                alertVC.addAction(cameraSheet)
            }
            
            // 检测是否支持图库
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let photoLibrarySheet = UIAlertAction(title: HCImagePickerHandler().actionSheetTitlePhotoLibrary, style: UIAlertActionStyle.Default) { (action) -> Void in
                    if(!DeviceLimitHandler().allowPhotoLibrary()) {
                        //用户隐私设置禁用相册，弹出alert
                        let alertView = UIAlertView(title: nil, message: "请在“设置-隐私-照片”选项中允许“装修巴士”访问您的照片。", delegate: self, cancelButtonTitle: "确定")
                        alertView.show()
                        return
                    }

                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = true
                    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                    imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeMedium // 获取低质量图片已经足够使用，避免内存使用过多引起内存警告
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
                alertVC.addAction(photoLibrarySheet)
            }
            
            let cancelSheet = UIAlertAction(title: HCImagePickerHandler().actionSheetTitleCancel, style: UIAlertActionStyle.Cancel) { (action) -> Void in
            }
            alertVC.addAction(cancelSheet)
            
            self.presentViewController(alertVC, animated: true, completion: nil)
        }
        else { //浏览图片
            print("展示图片")
        }
        print("选择的cell index 为\(indexPath.row)")
    }
}

// MARK: - UIImagePickerController的代理方法
extension CommentTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
     读取图片并保存到沙盒，同时保存图片URL，最后刷新collection view
     
     - parameter picker: picker实例
     - parameter info:   读取到的图片
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil) // 首先释放picker以节省内存
        
        let image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        //AlbumHandler().saveImageToSandbox(albumName, image: image)
        
        /*添加图片后刷新view*/
        //self.collectionView?.reloadData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}