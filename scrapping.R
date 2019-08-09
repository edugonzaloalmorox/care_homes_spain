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


# scrap informations

webs = links$web


#####




get_vars =  function(url){
  
  data <- read_html(url)

name =  data %>%  html_nodes(xpath = '/html/head/title/text()') %>% html_text() %>% as.data.frame() 
price =  data %>%  html_nodes(xpath = '//*[@id="sticky"]/div/div[1]') %>% html_text() %>% as.data.frame() 
capacity = data %>%  html_nodes(xpath = '/html/body/div[4]/div/div[1]/div[1]/div/div/div[1]') %>% html_text() %>% as.data.frame()
ownership = data %>% html_nodes(xpath = "/html/body/div[4]/div/div[1]/div[1]/div/div/div[2]") %>% html_text() %>% as.data.frame()
address  = data %>% html_nodes(xpath = "/html/body/div[4]/div/div[1]/div[2]/div[2]/div/a/span") %>% html_text() %>% as.data.frame()

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

test_webs = webs[1:5]

test_care_homes = get_vars(test_webs)





