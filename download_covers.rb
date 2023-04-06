require 'selenium-webdriver'
require 'faraday'

def search_google(search_query)

  driver = Selenium::WebDriver.for :chrome
  search_url = "https://www.google.com/search?site=&tbm=isch&source=hp&biw=1873&bih=990&q=#{search_query}"
  images_url = []

  # Open the browser and navigate to Google search image
  #driver.navigate.to search_url
  driver.navigate.to search_url
  elements = driver.find_elements(class: 'rg_i')

  elements.each.with_index do |e, index|
    #Click on the image (to get the full size image)
    e.click
    sleep(1)

    #Get the full size image and put it's url in a array
    element = driver.find_elements(class: 'v4dQwb')

    #This is google site specific logic
    if index == 0
      big_img = element[0].find_element(class: 'n3VNCb')
    else
      big_img = element[1].find_element(class: 'n3VNCb')
    end
    images_url.push big_img.attribute("src")
    puts images_url

    begin
      # Get images data 
      response = Faraday.get(images_url[index], {}, {})

      #Write image to search.jpg file
      File.open("search#{index+1}.jpg",'w') do |f|
            f.puts response.body
      end
    rescue => exception
      puts 'Error saving image'
    end  

    # will only read 5 images
    if index == 5
      break
    end

  end
end

search_google 'Creating Documents with BusinessObjects 5.1 Book Cover'