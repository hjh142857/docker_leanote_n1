# docker_leanote_n1
基于ARM的蚂蚁笔记leanote的docker，外置存储，自动定时备份，数据可迁移导入，支持管理员找回。N1盒子小钢炮环境下测试通过，理论arm通用。

## 更新日志Change Log
* 20191109 增加数据恢复功能，修改保留7天备份为可变天数（环境变量 DAYS），添加了[x86_64版本镜像][1]
* 20190910 首次发布镜像

## 使用Usage
```
docker run -d --name leanote --restart=always -m 512M --cpus=1 -e SITEURL="[访问网址/IP+端口]" -e LANG="zh-cn" -e DAYS="3" -p 8000:9000 -v [宿主机储存路径]/leanotedata:/data hjh142857/leanote_n1
```
*  管理员用户：admin / abc123
*  体验用户：demo@leanote.com / demo@leanote.com
*  默认网址路径 http://访问网址或IP:8000

## 说明Description
* 自动备份及导入还原说明
  * 备份路径设置在`[宿主机储存路径]/leanotedata/backup`下
  * 自动备份时间为每天0点，备份~~保存7天~~默认保存3天，可自行调整环境变量DAYS修改（修改为0关闭自动备份），过期自动删除
  * 一份备份共有两个文件
    * mongodb_bak为数据库备份，~~还原方法：清空数据库后重新导入   ！**清空前请注意备份**！~~
    * Leanote_bak为附件及配置文件备份，~~还原方法：解压到`[宿主机储存路径]/leanotedata`下~~
  * 还原/数据导入/迁移方法：
    * 从备份目录中复制出需要导入的一组mongodb和leanote两个tar.gz文件，粘贴到`[宿主机储存路径]/leanotedata/restore`目录下，然后重启docker
    * 还原/数据导入将 **清空原有数据，请注意备份**
    * 仅限复制一组备份文件进入还原目录，多组数据则会启动失败
    * 导入成功后restore还原目录将被清空，如无需还原请不要将文件存放在该目录下
* 参数说明
  * `-m 512M`为限制内存，防止dockers占用过多内存影响宿主机，可以自由调整，空载环境约占用100M内存
  * `--cpus=1`为限制使用单核CPU，默认情况一般cpu使用率低于10%，备份导出时N1单核100%持续30s左右
  * `-p 8000:9000`Leanote默认端口为9000，因9000与N1小钢炮固件中partainer端口冲突，上述命令将端口映射到了8000，可以根据个人需要调整
  * **必填ENV**  SITEURL，填写为你的访问网址/IP+端口，需要注意的是，填写的是各种端口转发之后的网址+端口，比如用nginx转发到8080端口，即填写http://abc.com:8080 ，如按照上述命令无其他端口转发请填写`http://url:8000`即可。**不正确的填写会导致客户端无法同步图片等附件**。
  * 建议添加ENV LANG`-e "LANG=zh-cn"` 修改语言为中文，默认值为英文
  * 备份文件保留天数ENV DAYS`-e "DAYS=3"`，默认为保留3天，设置为0将关闭自动备份
  * 特殊情况ENV ADMINUSER`-e ADMINUSER＝你的user id`，详细见[官方文档][2]
     >为Leanote指定超级管理员帐户(admin用户)
Leanote默认超级管理员为admin, 且一旦不小心修改了username则不能改回. 此时可修改配置文件app.conf, 比如指定用户life为超级管理员

* 注意**MongoDB的27017端口请务必不要直接暴露在公网**，本镜像未设置Mongo用户名密码

## 目录结构
```
[宿主机储存路径]/leanotedata 
  |
  |----backup     备份文件夹
  |----configdb   MongoDB目录，为空，不可删除
  |----db         MongoDB目录，为空，不可删除
  |----leanote    leanote目录，还原Leanote时即还原到此目录下
  |----restore     数据导入/还原文件夹
```
[1]: https://hub.docker.com/r/hjh142857/leanote
[2]: https://github.com/leanote/leanote/wiki/QA#%E4%B8%BAleanote%E6%8C%87%E5%AE%9A%E8%B6%85%E7%BA%A7%E7%AE%A1%E7%90%86%E5%91%98%E5%B8%90%E6%88%B7admin%E7%94%A8%E6%88%B7
