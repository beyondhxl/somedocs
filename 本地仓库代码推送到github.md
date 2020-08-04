> **本地仓库代码推送到 github 的步骤**

<!-- more -->

使用 github 只需要简单的三步：
1. 初始化本地仓库 git
2. 将自己的电脑与指定 github 账户关联
3. 将自己的仓库与 github 上的某个项目关联

### 一、初始化本地仓库 git

**1、首先下载 git**

先去 [git 官方地址](https://gitforwindows.org/)下载 git。下载后，直接按照默认配置安装。

**2、验证是否安装成功**

回到电脑桌面，鼠标右击如果看到有两个 git 相关的右键菜单栏，则安装成功。

![](https://blogimage-1300452281.cos.ap-shanghai.myqcloud.com/github/%E6%9C%AC%E5%9C%B0%E4%BB%93%E5%BA%93%E6%8E%A8%E9%80%81%E5%88%B0github.png)

或者 “Win+R” 进入命令行界面，输入 cmd。当输入 git，出现以下界面，则表示安装成功。

![](https://blogimage-1300452281.cos.ap-shanghai.myqcloud.com/github/%E6%9C%AC%E5%9C%B0%E4%BB%93%E5%BA%93%E6%8E%A8%E9%80%81%E5%88%B0github1.png)

**3、git 初始化及仓库创建操作**

新建一个文件夹作为本地仓库，右建，选择 git bash here，在打开的页面中输入 git init（初始化本地仓库）

### 二、将自己的电脑与指定 github 账户关联

**1、注册 GitHub 账户**

1. 设置用户名：git config --global user.name '你在 github上 注册的用户名';

2. 设置用户邮箱：git config --global user.email '注册时候的邮箱';

```sh
git config --global user.name 'beyond'
git config --global user.mail '123456@qq.com'
```

3. 检验是否配置成功：git config --list

```sh
$ git config --list
diff.astextplain.textconv=astextplain
filter.lfs.clean=git-lfs clean -- %f
filter.lfs.smudge=git-lfs smudge -- %f
filter.lfs.process=git-lfs filter-process
filter.lfs.required=true
http.sslbackend=openssl
http.sslcainfo=D:/Program Files/Git/mingw64/ssl/certs/ca-bundle.crt
core.autocrlf=true
core.fscache=true
core.symlinks=false
pull.rebase=false
credential.helper=manager
user.name=beyond
user.mail=123456@qq.com
core.repositoryformatversion=0
core.filemode=false
core.bare=false
core.logallrefupdates=true
core.symlinks=false
core.ignorecase=true
```

**2、将 GitHub 上对应的项目复制到本地**

git clone 仓库地址（即 github 上的地址，项目在之前已经在 github 上 new repository 出来了）

```sh
$ git clone https://github.com/beyondhxl/chatroom.git
Cloning into 'chatroom'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), 583 bytes | 83.00 KiB/s, done.
```

**3、将本地项目同步到 GitHub 上：git push**

- **生成本机的 SSH key**
输入：`ssh-keygen -t rsa -C "邮箱"` （注意！双引号里面是你在 github 注册的邮箱）
```sh
$ ssh-keygen -t rsa -C "123456@qq.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/c/Users/PCSetupAccount/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /c/Users/PCSetupAccount/.ssh/id_rsa
Your public key has been saved in /c/Users/PCSetupAccount/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:hPXgDS5RHWD5w0EudhANVvNn3rY54332jzbB+qUB9q0 123456@qq.com
The key's randomart image is:
+---[RSA 3072]----+
|      ..%X=.     |
|       O.B+o     |
|      o *o=.. o  |
|       + o+  + . |
|        S  .o.. o|
|           . oooo|
|             .o*o|
|            . +**|
|             oE+B|
+----[SHA256]-----+

```
完成上面操作无误后，即可在上面指出的目录下找到两个文件 id_rsa 和 id_rsa_pub。**接着用 Notepad++ 打开 id_rsa_pub 文件，复制 id_rsa_pub 文件里面的所有内容**。打开 github，进入 settings，选择左边的 SSH and GPG keys，把刚才复制的密钥添加进去，title 那里可以自己取一个名字，点击添加，最后就可以看到生成 sshkey 了。下次上传项目时就不需要再配置密钥了。

**4、遇到的问题**

- **推送问题一**
```yml
$ git push -u origin master
error: src refspec master does not match any
error: failed to push some refs to 'github.com:beyondhxl/chatroom.git'
```
引起该错误的原因是，目录中没有文件，空目录是不能提交上去的，而且在 push 之前至少有过一次 commit。解法方法：
```yml
git init 
git touch README 
git add README 
git commit -m 'first commit'
git remote add origin https://github.com/xxx.github.io.git
git push origin master
```
如果在 github 的 remote 上已经有了文件，会出现错误。此时应当先 pull 一下，即
```yml
git pull origin master
```

- **推送问题二**
```sh
$ git push origin master
To github.com:beyondhxl/chatroom.git
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to 'github.com:beyondhxl/chatroom.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```
可以使用如下语句强制推送
```yml
$ git push -u origin master -f 
```
`但是这样会使远程修改丢失，一般是不可取的，尤其是多人协作开发的时候`。

- **推送问题三**
```yml
$ git remote add origin git@github.com:beyondhxl/somedocs.git
fatal: not a git repository (or any of the parent directories): .git
```
对应解决方法
```yml
$ git init
Initialized empty Git repository in D:/somedocs/.git/
```

- **推送问题四**
```yml
$ git commit -m"更新"

*** Please tell me who you are.

Run

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

fatal: unable to auto-detect email address (got 'PCSetupAccount@L-R90YFQ7W-1223.(none)')
```

**参考文章**:  
1、[github上传时出现error: src refspec master does not match any解决办法](https://blog.csdn.net/xl_lx/article/details/80676208)
2、[Git 提示error:src refspec master does not match any](https://www.jianshu.com/p/40ffdd0654f4)
3、[将本地代码上传到GitHub](https://zhuanlan.zhihu.com/p/81112053)
4、[【Git】Updates were rejected because the tip of your current branch is behind](https://blog.csdn.net/zhangkui0418/article/details/82977519)