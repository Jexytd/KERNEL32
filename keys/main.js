require('dotenv').config()

const { REST } = require('@discordjs/rest')
const { Routes } = require('discord-api-types/v10')
const { SlashCommandBuilder } = require('@discordjs/builders');
const { Client } = require('discord.js')
const { MongoClient } = require('mongodb')
const Bot = new Client({ intents: ["GUILDS", "GUILD_MESSAGES"] })

var KeyDatabases;

function createObj(n, k, exp) {
    return {
        name: n,
        key: k,
        expire: exp
    }
}

async function createDocs(obj) {
    if (!KeyDatabases) return;
    try {
        const res = await KeyDatabases.insertOne(obj)
        console.log(`Successfully created docs with following id: ${res.insertId}`)
    } catch (e) {
        console.error(e)
    }
}

const commands = [
    new SlashCommandBuilder().setName('key').setDescription('Generate key or status key').setDMPermission().addSubcommand(subcommand => subcommand.setName('gen').setDescription('Generating hub key for 24 hours')).addSubcommand(subcommand => subcommand.setName('status').setDescription('Get your key status info')),
    new SlashCommandBuilder().setName('info').setDescription('Get info about a user or a server!').addSubcommand(subcommand => subcommand.setName('user').setDescription('Info about a user').addUserOption(option => option.setName('target').setDescription('The user'))).addSubcommand(subcommand => subcommand.setName('server').setDescription('Info about the server'))
].map(v => v.toJSON());

Bot.on('ready', async () => {
    Bot.user.setPresence({
        activities: [{ name: "Bot running through node.js", type: "WATCHING" }],
        status: "online"
    })
    console.log(`Running bot as "${Bot.user.tag}" and connects ${Bot.guilds.cache.size} server`)

    const rest = new REST({ version: '10' }).setToken(process.env.TOKEN);
    try {
		console.log('Started refreshing application (/) commands.');

		await rest.put(
			Routes.applicationGuildCommands(process.env.CLIENTID,process.env.GUILDID),
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

    if (interaction.commandName == 'info') {
        if (interaction.options.getSubcommand() == 'user') {
            const user = interaction.options.getUser('target');

			if (user) {
				await interaction.reply(`Username: ${user.username}\nID: ${user.id}`);
			} else {
				await interaction.reply(`Your username: ${interaction.user.username}\nYour ID: ${interaction.user.id}`);
			}
        } else if (interaction.options.getSubcommand() == 'server') {
            await interaction.reply(`Server name: ${interaction.guild.name}\nTotal members: ${interaction.guild.memberCount}`);
        }
    }
});

(async () => {
    const uri = process.env.URI
    const client = new MongoClient(uri)
    try {
        await client.connect(async (err, c) => {
            console.log('Mongodb connected!')
            KeyDatabases = (await client && client.db('Keys')) || false
            if (!KeyDatabases) {
                Bot.destroy()
                console.log('Bot destroyed!')
                return;
            }
            Bot.login(process.env.TOKEN)
        })
    } catch (e) {
        console.error(e)
    } finally {
        await client.close(function(err){
            console.error(err || 'Mongodb disconnected!')
            Bot.destroy();
        })
    }
})().catch(console.error)