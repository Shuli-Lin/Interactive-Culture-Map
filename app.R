# app.R
install.packages("readxl")

library(shiny)
library(leaflet)
library(sf)
library(dplyr)
library(readxl)
library(shinydashboard)
# Read China Province Map 
china <- st_read("data/china_provinces.geojson")
names(china)
head(china)
corrections <- c(
  "Guangzhou Province" = "Guangdong Province",
  "Ningxia Ningxia Hui Autonomous Region" = "Ningxia Hui Autonomous Region"
)

china <- china %>%
  mutate(shapeName = ifelse(shapeName %in% names(corrections),
                            corrections[match(shapeName, names(corrections))],
                            shapeName))
china <- china %>%
  mutate(Province_CN = case_when(
    shapeName == "Anhui Province" ~ "安徽省",
    shapeName == "Beijing Municipality" ~ "北京市",
    shapeName == "Chongqing Municipality" ~ "重庆市",
    shapeName == "Fujian Province" ~ "福建省",
    shapeName == "Gansu Province" ~ "甘肃省",
    shapeName == "Guangdong Province" ~ "广东省",
    shapeName == "Guangxi Zhuang Autonomous Region" ~ "广西壮族自治区",
    shapeName == "Guizhou Province" ~ "贵州省",
    shapeName == "Hainan Province" ~ "海南省",
    shapeName == "Hebei Province" ~ "河北省",
    shapeName == "Heilongjiang Province" ~ "黑龙江省",
    shapeName == "Henan Province" ~ "河南省",
    shapeName == "Hong Kong Special Administrative Region" ~ "香港特别行政区",
    shapeName == "Hubei Province" ~ "湖北省",
    shapeName == "Hunan Province" ~ "湖南省",
    shapeName == "Inner Mongolia Autonomous Region" ~ "内蒙古自治区",
    shapeName == "Jiangsu Province" ~ "江苏省",
    shapeName == "Jiangxi Province" ~ "江西省",
    shapeName == "Jilin Province" ~ "吉林省",
    shapeName == "Liaoning Province" ~ "辽宁省",
    shapeName == "Macau Special Administrative Region" ~ "澳门特别行政区",
    shapeName == "Ningxia Hui Autonomous Region" ~ "宁夏回族自治区",
    shapeName == "Qinghai Province" ~ "青海省",
    shapeName == "Shaanxi Province" ~ "陕西省",
    shapeName == "Shandong Province" ~ "山东省",
    shapeName == "Shanghai Municipality" ~ "上海市",
    shapeName == "Shanxi Province" ~ "山西省",
    shapeName == "Sichuan Province" ~ "四川省",
    shapeName == "Tianjin Municipality" ~ "天津市",
    shapeName == "Tibet Autonomous Region" ~ "西藏自治区",
    shapeName == "Xinjiang Uyghur Autonomous Region" ~ "新疆维吾尔自治区",
    shapeName == "Yunnan Province" ~ "云南省",
    shapeName == "Zhejiang Province" ~ "浙江省",
    shapeName == "Taiwan Province" ~ "台湾省",
    TRUE ~ shapeName # 默认保留原名
  ))

# Check the result
head(china[, c("shapeName", "Province_CN")])
head(china)
# Read provinces information
province_info <- read_excel("data/province_info.xlsx")
head(province_info)

# Combine the info-table with shp file
china_data <- china %>%
  left_join(province_info, by = "Province_CN")

st_write(china, "data/china_provinces_corrected.geojson")

civilization_table <- read_excel("data/civilization.xlsx")
china_civilization <- left_join(china, civilization_table, by = "Province_CN")
st_write(china_civilization, "data/china_civilization.geojson", delete_dsn = TRUE)

ui <- dashboardPage(
  dashboardHeader(title = "中国地方文化地图"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("民歌地图 🎵", tabName = "folk", icon = icon("music")),
      menuItem("文明地图 🏺", tabName = "civilization", icon = icon("globe-asia"))
    )
  ),
  dashboardBody(
    tabItems(
      # 🎵 民歌地图页面
      tabItem(tabName = "folk",
              fluidRow(
                box(width = 8,
                    leafletOutput("folkMap", height = 600)),
                box(width = 4,
                    title = "🎶 省份民歌播放",
                    textOutput("selected_province"),
                    textOutput("selected_song"),
                    uiOutput("audio_player"))
              )
      ),
      
      # 🏺 文明地图页面
      tabItem(tabName = "civilization",
              fluidRow(
                box(width = 8,
                    leafletOutput("civilizationMap", height = 600)),
                box(width = 4,
                    title = "🏺 文明类型信息",
                    textOutput("selected_civ_province"),
                    textOutput("selected_civ_type"),
                    textOutput("selected_civ_intro"),
                    textOutput("selected_civ_pinyin"))
              )
      )
    )
  )
)

# -------------------------------
# 3️⃣ 服务器逻辑
# -------------------------------
# 让Shiny知道音频文件在哪
addResourcePath("audio", "data/audio")

output$audio_player <- renderUI({
  tags$audio(
    controls = TRUE,
    src = paste0("audio/", info$AudioFile),
    type = "audio/mp3"
  )
})

server <- function(input, output, session) {
  
  # 民歌地图
  output$folkMap <- renderLeaflet({
    leaflet(china_data) %>%
      addTiles() %>%
      addPolygons(
        fillColor = "orange",
        color = "white",
        weight = 1,
        opacity = 1,
        fillOpacity = 0.7,
        layerId = ~Province_CN,
        label = ~paste0(Province_CN, " - ", FolkSong_CN)
      )
  })
  
  observeEvent(input$folkMap_shape_click, {
    province <- input$folkMap_shape_click$id
    info <- china_data %>% filter(Province_CN == province)
    
    output$selected_province <- renderText({ paste("省份：", info$Province_CN) })
    output$selected_song <- renderText({ paste("歌曲：", info$FolkSong_CN) })
    output$audio_player <- renderUI({
      tags$audio(
        controls = TRUE,
        src = paste0("data/audio/", info$AudioFile),
        type = "audio/mp3"
      )
    })
  })
  
  # 文明地图
  output$civilizationMap <- renderLeaflet({
    leaflet(china_civilization) %>%
      addTiles() %>%
      addPolygons(
        fillColor = "lightblue",
        color = "white",
        weight = 1,
        opacity = 1,
        fillOpacity = 0.7,
        layerId = ~Province_CN,
        label = ~paste0(Province_CN, " - ", `文明类型(Civilization Type)`)
      )
  })
  
  observeEvent(input$civilizationMap_shape_click, {
    province <- input$civilizationMap_shape_click$id
    info <- china_civilization %>% filter(Province_CN == province)
    
    output$selected_civ_province <- renderText({ paste("省份：", info$Province_CN) })
    output$selected_civ_type <- renderText({ paste("文明类型：", info$`文明类型(Civilization Type)`) })
    output$selected_civ_intro <- renderText({ paste("文化简介：", info$`中文文化简介(CN Overview)`) })
    output$selected_civ_pinyin <- renderText({ paste("拼音：", info$汉语拼音) })
  })
}

# -------------------------------
# 4️⃣ 启动应用
# -------------------------------
shinyApp(ui, server)





