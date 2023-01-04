# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'json'
require 'open-uri'
require "uri"
require "net/http"
require "nokogiri"

Ticket.destroy_all
puts "========= DESTRUCTION DES TICKETS ========="
Market.destroy_all
puts "========= DESTRUCTION DES MARKETS ========="
Product.destroy_all
puts "========= DESTRUCTION DES PRODUCTS ========="
User.destroy_all
puts "========= DESTRUCTION DES USERS ========="

puts "========= CREATION DES 4 USERS ========="
user_1 = User.create!(email: "victor@email.com", password: "victor1234")
file =  URI.open("app/assets/images/avatar-victor-min.png")
user_1.photo.attach(io: file, filename: "avatar-victor.png", content_type: "image/png")
user_1.save
user_2 = User.create!(email: "mario@email.com", password: "mario1234")
file =  URI.open("app/assets/images/avatar_mario-min.png")
user_2.photo.attach(io: file, filename: "avatar-mario.png", content_type: "image/png")
user_2.save
user_3 = User.create!(email: "alassane@email.com", password: "alassane1234")
file =  URI.open("app/assets/images/avatar-alassane.png")
user_3.photo.attach(io: file, filename: "avatar-alassane.png", content_type: "image/png")
user_3.save
user_4 = User.create!(email: "maxence@email.com", password: "maxence1234")
file =  URI.open("app/assets/images/avatar-maxence-min.png")
user_4.photo.attach(io: file, filename: "avatar-maxence.png", content_type: "image/png")
user_4.save
price_level = [258, 263, 240, 228, 260, 253, 228, 255, 247, 248, 258, 258, 238, 228, 250, 260, 281, 237, 260, 243, 260, 268, 226, 235, 258]
average = price_level.sum / price_level.size.to_f


puts "========= CREATION DES MARKETS SCRAPE ========="

market_id = 2

7000.times do
  url = "https://www.quechoisir.org/carte-interactive-drives-n21243/drive-magasin-dm#{market_id}/"

  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)

  title = html_doc.search("h1").first.text.strip

  unless title == "Comparateur gratuit des supermarchés"

    brand = html_doc.search('b').first.text.strip
    address1 = html_doc.search('b').first.next
    address1 = address1.next while address1.name != 'br'

    address1 = address1.next
    address2 = address1.next.next.text.split.join(' ')
    address = "#{address1.text.split.join(' ')} #{address2}"

    week = ''

    html_doc.search('.geo-table').first.children.each do |elem|
      week += "#{elem.children.first.text.strip}:#{elem.children[1].text.strip}/"
    end

    price = html_doc.search('.geo-table')[1].children[1].children[1].text.strip.split.first.to_i

    Market.create!(brand: brand, address: address, opening_hours: week, price_level: price, ping_gris: false )

    puts "#{market_id} :#{address} added"
  end
  market_id += 1
  sleep(1)
end
