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

  unless title == "Comparateur gratuit des supermarch??s"

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

#Market.create!(brand: "Auchan", address: "48, Bis Rue Saint S??bastien Lille", price_level: 258 / average, opening_hours: "pas d'horaires", phone_number: "0320568938", ping_gris: false)
# Market.create!(brand: "Auchan", address: "5, Rue de Saint Andr?? Lille", price_level: 263 / average, opening_hours: "pas d'horaires", phone_number: "0366191023", ping_gris: false)
# Market.create!(brand: "Carrefour Market", address: "Rue du Pr?? Catelan 59110 La Madeleine", price_level: 240 / average, opening_hours: "pas d'horaires", phone_number: "0320316964", ping_gris: false)
# Market.create!(brand: "Leclerc", address: "2, Place Louise de Bettignies Lille", price_level: 228 / average, opening_hours: "pas d'horaires", phone_number: "0967351502", ping_gris: false)
# Market.create!(brand: "Auchan", address: "9, Rue de Roubaix Lille", price_level: 260 / average, opening_hours: "pas d'horaires", phone_number: "0359305930", ping_gris: false)
# Market.create!(brand: "Auchan", address: "53, Rue Pierre Mauroy Lille", price_level: 253 / average, opening_hours: "pas d'horaires", phone_number: "0366190763", ping_gris: false)
# Market.create!(brand: "Auchan", address: "42, Rue Molinel Lille", price_level: 228 / average, opening_hours: "pas d'horaires", phone_number: "0962614920", ping_gris: false)
# Market.create!(brand: "Auchan", address: "6, Rue Palais Rihour Lille", price_level: 255 / average, opening_hours: "pas d'horaires", phone_number: "0366190983", ping_gris: false)
# Market.create!(brand: "Intermarch?? Express", address: "89-95, Rue Nationale Lille", price_level: 247 / average, opening_hours: "pas d'horaires", phone_number: "0328381430", ping_gris: false)
# Market.create!(brand: "Auchan", address: "26, Boulevard de la Libert?? Lille", price_level: 248 / average, opening_hours: "pas d'horaires", phone_number: "0366191021", ping_gris: false)
# Market.create!(brand: "Auchan", address: "33, Avenue JF Kennedy La Madeleine", price_level: 258 / average, opening_hours: "pas d'horaires", phone_number: "0366190989", ping_gris: false)
# Market.create!(brand: "Auchan", address: "43, Boulevard Vauban Lille", price_level: 258 / average, opening_hours: "pas d'horaires", phone_number: "0366190845", ping_gris: false)
# Market.create!(brand: "Auchan", address: "171, Rue Nationale Lille", price_level: 238 / average, opening_hours: "pas d'horaires", phone_number: "0366190675", ping_gris: false)
# Market.create!(brand: "Leclerc", address: "107, Rue Solf??rino Lille", price_level: 228 / average, opening_hours: "pas d'horaires", phone_number: "0320463609", ping_gris: false)
# Market.create!(brand: "Intermarch?? Express", address: "75-77, Rue L??on Gambetta Lille", price_level: 250 / average, opening_hours: "pas d'horaires", phone_number: "0328051905", ping_gris: false)
# Market.create!(brand: "Auchan ", address: "323, Rue du Pr??sident Hoover Lille", price_level: 260 / average, opening_hours: "pas d'horaires", phone_number: "0366191087", ping_gris: false)
# Market.create!(brand: "Carrefour", address: "281, Rue L??on Gambetta Lille", price_level: 281 / average, opening_hours: "pas d'horaires", phone_number: "0320147900", ping_gris: false)
# Market.create!(brand: "Auchan", address: "14, Place Nouvelle Aventure Lille", price_level: 237 / average, opening_hours: "pas d'horaires", phone_number: "0320388380", ping_gris: false)
# Market.create!(brand: "Auchan", address: "35, Rue d???Isly Lille", price_level: 260 / average, opening_hours: "pas d'horaires", phone_number: "0366191085", ping_gris: false)
# Market.create!(brand: "Leclerc", address: "41, Boulevard de la Moselle Lille", price_level: 243 / average, opening_hours: "pas d'horaires", phone_number: "0320090202", ping_gris: false)
# Market.create!(brand: "Intermarch?? Express", address: "105, Rue du Faubourg de Roubaix Lille", price_level: 260 / average, opening_hours: "pas d'horaires", phone_number: "0320706600", ping_gris: false)
# Market.create!(brand: "U Express", address: "51, Rue du Buisson Lille", price_level: 268 / average, opening_hours: "pas d'horaires", phone_number: "0320552593", ping_gris: false)
# Market.create!(brand: "Leclerc", address: "94, Rue de Lannoy Lille", price_level: 226 / average, opening_hours: "pas d'horaires", phone_number: "0320617617", ping_gris: false)
# Market.create!(brand: "Carrefour Market", address: "268, Rue Pierre Legrand Fives Lille", price_level: 235 / average, opening_hours: "pas d'horaires", phone_number: "0980980986", ping_gris: false)
# Market.create!(brand: "Auchan", address: "237, All. Cl??mentine Deman Lille", price_level: 258 / average, opening_hours: "pas d'horaires", phone_number: "0366191294", ping_gris: false)

url = URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=50.630,3.060&radius=2500&type=supermarket&key=#{ENV['GOOGLE_API_KEY']}")

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Get.new(url)

response = https.request(request)

rep = JSON.parse(response.read_body)

results = rep["results"]

results.each do |result|
  puts "========= MARKET LAT LNG NAME GOOGLE_ID ========="
  sleep 2
  lat = result["geometry"]["location"]['lat']
  lng = result["geometry"]["location"]['lng']
  name = result["name"]
  google_id = result["place_id"]
  if name != "Garden &shop (anciennement le Minh)" || name != "Picard"
    geo_localization = "#{lat},#{lng}"
    location = Geocoder.search(geo_localization).first
    address = "#{location.house_number} #{location.street} #{location.city}"
    Market.create!(brand: name, latitude: lat, longitude: lng, google_id: google_id, address: address, ping_gris: true)
  end
end

Market.all.each do |market|
  sleep 12
  url = URI("https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Cformatted_phone_number%2Copening_hours&place_id=#{market.google_id}&key=#{ENV['GOOGLE_API_KEY']}")

  https = Net::HTTP.new(url.host, url.port)
  https.use_ssl = true

  request = Net::HTTP::Get.new(url)

  response = https.request(request)

  rep = JSON.parse(response.read_body)

puts "========= CHARGEMENT DES PHONES GOOGLE (sans espace :P vic ) ========="
  if rep["formatted_phone_number"] != nil || market.phone_number == nil
    formatted_phone_number = rep["result"]["formatted_phone_number"]
    num_whithout_spaces = formatted_phone_number.gsub(/\s+/, "")
    market.update(phone_number: num_whithout_spaces)
  end

  puts "========= CHARGEMENT DES HORAIRES ========="
  if rep["opening_hours"] != nil || market.opening_hours == nil
    opening_hour = rep["result"]["opening_hours"]["weekday_text"].join(" ")
    market.update(opening_hours: opening_hour)
  else
    market.update(opening_hours: "pas d'horaires")
  end
end

puts "========= GENERATION DES PRODUITS ========="

Product.create!(name: "cristalline 6x1,5L", mean_price: "1.20")
Product.create!(name: "Coca-Cola 1,75L", mean_price: "1.95")
Product.create!(name: "Nutella P??te ?? tartiner 1kg", mean_price: "5.59")
Product.create!(name: "Caprice des Dieux 300g", mean_price: "3.25")
Product.create!(name: "Nutella P??te ?? tartiner 825g", mean_price: "4.65")
Product.create!(name: "Pr??sident Beurre doux 250g", mean_price: "1.49")
Product.create!(name: "Carte Noire Caf?? 3x250g", mean_price: "11.09")
Product.create!(name: "Catsan Liti??re Hygi??ne Plus 10L", mean_price: "4.89")
Product.create!(name: "Lotus Confort Papier Toilette x24", mean_price: "9.59")
Product.create!(name: "Sodebo Salade & Cie Manhattan", mean_price: "2.79")
Product.create!(name: "Herta Le Bon Paris 4 tranches", mean_price: "3.0")
Product.create!(name: "P??tes coquillettes BARILLA", mean_price: "1.09")
Product.create!(name: "P??tes coquillettes PANZANI", mean_price: "1.95")
Product.create!(name: "P??tes penne rigate BARILLA", mean_price: "1.05")
Product.create!(name: "P??tes spaghetti PANZANI", mean_price: "1.05")
Product.create!(name: "P??tes torti PANZANI", mean_price: "1.99")
Product.create!(name: "P??tes linguine collezione BARILLA", mean_price: "1.19")
Product.create!(name: "P??tes spaghetti bio BARILLA", mean_price: "1.85")
Product.create!(name: "Filets de poulet blanc LE GAULOIS x2", mean_price: "4.65")
Product.create!(name: "Escalopes de dinde LE GAULOIS x2", mean_price: "10.19")
Product.create!(name: "Cordon bleu poulet LE GAULOIS x2", mean_price: "2.05")
Product.create!(name: "Cordon bleu de dinde PERE DODU x2", mean_price: "2.29")
Product.create!(name: "Steak hach?? viande bovine 5% MG CHARAL x2", mean_price: "5.10")
Product.create!(name: "Steak hach?? pur b??uf 15% MG CHARAL x10", mean_price: "1.09")
Product.create!(name: "Viande Bovine: Pav?? ?? griller CHARAL x2", mean_price: "8.21")
Product.create!(name: "Huile Isio 4 ISIO 4", mean_price: "3.69")
Product.create!(name: "Huile d'olive vierge extra PUGET 1l", mean_price: "8.79")
Product.create!(name: "Sel fin iod?? CEREBOS", mean_price: "0.88")
Product.create!(name: "Sel de Gu??rande Label Rouge LE GUERANDAIS", mean_price: "2.49")
Product.create!(name: "Poivre et ??pices DUCROS", mean_price: "2.05")
Product.create!(name: "Blanc de poulet r??duit en sel FLEURY MICHON x2", mean_price: "2.69")
Product.create!(name: "Ketchup HEINZ 250g", mean_price: "1.16")
Product.create!(name: "Ketchup AMORA", mean_price: "1.45")
Product.create!(name: "Moutarde ancienne MAILLE", mean_price: "2.95")
Product.create!(name: "Moutarde douce AMORA", mean_price: "1.09")
Product.create!(name: "Parmigiano Reggiano AOP CASA AZZURRA", mean_price: "1.29")
Product.create!(name: "Fromage ?? Tartiner Nature ST MORET", mean_price: "2.25")
Product.create!(name: "Fromage Cr??me ?? tartiner KIRI", mean_price: "2.79")
Product.create!(name: "Fromage R??p?? Emmental PRESIDENT Maxi Format", mean_price: "1.99")
Product.create!(name: "Fromage R??p?? Comt?? AOP ENTREMONT", mean_price: "2.59")
Product.create!(name: "Mozzarella GALBANI", mean_price: "1.19")
Product.create!(name: "SAUCE TOMATES BASILIC BARILLA 400g", mean_price: "1.55")
Product.create!(name: "SAUCE BOLOGNAISE RICHE BARILLA 400g", mean_price: "2.99")
Product.create!(name: "SAUCE PESTO ROSSO BARILLA", mean_price: "2.19")
Product.create!(name: "Cr??me Epaisse L??g??re 15% Mat.Gr. BRIDELICE 20cl", mean_price: "0.74")
Product.create!(name: "Cr??me Semi-??paisse L??g??re 18% Mat.Gr. BRIDELICE", mean_price: "2.89")
Product.create!(name: "P??tes Fra??ches Gnocchi ?? Po??ler LUSTUCRU SELECTION", mean_price: "1.49")
Product.create!(name: "Box Fusilli bolognaise SODEBO", mean_price: "2.59")
Product.create!(name: "Lardons fum??s sel r??duit HERTA - 25% sel", mean_price: "2.19")
Product.create!(name: "??ufs Bio Calibre Moyen Sans-Antibiotique Sans OGM LOUE x6", mean_price: "5.69")
Product.create!(name: "??ufs Calibre Moyen Label Rouge Sans OGM LOUE x12", mean_price: "4.79")
Product.create!(name: "??ufs Gros Coque Calibre Gros LUSTUCRU x6", mean_price: "2.09")
Product.create!(name: "Biscuits fourr??s au chocolat au bl?? complet Prince LU", mean_price: "3.79")
Product.create!(name: "Blanc de poulet r??duit en sel FLEURY MICHON x2", mean_price: "2.69")
Product.create!(name: "Ketchup HEINZ 250g", mean_price: "1.16")
Product.create!(name: "Ketchup AMORA", mean_price: "1.45")
Product.create!(name: "Moutarde ancienne MAILLE", mean_price: "2.95")

puts "========= AJOUT DES MARKET PRODUCTS ========="

Market.all.each do |market|
  random = [0.92, 1.12, 0.98, 1.14, 1.20, 0.89, 0.95, 1.15, 1.12, 1.1].sample
  if market.price_level == nil
    Product.all.each do |product|
      random_price_level = random
      MarketProduct.create!(product_id: product.id, market_id: market.id, price: product.mean_price * random_price_level)
      market.update(price_level: random_price_level)
    end
  else
    Product.all.each do |product|
      MarketProduct.create!(product_id: product.id, market_id: market.id, price: product.mean_price * market.price_level)
    end
  end
end

puts "========= JE SUIS ECOEURE ========="
