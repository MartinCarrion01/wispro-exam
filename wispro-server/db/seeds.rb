# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first
Provider.destroy_all

isp_1 =Provider.create(name: "ISP1")
isp_2 = Provider.create(name: "ISP2")

isp_1.plans.create(description: "50 mb simetrico")
isp_1.plans.create(description: "30 mb asimetrico")
isp_2.plans.create(description: "100 mb asimetrico")

Client.create(username: "martin", password: "12345678", first_name: "Martin", last_name: "Carrion")