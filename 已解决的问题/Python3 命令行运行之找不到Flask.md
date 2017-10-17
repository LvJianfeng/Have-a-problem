## Python3 命令行运行之找不到Flask

### 在运行python3 *.py文件的之后，如果工程运行用Flask框架，发生如下错误。
```python
Traceback (most recent call last):
  File "ghostIPA.py", line 2, in <module>
    from flask import Flask, render_template, flash
ModuleNotFoundError: No module named 'flask'
```

## 解决方法
```python
    // 安装pip
    easy_install pip

    // 安装Flask
    sudo pip install flask
```

### 如果发生如上的问题，可执行
```python
    // 这个貌似是因为上面那个是全局安装的问题导致的
    // 如果有大神能不吝解释下，还请说明哦，谢谢
    python3 -m pip install Flask
``` 

#### 注意
以上内容为个人整理，如果有问题有出入或者你有更好的解决方法，还请赐教哦，感谢。


