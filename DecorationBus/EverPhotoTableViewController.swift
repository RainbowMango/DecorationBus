//
//  EverPhotoTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 15-2-4.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

class EverPhotoTableViewController: UITableViewController {

    var phase_ = ["素颜", "设计", "改造", "水电", "木工", "泥工", "油漆", "墙纸", "软装"]
    var phaseTips_ = ["开始动工前，给您的爱家留个影吧~", "设计图纸存档，方便后期查看哦~", "我的房子我做主，想要几房要房~", "线管走向务必拍照哦，后期打洞洞不小心打到了可不是闹着玩滴~", "除了秀下木工师傅手艺，还能干嘛~", "瓷砖贴上大大提升房主逼格~", "我家的样子开始显现了哦~", "墙纸还是壁画？还是墙纸吧，谁用谁知道~", "哇塞，美得一塌糊涂"]
    
    var selectedAlbum: String = String() // 选中特定相册时设置为相册名字，传递到下一个相册
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewColor()
    }
    
    /*每次展示都刷新tableview，因为相册信息或许有变化*/
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
        self.view.backgroundColor = ColorScheme().viewBackgroundColor
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return phase_.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("albumTableCell", forIndexPath: indexPath) as! UITableViewCell

        // 配置cell, 显示本相册基本信息并设置图片圆角效果
        let albumName = phase_[indexPath.section]
        let imageURLs = AlbumHandler().getURLList(albumName)
        let imageNumber = imageURLs.count
        cell.textLabel?.text = albumName
        cell.detailTextLabel?.text = "\(imageNumber)"
        cell.imageView?.image = (imageNumber > 0) ? (UIImage(contentsOfFile: imageURLs[0])) : (UIImage(named: "Album"))
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.layer.cornerRadius = 10.0
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return phaseTips_[section]
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedAlbum = self.phase_[indexPath.section]
        
        performSegueWithIdentifier("toEverPhotoAlbum", sender: self.view)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toEverPhotoAlbum" {
            var destinationView = segue.destinationViewController as! EverPhotoAlbumCollectionViewController
            destinationView.setValue(self.selectedAlbum, forKey: "albumName")
        }
    }
}
