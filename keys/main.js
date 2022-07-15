require('dotenv').config()

const { Client } = require('discord.js')
const { MongoClient } = require('mongodb')
const assert = require('assert')
const Bot = new Client({ intents: ["GUILDS", "GUILD_MESSAGES"] })
var dbConnect = false, db;

async function DBconnect() {
    const uri = process.env.URI
    const client = new MongoClient(uri)
    try {
        await client.connect(function(err, client){
            console.log('Mongodb connected!')
            db = client.db('Keys')
            dbConnect = true;
            Bot.login(process.env.TOKEN)
        })
    } catch (e) {
        console.error(e)
    } finally {
        await client.close(function(err){
            console.log('Mongodb disconnected!')
            dbConnect = false;
            db = null;
        })
    }
}

Bot.on('ready', async () => {
    Bot.user.setPresence({
        activities: [{ name: "Bot running through node.js", type: "WATCHING" }],
        status: "online"
    })
    console.log(`Running bot as "${Bot.user.tag}" and connects ${Bot.guilds.cache.size} server`)
})

Bot.on('error', (err) => {
    console.log('Whoa! Something went error')
    db = null;
    dbConnect = false;
})

DBconnect().catch(console.error)