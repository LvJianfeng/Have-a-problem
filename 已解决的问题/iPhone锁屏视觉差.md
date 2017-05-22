## iPhone锁屏视觉差

#### 示例代码
```ruby
UIInterpolatingMotionEffect *leftRight = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
leftRight.minimumRelativeValue = @(-28.f);
leftRight.maximumRelativeValue = @(28.f);

UIInterpolatingMotionEffect *upDown = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
upDown.minimumRelativeValue = @(-28.f);
upDown.maximumRelativeValue = @(28.f);

UIMotionEffectGroup *mtGroup = [[UIMotionEffectGroup alloc] init];
mtGroup.motionEffects = @[leftRight, upDown];

[testImageView addMotionEffect:mtGroup];
```

#### 注意
以上内容为个人整理，如果有问题有出入或者你有更好的解决方法，还请赐教哦，感谢。


