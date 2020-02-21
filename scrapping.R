####################################
# Care homes in Spain
# August 2019
# @EdudinGonzalo
####################################

library(rvest)
library(tidyverse)


urls = sprintf("https://www.infoelder.com/cuidados-de-rehabilitacion-geriatricos-y-paliativos_1/residencias-de-ancianos_1/%s", 1:488)





# get the links of the care homes 



get_links = function(urls){
  
  data <- read_html(url)
  
  
  
  links = data %>% html_nodes("a") %>%  html_attr('href') %>% as.data.frame()
  
  names(links) = "web"
  
  
  check = links %>%
    filter(str_detect(web, "https://www.infoelder.com/cuidados-de-rehabilitacion-geriatricos-y-paliativos_1/residencias-de-ancianos_1/")) %>%
    mutate(id = gsub(".*_", "", web)) %>%
    filter(str_detect(id, "^i")) %>%
    group_by(id) %>%
    unique()
  
}

links_care = map(urls, get_links) 

df_care = map_df(links_care, bind_rows)

# save

write.csv(links, "data/processed/links.csv", row.names = FALSE)


links = read_csv("data/processed/links.csv")


# scrap informations

urls = links$web[[1]]


#####



df = read_html(urls)

name = df %>%
  html_nodes(xpath = '/html/head/title/text()') %>% 
  html_text() %>% 
  as.data.frame() 


places =df %>%
  html_nodes(xpath = 'mr-2 font semibold mb-1') %>% 
  html_text() %>% 
  as.data.frame() 

servicios  = df %>%
  html_nodes(xpath = '') %>% 
  html_text() %>% 
  as.data.frame() 



get_name =  function(url){
  
data <- read_html(url)

name =  data %>%  html_nodes(xpath = '/html/head/title/text()') %>% html_text() %>% as.data.frame() 

}

name = map(urls, get_name)


get_price =  function(url){
  
  data <- read_html(url)
  
  price =  data %>%  html_nodes(xpath = '//*[@id="sticky"]/div/div[1]') %>% html_text() %>% as.data.frame() 
  
}


get_capacity =  function(url){
  
  data <- read_html(url)
  
  capacity = data %>%  html_nodes(xpath = '/html/body/div[4]/div/div[1]/div[1]/div/div/div[1]') %>% html_text() %>% as.data.frame()
  
}



get_capacity2 =  function(url){
  
  data <- read_html(url)
  
  capacity = data %>%  html_nodes(xpath = '/html/body/div[4]/div/div[1]/div[1]/div/div/div[3]/span') %>% html_text() %>% as.data.frame()
  
}



get_ownership =  function(url){
  
  data <- read_html(url)
  
  ownership = data %>% html_nodes(xpath = "/html/body/div[4]/div/div[1]/div[1]/div/div/div[2]") %>% html_text() %>% as.data.frame()
  
}

get_address =  function(url){
  
  data <- read_html(url)
  
  address  = data %>% html_nodes(xpath = "/html/body/div[4]/div/div[1]/div[2]/div[2]/div/a/span") %>% html_text() %>% as.data.frame()
 
}



care_homes =   bind_cols(name,  
                           price, 
                           capacity,
                         ownership,
                         address) %>% as_tibble()

names(care_homes) = c("name",  
                           "price", 
                           "capacity",
                         "ownership",
                         "address")


return(care_homes)


}

test_webs = urls[1:50]



names = map(test_webs, get_vars)
df_names = map_df(names, bind_rows)


prices = map(test_webs, get_price)
df_prices = map_df(prices, bind_rows)


capacity = map(test_webs, get_capacity)
df_capacity = map_df(capacity, bind_rows)

ownership = map(test_webs, get_ownership)
df_ownership = map_df(ownership, bind_rows)

address = map(test_webs, get_address)
df_address = map_df(address, bind_rows)


test = bind_cols(df_names, df_prices, df_capacity, df_address) 

names(test) = c("name",  
                "price", 
                "capacity",
                "address")






