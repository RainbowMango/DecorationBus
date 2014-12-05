#装修管家

###简介
装修管家旨在深入到装修过程中的各个环节，减轻装修业主负担。  

只有经历过装修的业主才能明白装修过程中的艰辛、迷茫和幸福。预算、设计、施工、建材选购及后续保修等事项都让业主操碎了心。

装修管家的宗旨是“让装修变得简单”

本IOS应用使用全新的swift语言，一切刚刚开始，欢迎加入~

###待解决问题列表
* 功能实现：预算列表和订单列表支持修改和删除功能
* 
* 继续扩充中
* 

### 已解决问题
* 功能实现：首页显示支出总额、预算余额和预算总额需要从预算列表里动态计算并显示出来
* 功能实现：点击支出列表显示支出明细
* 功能实现：点击预算列表显示预算明细
* 功能实现：类别管理页面向左滑动cell删除内容
* 提升体验：输入订单页面，点击完成，存储用户表单后返回前个页面
* 提升体验：输入预算页面，点击完成，存储用户表单后返回前个页面
* 界面布局：支出明细页面表格紧接导航栏
* 界面布局：预算明细页面表格紧接导航栏
* 界面布局：支出明细页面删除每个表格后面的蓝色圆圈
* 界面布局：预算明细页面删除每个表格后面的蓝色圆圈 
* 界面布局：子类管理页面删除“删除大类”按钮
* 缺陷修复：输入订单页面后无法立即查看改订单，需要用户重新启动，即查看订单页面没能获得tab切换事件。
* 缺陷修复：输入预算页面后无法立即查看改预算，需要用户重新启动，即查看预算页面没能获得tab切换事件。
* 缺陷修复：输入订单或预算后，回到首页，首页无法自动更新
* 缺陷修复：设置页面点击“软件初始化”按钮导致crash

###如何参与开发
1. 首先在gitHub上fork我的项目
2. 配置ssh-key: <https://help.github.com/articles/generating-ssh-keys/>
3. 配置终端git:  
   `git config --global user.name "your user name"`  
   `git config --global user.email "your email address"`  
   `git remote add upstream https://github.com/RainbowMango/DecorationSteward.git`  
4. 把fork过去的项目也就是你的项目clone到你的本地
5. 获取我的更新  
   `git fetch upstream`   
   `git merge upstream/master`  
   `git push`
6. 开始开发新的功能并提交到自己的仓库  
   `git commit -m "xxx"`
   `git push`
7. 在gitHub上发起Pull Request 等待我来处理
8. 重复5，6，7开发新的功能。

###参与者
* penny  产品经理
* Gilbertat iOS 开发工程师
