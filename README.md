# docker_leanote_n1
基于ARM的leanote的docker，外置存储，自动定时备份。N1盒子小钢炮环境下测试通过，理论arm通用。

## 使用Usage
```
docker run -d --name leanote --restart=always -m 512M --cpus=1 -e "SITEURL=[访问网址/IP+端口]" -e "LANG=zh-cn" -p 8000:9000 -v [宿主机储存路径]/leanotedata:/data hjh142857/leanote_n1
```
*  管理员用户：admin / abc123
*  体验用户：demo@leanote.com / demo@leanote.com
*  默认网址路径 http://访问网址或IP:8000

## 说明Description
* 自动备份说明
  * 备份路径设置在`[宿主机储存路径]/leanotedata/backup`下
  * 自动备份时间为每天0点，备份保存7天，过期自动删除
  * 一份备份共有两个文件
    * mongodb_bak数据库备份，还原方法：清空数据库后重新导入   ！**清空前请注意备份**！
    * Leanote_bak设置附件备份，还原方法：解压到`[宿主机储存路径]/leanotedata`下
* 参数说明
  * `-m 512M`为限制内存，防止dockers占用过多内存影响宿主机，可以自由调整，空载环境约占用100M内存
  * `--cpus=1`为限制使用单核CPU，默认情况一般cpu使用率低于10%，备份导出时N1单核100%持续30s左右
  * `-p 8000:9000`Leanote默认端口为9000，因9000与N1小钢炮固件中partainer端口冲突，上述命令将端口映射到了8000，可以根据个人需要调整
  * **必填ENV**SITEURL，填写为你的访问网址/IP+端口，需要注意的是，填写的是各种端口转发之后的网址+端口，比如用nginx转发到8080端口，即填写http://abc.com:8080 ，如按照上述命令无其他端口转发请填写`http://url:8000`即可。**不正确的填写会导致客户端无法同步图片等附件**。
  * 建议添加ENV LANG`-e "LANG=zh-cn"` 修改默认语言为中文
  * 特殊情况ENV ADMINUSER`-e ADMINUSER＝你的user id`，详细见[官方文档][1]
  >为Leanote指定超级管理员帐户(admin用户)
Leanote默认超级管理员为admin, 且一旦不小心修改了username则不能改回. 此时可修改配置文件app.conf, 比如指定用户life为超级管理员
  [1]:https://github.com/leanote/leanote/wiki/QA#%E4%B8%BAleanote%E6%8C%87%E5%AE%9A%E8%B6%85%E7%BA%A7%E7%AE%A1%E7%90%86%E5%91%98%E5%B8%90%E6%88%B7admin%E7%94%A8%E6%88%B7

* 请注意**MongoDB的27017端口务必不暴露在公网**，本镜像未设置Mongo用户名密码

## 目录结构
```
[宿主机储存路径]/leanotedata 
  |
  |----backup     备份文件夹
  |----configdb   MongoDB目录，为空，不可删除
  |----db         MongoDB目录，为空，不可删除
  |----leanote    leanote目录，还原Leanote时即还原到此目录下
```
