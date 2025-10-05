# Interactive-Culture-Map

---

## 🇨🇳 中国文明与民歌交互式地图

### Interactive Dashboard of Chinese Civilization and Folk Songs

---

### 🧭 项目简介 | Project Overview

这个项目旨在通过一个 **R Shiny 交互式仪表板（dashboard）**，帮助外国学习者了解中国各省的地理与文化差异。
用户可以在地图上点击任意省份，查看当地的代表民歌、地貌特征以及其所属的文明类型（农耕、游牧或渔猎文明）。

This project presents an **interactive R Shiny dashboard** designed to help international learners explore the geographic and cultural diversity of China.
Users can click any province on the map to view its representative folk song, major landform, and the type of civilization it historically belongs to (agrarian, nomadic, or fishing-hunting).

---

### 🗺️ 功能特色 | Key Features

* 点击省份，弹出省名、拼音、中英文介绍
* 播放代表性民歌（通过在线音频链接）
* 显示省份的地貌与DEM地形背景
* 分类展示各省的文明类型演变
* 后续计划加入气候、饮食与建筑风格等文化要素

**Features:**

* Clickable provinces showing names, pinyin, and bilingual cultural descriptions
* Playable representative folk songs (via online URLs)
* Integration of DEM-based terrain visualization
* Cultural layer classifying provinces by civilization type
* Future plans include adding climate, cuisine, and architecture themes

---

### 🧰 技术框架 | Technical Stack

| 模块    | 使用工具                      | 说明                   |
| ----- | ------------------------- | -------------------- |
| 地图展示  | `leaflet`, `sf`, `terra`  | 读取中国省界矢量文件，加载交互地图    |
| 数据可视化 | `shiny`, `shinydashboard` | 构建交互式仪表板界面           |
| 地形叠加  | `raster`, `elevatr`       | 下载并显示DEM地形数据         |
| 数据管理  | `dplyr`, `readxl`         | 从Excel或CSV中读取民歌与文明信息 |
| 音频播放  | HTML音频标签 + Shiny UI       | 通过在线URL播放民歌          |

**Technical Stack:**

| Module          | Tools Used                | Description                                          |
| --------------- | ------------------------- | ---------------------------------------------------- |
| Map Rendering   | `leaflet`, `sf`, `terra`  | Display provincial boundaries and interactive layers |
| Dashboard UI    | `shiny`, `shinydashboard` | Build the interactive user interface                 |
| Terrain Layer   | `raster`, `elevatr`       | Fetch and visualize DEM elevation data               |
| Data Management | `dplyr`, `readxl`         | Manage data from Excel or CSV files                  |
| Audio Playback  | HTML + Shiny              | Play songs via external online links                 |

---

### 📁 数据来源 | Data Sources

* 中国省界矢量数据（GeoJSON）：[GADM](https://gadm.org) 或 [Natural Earth](https://www.naturalearthdata.com)
* DEM数据：`elevatr` 包调用的 SRTM 或 ASTER GDEM
* 民歌与文明类型信息：自定义 Excel 文件

**Data Sources:**

* Chinese provincial boundaries (GeoJSON): GADM or Natural Earth
* DEM data: SRTM or ASTER GDEM via `elevatr` package
* Folk songs & civilization types: Custom dataset (`province_info.xlsx`)

---

### 🚀 使用方法 | How to Use

1. 克隆项目到本地

2. 在 R 中打开项目并安装依赖包
   
   ```r
   install.packages(c("shiny", "shinydashboard", "leaflet", "sf", "terra", "dplyr", "readxl"))
   ```

3. 运行主程序
   
   ```r
   shiny::runApp("app.R")
   ```

4. 打开浏览器查看效果

---

### 🌏 项目结构 | Project Structure

```
Interactive-Culture-Map/
│
├── app.R                     # Shiny 主程序
├── data/
│   ├── china_provinces.geojson
│   ├── province_info.xlsx     # 含省名、拼音、民歌、文明类型、音频链接
│   └── dem/                   # 存放DEM地形数据
│
├── www/                       # 静态资源（图片、图标、样式）
│   └── audio/                 # 可选，本地音频文件
│
├── README.md
└── LICENSE
```

---

### 🔮 未来计划 | Future Development

* 添加可切换的文明类型图层（农耕、游牧、渔猎）
* 增加多媒体内容（传统服饰、建筑照片、方言语音）
* 开发多语言界面（中文、英文、荷兰语）
* 提供移动端兼容版本

**Future Plans:**

* Civilization layer switch (agrarian, nomadic, fishing-hunting)
* Multimedia expansion (clothing, architecture, dialect samples)
* Multilingual interface (Chinese, English, Dutch)
* Mobile-friendly version

---

### 🙌 致谢 | Acknowledgements

感谢开源社区的工具与数据支持，也感谢所有参与收集民歌与文化信息的朋友。

Thanks to the open-source community for tools and datasets, and to all contributors who helped collect folk songs and cultural materials.
