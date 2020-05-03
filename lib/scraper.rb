require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    
    students = []
    
    page.css(".student-card").each do |person|
      student = {
      :name => person.css(".student-name").text,
      :location => person.css(".student-location").text,
      :profile_url => person.css("a").attribute("href").value
      }
      students << student
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    
    students = {}
    
    links = page.css(".social-icon-container a").map do |icon| 
      icon.attribute("href").value
    end 
    
    links.each do |link|
      if link.include?("twitter.com")
        students[:twitter] = link
      elsif link.include?("linkedin.com")
        students[:linkedin] = link
      elsif link.include?("github.com")
        students[:github] = link
      elsif link.include?(".com")
        students[:blog] = link
      end 
    end
    
    students[:profile_quote] = page.css(".profile-quote").text
    students[:bio] = page.css("div.description-holder p").text
    
    students
  end 
      
end

