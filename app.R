# app.R
library(shiny)
library(leaflet)
library(sf)
library(dplyr)

# Read China Province Map 
china <- st_read("C:/Users/15124/Downloads/china_provinces.geojson")
names(china)
head(china)

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



# 合并信息
china_data <- left_join(china, province_info, by = "NAME_1")

# -----------------------
# 2. Shiny界面
# -----------------------
ui <- fluidPage(
  titlePanel("Interactive Chinese Cultural Map"),
  sidebarLayout(
    sidebarPanel(
      h4("Province Info"),
      textOutput("province_name"),
      textOutput("folk_song"),
      textOutput("landscape")
    ),
    mainPanel(
      leafletOutput("map", height = 600)
    )
  )
)

# -----------------------
# 3. 服务器逻辑
# -----------------------
server <- function(input, output, session) {
  
  # 绘制地图
  output$map <- renderLeaflet({
    leaflet(china_data) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(
        layerId = ~NAME_1,
        fillColor = "lightblue",
        color = "white",
        weight = 1,
        highlight = highlightOptions(weight = 2, color = "blue"),
        label = ~NAME_1
      )
  })
  
  # 监听点击事件
  observeEvent(input$map_shape_click, {
    click <- input$map_shape_click
    if (is.null(click)) return()
    
    selected <- china_data %>% filter(NAME_1 == click$id)
    
    output$province_name <- renderText({
      paste("Province:", selected$NAME_1)
    })
    output$folk_song <- renderText({
      paste("Representative Folk Song:", selected$FolkSong)
    })
    output$landscape <- renderText({
      paste("Typical Landscape:", selected$Landscape)
    })
  })
}

# -----------------------
# 4. 启动应用
# -----------------------
shinyApp(ui, server)
