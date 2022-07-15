require('dotenv').config()

const { REST } = require('@discordjs/rest')
const { Routes } = require('discord-api-types/v10')
const { SlashCommandBuilder } = require('@discordjs/builders');
const { Client } = require('discord.js')
const { MongoClient } = require('mongodb')
const Bot = new Client({ intents: ["GUILDS", "GUILD_MESSAGES"] })
var KeyDatabases;
const commands = [];

(() => {
    const Data1 = new SlashCommandBuilder()
        .setName('key')
        .setDescription('Generating key hub or checking status key')
        .addSubcommand(subcommand =>
            subcommand
                .setName('gen')
                .setDescription('Generate new key for 24 hours'))
        .addSubcommand(subcommand =>
            subcommand
                .setName('status')
                .setDescription('Get status your key'))

    const rawData1 = Data.toJSON()
    commands.push(rawData1)
})();

const rest = new REST({ version: '10' }).setToken(process.env.TOKEN);

Bot.on('ready', async () => {
    Bot.user.setPresence({
        activities: [{ name: "Bot running through node.js", type: "WATCHING" }],
        status: "online"
    })
    console.log(`Running bot as "${Bot.user.tag}" and connects ${Bot.guilds.cache.size} server`)

    try {
		console.log('Started refreshing application (/) commands.');

		await rest.put(
			Routes.applicationCommands(process.env.GUILDID),
			{ body: commands },
		);

		console.log('Successfully reloaded application (/) commands.');
	} catch (error) {
		console.error(error);
	}
})

Bot.on('interactionCreate', async interaction => {
	if (!interaction.isCommand()) return;

    if (interaction.commandName == 'key') {
        if (interaction.options.getSubcommand() == 'gen') {
            /*
                - Set cooldown each user (run this cmd) until key expired 
            */

            const user = interaction.user
            interaction.reply(user.tag)
        } else if (interaction.options.getSubcommand() == 'status') {
            const user = interaction.user
            interaction.reply(user.tag)
        }
    }
});

(async () => {
    const uri = process.env.URI
    const client = new MongoClient(uri)
    try {
        await client.connect(function(err, client){
            console.log('Mongodb connected!')
            KeyDatabases = client.db('Keys')
            Bot.login(process.env.TOKEN)
        })
    } catch (e) {
        console.error(e)
    } finally {
        await client.close(function(err){
            console.log('Mongodb disconnected!')
            if (Bot.isReady()) {
                Bot.destroy();
            }
        })
    }
})().catch(console.error)