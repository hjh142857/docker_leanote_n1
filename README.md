# docker_leanote_n1
基于ARM的leanote的docker，外置存储，自动定时备份。N1盒子小钢炮环境下测试通过，理论arm通用。

## 使用Usage
```
docker run -d --name leanote --restart=always -m 512M -e "SITEURL=[访问网址/IP+端口]"-p 8000:9000 -v [宿主机储存路径]/leanotedata:/data hjh142857/leanote_n1
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

* 其中`-m 512M`为限制内存，防止dockers占用过多内存影响宿主机，可以自由调整，空载环境约占用100M内存

* Leanote默认端口为9000，因9000与N1小钢炮固件中partainer端口冲突，上述命令将端口映射到了8000

* 一个**必填ENV SITEURL**，填写为你的访问网址/IP+端口，需要注意的是，填写的是各种端口转发之后的网址+端口，比如用nginx转发到8080端口，即填写http://abc.com:8080 ，如按照上述命令无其他端口转发请填写`http://url:8000`即可。**不正确的填写会导致客户端无法同步图片等附件**。

* 请注意**Mongo的27017端口务必不暴露在公网**，本镜像未设置Mongo用户名密码

## 目录结构
```
[宿主机储存路径]/leanotedata 
  |
  |----backup     备份文件夹
  |----configdb   MongoDB目录，为空，不可删除
  |----db         MongoDB目录，为空，不可删除
  |----leanote    leanote目录，还原Leanote时即还原到此目录下
```
