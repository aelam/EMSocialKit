# EMSocialKit

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 7.0+
支持Swift,动态库

## Installation

EMSocialKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'EMSocialKit'

```



## Author

Ryan Wang, wanglun02@gmail.com

## License

EMSocialKit is available under the MIT license. See the LICENSE file for more info.


## Changelogs

### 1.0.0 - 2016/11/30

#### EMSocialKit

* 移除所有静态库, 兼容动态库
* registerBuildInApps 方法淘汰
* 头文件整理 统一使用 #import <EMSocialKit/EMSocialKit.h>

#### UIImage-ResizeMagick@NoWarnings  0.0.3 升级到1.0.0
* module_name不能有下划线, 同时header_dir也改为与module_name一致了.  为了保证静态库,动态库引用头文件写法一致
* 头文件引用需要 #import <UIImageResizeMagick/UIImage+ResizeMagick.h>
  使用 #import <UIImage-ResizeMagick/UIImage+ResizeMagick.h>
  需要改为#import <UIImageResizeMagick/UIImage+ResizeMagick.h>
* 使用的地方 在项目 如果遇到问题 可以设置为0.0.3
