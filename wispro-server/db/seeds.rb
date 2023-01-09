# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first
Provider.destroy_all
Plan.destroy_all
Client.destroy_all
Subscription.destroy_all
SubscriptionRequest.destroy_all
SubscriptionChangeRequest.destroy_all

isp_1 =Provider.create(name: "ISP1")
isp_2 = Provider.create(name: "ISP2")
isp_3 = Provider.create(name: "ISP3")
isp_4 = Provider.create(name: "ISP4")
isp_5 = Provider.create(name: "ISP5")


plan_1 = isp_1.plans.create(description: "50 mb simetrico")
plan_2 = isp_2.plans.create(description: "100 mb asimetrico")
plan_3 = isp_3.plans.create(description: "100 mb simetrico")
plan_4 = isp_1.plans.create(description: "10 mb simetrico")
plan_5 = isp_4.plans.create(description: "10 mb simetrico")
plan_6 = isp_5.plans.create(description: "10 mb simetrico")

client = Client.create(username: "martin", password: "12345678", first_name: "Martin", last_name: "Carrion")

#Crea una suscripcion activa para el cliente 
sub_1 = Subscription.create(client: client, plan: plan_1)

#Crea solicitud pendiente para un cliente
SubscriptionRequest.create(client: client, plan: plan_3)

#Crea solicitudes rechazadas para el cliente
SubscriptionRequest.create(client: client, plan: plan_1, status: "rejected")
SubscriptionRequest.create(client: client, plan: plan_2, status: "rejected")

#Crea solicitud pendiente para un cliente para aprobarla
SubscriptionRequest.create(client: client, plan: plan_5)

#Crea solicitud que no puede aprobar
SubscriptionRequest.create(client: client, plan: plan_6)
