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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
        self.view.backgroundColor = ColorScheme().viewBackgroundColor
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return phase_.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = phase_[indexPath.section]
        cell.imageView?.image = UIImage(named: "Album")

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return phaseTips_[section]
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedAlbum = self.phase_[indexPath.section]
        
//        var alertView = UIAlertView(title: "敬请期待", message: "你造吗，这是款众多装修业主一起打造的产品，你要不要参与呢~", delegate: self, cancelButtonTitle: "好的")
//        alertView.show()
        
        performSegueWithIdentifier("toEverPhotoAlbum", sender: self.view)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toEverPhotoAlbum" {
            var destinationView = segue.destinationViewController as EverPhotoAlbumCollectionViewController
            destinationView.setValue(self.selectedAlbum, forKey: "albumName")
        }
    }

}
