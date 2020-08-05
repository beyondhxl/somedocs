

### 一、问题表现

代码更新之后，svn st 查看当前版本库文件状态，发现出现如下图所示，大量`?`问号的情况。当然还有部分`X`号的情况，目前只是解决了问号的问题。

```yml
?       go/src/github.com/astaxie/beego/build_info.go
?       go/src/github.com/astaxie/beego/fs.go
?       go/src/github.com/astaxie/beego/go.mod
?       go/src/github.com/astaxie/beego/go.sum
?       go/src/github.com/astaxie/beego/metric
```

### 二、解决方法

```yml
svn status --no-ignore | grep '^[I?]' | cut -c 9- | while IFS= read -r f; do rm -rf "$f"; done
```

This has the following features:

- Both ignored and untracked files are deleted
- It works even if a file name contains whitespace (except for newline, but there's not much that can be done about that other than use the --xml - option and parse the resulting xml output)
- It works even if svn status prints other status characters before the file name (which it shouldn't because the files are not tracked, but just in case...)
- It should work on any POSIX-compliant system

上述 svn 命令的大致作用如下：

- 同时删除了忽略何未加入版本控制的文件

- 即使文件名包含空格，也可以正常工作

- 即使 svn status 在文件名之前打印其他状态字符，也可以正常工作

- 可以工作在任何兼容 POSIX 的系统上

**参考原文**

[How can I delete all unversioned/ignored files/folders in my working copy?](https://stackoverflow.com/questions/2803823/how-can-i-delete-all-unversioned-ignored-files-folders-in-my-working-copy)




