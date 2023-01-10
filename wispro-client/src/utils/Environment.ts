import * as dotenv from 'dotenv'
dotenv.config()

export const environment = {
    api_url: process.env.API_URL || "http://127.0.0.1:3000/api/v1/"
}