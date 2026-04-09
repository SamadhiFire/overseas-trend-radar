# 海外舆情飞书雷达

一个低成本、零三方 Python 依赖的海外舆情自动监控脚本，面向音乐运营场景，支持：

- 三大厂牌官方动态与头部发行观察
- 音乐媒体资讯聚合
- 音乐 / AI / 流媒体产业动态
- 官方订阅价格快照比对
- 海外节庆提醒
- 社媒热点、文化跨界、国际政坛轻量观察
- 每条输出中文摘要 + 信源链接
- 飞书群机器人交互卡片推送

## 目录

- `main.py`: 主程序
- `run_report.sh`: 本地运行包装脚本
- `.github/workflows/daily-report.yml`: GitHub Actions 定时工作流
- `data/state.json`: 价格快照状态文件，首次运行后自动生成

## 使用方式

先给脚本可执行权限：

```bash
chmod +x /Users/mac/Downloads/overseas-trend-radar/main.py
chmod +x /Users/mac/Downloads/overseas-trend-radar/run_report.sh
```

### 1. 先预览，不推送

```bash
cd /Users/mac/Downloads/overseas-trend-radar
python3 main.py --dry-run --debug
```

### 2. 推送到飞书

```bash
cd /Users/mac/Downloads/overseas-trend-radar
FEISHU_WEBHOOK_URL='你的 webhook' python3 main.py --send
```

### 3. 指定日期试跑

```bash
cd /Users/mac/Downloads/overseas-trend-radar
python3 main.py --dry-run --date 2026-04-07 --debug
```

## GitHub Actions 方案

这是当前推荐方案，免费、稳定，也不依赖本机开机。

### 1. 把项目放到 GitHub 仓库

- 直接上传 [overseas-trend-radar](/Users/mac/Downloads/overseas-trend-radar) 整个目录

### 2. 配置仓库 Secret

- 打开 GitHub 仓库 `Settings` -> `Secrets and variables` -> `Actions`
- 新增 Secret: `FEISHU_WEBHOOK_URL`
- 值填你的飞书 webhook
- 建议新增 Secret: `DEEPL_API_KEY`
- 值填你的 DeepL API Key，这样中文翻译会稳定很多

### 3. 启用工作流

- 工作流文件是 [.github/workflows/daily-report.yml](/Users/mac/Downloads/overseas-trend-radar/.github/workflows/daily-report.yml)
- 它会在 `UTC 03:04` 运行，也就是北京时间每天 `11:04`
- 同时保留一个 `UTC 03:14` 的兜底触发；若当天已成功发送，则自动跳过，避免双发
- 也支持在 GitHub 页面手动点 `Run workflow` 立即试跑

### 4. 试运行

- 在 GitHub Actions 页面手动运行一次
- 可选输入 `report_date`
- 运行后会把 `last_report.md`、`last_card.json`、`state.json` 作为 artifact 上传，便于排查

## 当前信源

### 头部发行

- Sony Music 官方 feed
- Warner Music Group 官方 press release feed
- Universal Music Group 官方 feed
- Billboard / Rolling Stone / Pitchfork 的发行类内容作为补位信源

### 音乐资讯

- Billboard
- Rolling Stone Music News
- Pitchfork News

### 音乐 / AI 产业

- Music Business Worldwide
- TechCrunch AI
- The Verge AI
- Spotify / Apple Music / Amazon Music 官方价格页

### 节庆

- Nager.Date 公共假期 API

### 社媒热点

- Daily Dot Unclick
- Mashable RSS

### 文化 / 政治

- Variety Film
- ESPN Soccer
- The Hill
- NPR Politics

## 过滤逻辑

- 头部发行：优先三大官方；若官方当日过少，则用音乐媒体中的新歌、专辑、MV、预热类内容补位；过滤财报、任命、收购、事故与普通巡演新闻
- 音乐资讯：保留近 1-2 天内音乐媒体重点资讯
- AI / 产业：只保留 AI、流媒体、价格、版权、分发、平台相关内容
- 订阅价格：只有官方页面快照发生变化时才提示
- 节庆：按国家抓全年公共假期，默认抓 25-35 天预警和 1-3 天临期提醒
- 政治：只做轻量观察，默认最多展示 2 条
- 中文摘要：优先自动翻译并缓存，失败时回退为中文规则摘要
- 本地运行默认直接生成中文规则摘要；GitHub Actions 会额外开启远程翻译增强
- 若配置 `DEEPL_API_KEY`，GitHub Actions 会优先走 DeepL 正式翻译服务；否则退回免费翻译接口

## 建议部署方案

### 方案 A：GitHub Actions 定时

- 免费额度足够轻量日报
- 不依赖本机关机状态
- 最适合当前版本

### 方案 B：本机 `launchd` 定时

- 成本最低
- 适合只在个人电脑上跑
- 稳定性取决于设备是否在线

### 方案 C：云函数 / 轻量服务器

- 最稳，适合长期团队化
- 成本略高于前两者
- 后续适合加数据库、网页后台、多群推送

## 说明

- 这是一个适合今天上线试运行的 V1 版本
- “民众本地集体事件”目前优先用公共假期覆盖，后续可继续扩展到重点国家新闻源
- 如果你要，我下一步可以继续加：
  - 国家 / 语区维度输出
  - 西语区专项监控
  - 白名单艺人库
  - 飞书多群分发
  - 节庆民众集体行为事件信源
