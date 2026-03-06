# iOS SelfImprovement 项目

一个 iOS 自我提升应用，帮助用户追踪健康值、记录正向活动、监控应用使用时间。

## 功能特性

### ✅ 已实现功能

#### 核心功能
- **健康值计算系统** - 基于娱乐时间和正向活动自动计算健康分数
- **圆形进度条动画** - 美观的健康值可视化展示
- **事件通知机制** - 组件间通信，实时数据同步
- **后台定时任务** - 自动更新健康值和生成每日总结

#### 活动管理
- **正向活动记录** - 支持添加活动标题、内容和多媒体
- **多媒体上传** - 支持图片和视频选择、拍照和录制
- **自定义活动类型** - 用户可自定义活动分类
- **活动记录列表** - 按类型筛选查看历史记录

#### 个人中心
- **用户统计** - 100分天数、总活动数统计
- **紧急联系人** - 设置紧急联系人信息
- **头像管理** - 支持上传和更换头像

#### UI/UX
- **动画效果** - 按钮点击动画、渐变动画、圆形进度条动画
- **自定义视图** - CircleProgressBar 圆形进度条
- **响应式布局** - 适配不同屏幕尺寸

### 🚧 待实现功能

#### 高优先级
- **GPUPixel 美颜相机** - 实时美颜滤镜效果
- **AvatarHelper 头像处理** - 根据健康值动态调整美颜程度

#### 低优先级
- **Screen Time API** - 应用使用时间监控（iOS 限制较多）

## 技术栈

- **语言**: Swift 5
- **UI框架**: UIKit
- **数据库**: SQLite
- **后台任务**: BackgroundTasks Framework
- **图片处理**: PhotosUI, AVFoundation

## 项目结构

```
SelfImprovement/
├── Controllers/           # 视图控制器
│   ├── HomeViewController.swift
│   ├── ActivityRecordViewController.swift
│   ├── AddActivityViewController.swift
│   ├── CalendarViewController.swift
│   ├── ProfileViewController.swift
│   └── ...
├── Models/               # 数据模型
│   ├── ActivityRecord.swift
│   ├── HealthStatus.swift
│   ├── CustomActivityType.swift
│   └── ...
├── Repository/           # 数据仓库
│   ├── HealthScoreRepository.swift
│   ├── ActivityRecordRepository.swift
│   └── ...
├── Utils/                # 工具类
│   ├── DatabaseHelper.swift
│   ├── EventCenter.swift
│   ├── MediaPickerManager.swift
│   ├── BackgroundTaskManager.swift
│   └── ...
├── Views/                # 自定义视图
│   └── CircleProgressBar.swift
└── AppDelegate.swift     # 应用入口

```

## 核心组件

### EventCenter
事件中心，用于组件间通信，替代 Android 的 LiveEventBus。

```swift
// 发送事件
EventCenter.shared.post(AppConfig.EVENT_SCORE_CHANGED, value: score)

// 监听事件
EventCenter.shared.observe(AppConfig.EVENT_SCORE_CHANGED, observer: self) { score in
    // 处理分数变化
}
```

### MediaPickerManager
多媒体选择管理器，支持图片和视频选择。

```swift
let picker = MediaPickerManager()
picker.delegate = self
picker.showMediaOptions(from: self, allowVideo: true)
```

### BackgroundTaskManager
后台任务管理器，定时更新健康值。

```swift
// 注册后台任务
BackgroundTaskManager.shared.registerBackgroundTasks()

// 调度任务
BackgroundTaskManager.shared.scheduleHealthScoreUpdate()
```

## 安装说明

1. 克隆项目
```bash
git clone https://github.com/xm317392642/iosSelfImprovement.git
```

2. 打开 `SelfImprovement.xcodeproj`

3. 配置后台任务权限（在 Info.plist 中添加）：
```xml
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
    <string>com.selfimprovement.healthscore.update</string>
    <string>com.selfimprovement.dailysummary.update</string>
</array>
```

4. 运行项目

## 数据库结构

### health_status
- id: INTEGER PRIMARY KEY
- date: TEXT UNIQUE
- health_score: REAL
- entertainment_time: INTEGER
- activity_count: INTEGER

### activity_record
- id: INTEGER PRIMARY KEY
- title: TEXT
- content: TEXT
- type: TEXT
- date: TEXT
- images: TEXT (JSON)
- video: TEXT
- location: TEXT
- is_custom: INTEGER
- original_type: TEXT
- created_at: REAL

### custom_activity_type
- id: INTEGER PRIMARY KEY
- name: TEXT UNIQUE
- original_type: TEXT
- icon_path: TEXT
- color: TEXT
- created_at: REAL

## 健康值计算规则

```
健康值 = 基础分(80) + 正向活动加分 - 娱乐时间扣分

正向活动加分 = 活动数量 × 5分
娱乐时间扣分 = (娱乐分钟数 ÷ 30) × 5分
```

## 对应 Android 项目

Android 版本: [D:\project\dongleme](D:\project\dongleme)

## 版本历史

### v1.0 (2026-03-05)
- ✅ 实现事件通知机制
- ✅ 实现多媒体上传功能
- ✅ 实现自定义活动类型
- ✅ 优化 UI 动画效果
- ✅ 实现后台定时任务
- ✅ 完善个人中心功能

## 许可证

MIT License
