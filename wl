import discord 
import asyncio
import random
import datetime
import io
import requests
import DiscordUtils
from typing import List


intents = discord.Intents.all()

from discord.ext import commands
from discord import Member, Embed, DMChannel, Forbidden, Message, TextChannel
from discord.ext.commands import has_permissions, MissingPermissions, MissingRequiredArgument, CommandNotFound, BadArgument, BucketType, cooldown, CommandOnCooldown, Bot, Cog, Context, command
from discord.utils import get
from utils import enum
from dotenv import load_dotenv

from discord.abc import User

from asyncio import sleep

from PIL import Image, ImageDraw, ImageFont
from io import BytesIO
from glob import glob


#from PIL import Image, ImageOps, ImageDraw, ImageFilter, ImageFont
#from io import BytesIO

client = commands.Bot(command_prefix="&", intents=intents)

client.load_extension("application")

load_dotenv()

async def status():

      while True:
        #await client.change_presence(activity=discord.Activity(type=discord.ActivityType.watching, name='1'))
        #await sleep(60*10)
        await client.change_presence(activity=discord.Game(name='War Lords'))
        await sleep(30)
        await client.change_presence(activity=discord.Game(name='Bot Developer Benzitczo'))
        await sleep(15)
    #await client.change_presence(status=discord.Status.online, activity=discord.Game("Ghost of War"))

@client.event
async def on_ready():
    await client.wait_until_ready()
    print(f'{client.user} has Awoken!')
    await client.loop.create_task(status())


def convert(time):
    pos =["s","m","h","d"]
    time_dict = {"s" : 1, "m" : 60, "h" : 3600 , "d" : 3600*24}
    unit = time[-1]

    if unit not in pos:
        return -1
    try:
        val = int(time[:-1])
    except:
        return -2

    return val * time_dict[unit]

#OWNER_IDS = [385807530913169426]
#COGS = [path.split("\\")[-1][:-3] for path in glob("./lib/cogs/*.py")]
#IGNORE_EXCEPTIONS = (CommandNotFound, BadArgument)


@client.command()

async def hello(ctx):

 await ctx.send("Hi")

@client.command(aliases=['c'])

@commands.has_role("Staff Team")

async def clear(ctx, amount=2):

     await ctx.send(f"{amount} message were cleared")
     await ctx.channel.purge(limit=amount)

@client.command(aliases=['k'])

@commands.has_permissions(kick_members = True)

async def kick(ctx,member : discord.Member,*,reason= "no reason Provided"):

   await member.send("You have been kicked from the server, if you think it's an mistake please kindly contact in our mail benzitczo2015@gmail.com or contact any of the staff members from the server Reason: "+reason)

   await member.kick(reason=reason)

   embed = discord.Embed(title='Kicked', description=f"{member} has been Kicked from the server", color=discord.Color(0xf00))

   await ctx.send(embed=embed)

@client.command(aliases=['b'])

@commands.has_permissions(ban_members = True)

async def ban(ctx,member : discord.Member,*,reason= "no reason Provided"):

    await member.send("You have been Banned from the server, if you think it's an mistake please kindly contact in our mail benzitczo2015@gmail.com or DM any of the staff members from the server Reason: "+reason)

    await member.ban(reason=reason)

    embed = discord.Embed(title='Banned', description=f"{member} has been banned from the server", color=discord.Color(0xf00))

    await ctx.send(embed=embed)

@client.command()
@cooldown(1, 15, BucketType.user)
async def codes(ctx):

 await ctx.send("""
 **More codes will be available soon!**""")

@client.command()
@commands.has_role('Staff Team')
async def language(ctx):
    embed = discord.Embed(
        title = 'Select languages',
        description = '🇪🇸 => Español   🇧🇷 => Brasil   🇷🇺 => Pусский   🇫🇷 => Français   🇮🇳 => भारत   🇦🇪 => سنڌي   🇩🇪 => Deutsche',
        colour = discord.Colour.blue()
    )
    embed.set_image(url='https://i.imgur.com/IZbGAZo.png')
    embed.add_field(name='Developer', value='xDevs LTD', inline=True)
    
    await ctx.send (embed=embed)

@client.command()
@commands.has_role('Staff Team')
async def platform(ctx):
    embed = discord.Embed(
        title = 'Select platform',
        description = '💻 => PC   🔋 => Android   📱 => iOS',
        colour = discord.Colour.blue()
    )
    embed.set_image(url='https://i.imgur.com/CfpDbIp.png')
    embed.add_field(name='Developer', value='xDevs LTD', inline=True)

    await ctx.send (embed=embed)

@client.command()
@commands.has_role('Staff Team')
async def other(ctx):
    embed = discord.Embed(
        title = 'Select other',
        description = '🗓 => Events   💸 => Giveaway',
        colour = discord.Colour.blue()
    )
    embed.set_image(url='https://i.imgur.com/l9YhYWv.png')
    embed.add_field(name='Developer', value='xDevs LTD', inline=True)
    
    await ctx.send (embed=embed)

#@client.command()
#@commands.has_role('Admin Bot')
#async def suggests(ctx):
 #await ctx.send("""
#In suggestion channel users we write their suggestions and when they are done the bot should automatically send their message in the suggestion-report channel""")

 ##embed = discord.Embed(title='Banned', description=f"{member} has been banned from the server", color=discord.Color(0xFF))

 ##await ctx.send(embed=embed)

@client.command(aliases=['ub'])
@commands.has_permissions(ban_members=True)

async def unban(ctx, *, member):
    banned_users = await ctx.guild.bans()
    member_name, member_discriminator = member.split('#')

    for ban_entry in banned_users:
        user = ban_entry.user

        if(user.name, user.discriminator) == (member_name, member_discriminator):
            await ctx.guild.unban(user)
            #await ctx.send(f'{member} has been unbanned from the server')
            embed = discord.Embed(title='UnBanned', description=f"{member} has been ubanned from the server", color=discord.Color(0x33))
            await ctx.send(embed=embed)
            return
@client.command()
#@commands.has_role('Staff Team')
    #message = await channel.send(embed=imgembed)
@cooldown(1, 30, BucketType.user)
async def suggest(ctx,*,message):
    imgembed= discord.Embed(title="💡 SUGGESTIONS | WAR LORDS 💡", description=f"{message}")
    imgembed.set_footer(text=f"BY: {ctx.author} - ID: {ctx.author.id}", icon_url=ctx.author.avatar_url)
    ##imgembed.set_thumbnail(url=f"{ctx.guild.icon_url}")
    channel = client.get_channel(815851288226693121)
    try:
        result = requests.get(ctx.message.attachments[0].url)
        imgembed.set_image(url="attachment://WLS.png")
        message = await channel.send(embed=imgembed, file=discord.File(io.BytesIO(result.content), filename="WLS.png"))
    except IndexError:
        message = await channel.send(embed=imgembed)
    await ctx.message.delete(delay=1)
    await message.add_reaction("✅")
    await message.add_reaction("❌")
    message2 = await ctx.send(f"{ctx.author.mention}, your suggestion has been successfully submitted! Check <#815851288226693121>")
    await asyncio.sleep(30)
    await message2.delete()


#@client.command()
#@cooldown(1, 15, BucketType.user)
#async def hreport(ctx,*,message):
    #imgembed= discord.Embed(title=":no_entry: REPORT HACKER :no_entry:", description=f"{message}")
    #imgembed.set_footer(text=f"By: {ctx.author}", icon_url=ctx.author.avatar_url)
    ##imgembed.set_thumbnail(url=f"{ctx.guild.icon_url}")
    #channel = client.get_channel(811939310647509042)
    #try:
      #  result = requests.get(ctx.message.attachments[0].url)
     #   imgembed.set_image(url="attachment://hackreport.png")
    #    message = await channel.send(embed=imgembed, file=discord.File(io.BytesIO(result.content), filename="hackreport.png"))
    #except IndexError:
     #   message = await channel.send(embed=imgembed)
    #await ctx.message.delete(delay=1)
    #await message.add_reaction("🚫")
   # message2 = await ctx.send(f"{ctx.author.mention}, your hacker report has been successfully submitted! Check <#811939310647509042>")
  #  await asyncio.sleep(15)
 #   await message2.delete()


 #** :arrow_double_up: Please write command example: &hreport nick: Player_hack - Jump High hack or Ammo infinite hack :arrow_double_up: **

@client.command()
@commands.has_role('Staff Team')
@cooldown(1, 30, BucketType.user)
async def wanted(ctx, member: discord.Member = None):
    if member == None:
        user = ctx.author
    else:
        user = member
    
    wanted = Image.open("Wanted.jpg")

    asset = user.avatar_url_as(size = 128)
    data = BytesIO(await asset.read())
    pfp = Image.open(data)

    pfp = pfp.resize((345,345)) 

    wanted.paste(pfp, (135,295))

    wanted.save("profile.jpg")

    await ctx.send(file = discord.File("profile.jpg"))

@client.command()
@cooldown(1, 10, BucketType.user)
async def avatar(ctx, member: discord.Member):
    show_avatar = discord.Embed(
        title =f'{member}',
        color = discord.Color.dark_blue()
    )
    show_avatar.set_image(url='{}'.format(member.avatar_url))
    await ctx.send(embed=show_avatar)

@client.command()
@cooldown(1, 10, BucketType.user)
async def ping(ctx):
    await ctx.channel.send(f"ping {round(client.latency*1000)} ms")

@client.command()
#commands.has_guild_permissions
@commands.has_role('Staff Team')
async def say(ctx, *, words):
    await asyncio.sleep(1)
    await ctx.message.delete()
    await ctx.send(f"{words}" .format(words))
    embed = discord.Embed (title=f'{ctx.author}')   

@client.command()
@commands.has_role('Staff Team')
@cooldown(1, 10, BucketType.user)
async def gow(ctx, member : discord.Member): 
    img = Image.open("gowperfil.png")
    draw = ImageDraw.Draw(img)
    number1 = random.randrange(0,999999)
    number2 = random.randrange(0,999999)
    number3 = random.randrange(0,999999)
    font = ImageFont.truetype("arial.ttf", 24)
    draw.text((75,45), f"{member.name}#{member.discriminator}", (255, 255, 255), font = font)
    # Here \/
    draw.text((456,50), f"{number1}", (255, 255, 255), font = font)
    draw.text((674,50), f"{number2}", (255, 255, 255), font = font)
    draw.text((885,50), f"{number3}", (255, 255, 255), font = font)
    img.save("gowfake.png")
    await ctx.send(file = discord.File("gowfake.png"))


@client.command(aliases=['user','info'])
@cooldown(1, 10, BucketType.user)
async def whois(ctx, member: discord.Member = None):
    roles = [role for role in member.roles]
    embed = discord.Embed(title = member.name , status = member.status , description = member.mention , color = discord.Colour.green())
    embed.add_field(name="Created Account:", value=member.created_at.strftime("%a, %#d %B %Y, %I:%M %p UTC"))
    embed.add_field(name="Joined Server:", value=member.joined_at.strftime("%a, %#d %B %Y, %I:%M %p UTC"))
    embed.add_field(name = "ID" , value = member.id , inline = True)
    embed.add_field(name="Roles:", value="".join([role.mention for role in roles]))
    embed.add_field(name="Highest Role:", value=member.top_role.mention)
    embed.add_field(name="Status:", value = member.status)
    ##print(member.top_role.mention)
    embed.set_thumbnail(url = member.avatar_url)
    embed.set_footer(icon_url = ctx.author.avatar_url, text = f"Requested by {ctx.author.name}")
    await ctx.send(embed=embed)

@client.command()
@commands.has_permissions(kick_members=True)
async def warn(ctx, member:discord.Member, *, reason=None):
 arg=reason
 author=ctx.author
 guild=ctx.message.guild
 overwritee = discord.PermissionOverwrite()
 overwrite = discord.PermissionOverwrite()
 channel = get(guild.text_channels, name='logs')
 mrole = get(ctx.guild.roles, name="Multi-Galaxy")

 if channel is None:
  channel = await guild.create_text_channel('logs', category=category)
  overwritee.read_messages = False
  overwritee.read_message_history = False
  overwritee.send_messages = False
  overwrite.read_messages = True
  overwrite.read_message_history = True
  overwrite.send_messages = True
  await channel.set_permissions(guild.default_role, overwrite=overwritee)
  await channel.set_permissions(mrole, overwrite=overwrite)

 if member is None:
  await ctx.send("Please specify a user and/or reason!")

 await channel.send(f'{member.mention} got warned for: ```\n{arg}\n``` Warned by: {author}')
 await member.send(f'You got warned for: ```\n{arg}\n``` Warned by: {author} - Server: **{guild.name}**')
 await ctx.send(f'{member.mention} got warned for: ```\n{arg}\n``` Warned by: {author}')
 await ctx.message.delete()


@client.command()
@commands.has_role("Giveaway Manager") #[🌕] Giveaway Manager - #tetstt
async def giveaway(ctx):
    await ctx.send("Lets start with this giveaway! Asnwer these Questions within 100 seconds!")
    Questions = ["Which Channel should it be hosted in?",
                 "What should be the uration of the giveaway? example: 1s (seconds) , 1m (minutes) , 1h (hour) , 1d (day)",
                 "How many winners?",
                 "What is the prize of the giveaway?"]

    asnwers = []
    def check(m):
      return m.author == ctx.author and m.channel == ctx.channel

    for i in Questions:
        await ctx.send(i)

        try:
           msg = await client.wait_for('message', timeout=100.0, check=check)
        except asyncio.TimeoutError:
           await ctx.send('You didn\'t asnwer in time, please be quicker next time!')
           
        else:
            asnwers.append(msg.content)

        try:
         c_id = int(asnwers[0][2:-1])
        except:
           await ctx.send(f"You didnt mention a channel properly do it like this {ctx.channel.mention} next time.")
        

    channel = client.get_channel(c_id)

    time = convert(asnwers[1])
    amt_winners = asnwers[2]
    try: 
        int(amt_winners)
    except ValueError:
        await ctx.send("Error message here if amount of winners is not an integer")
        

    if time == -1:
        await ctx.send(f"You didnt asnwer the time with a proper unit. Use (s|m|h|d next time!")
        
        
    elif time == -2:
        await ctx.send(f"The time must be an integer. Please enter an integer next time")
        

    prize = asnwers[3]
    #role = ctx.guild.get_role(791305176098275328)
    #await ctx.send(f"The giveaway will be in {role.mention} and will last {asnwers[1]}!")
    imgembed = discord.Embed(title = "🎉 GIVEAWAY! | WAR LORDS 🎉", description = f"{prize}", color = ctx.author.color)
    try:
        result = requests.get(ctx.message.attachments[0].url)
        imgembed.set_image(url="attachment://WLG.png")
    except IndexError:
        image = None
        await channel.send("Image URL not found", embed=imgembed)
        return
    ##end = datetime.datetime.utcnow() + datetime.timedelta(seconds = min*60)
    imgembed.add_field(name = "Amount of Winners:", value = asnwers[2])
    imgembed.add_field(name = "Hosted by:", value = ctx.author.mention)
    imgembed.add_field(name = "End date:", value = asnwers[1])
    imgembed.set_footer(text = f"Ends at {asnwers[1]} from now")

    my_msg = await channel.send(embed=imgembed, file=discord.File(io.BytesIO(result.content), filename="WLG.png"))

    await my_msg.add_reaction("🎉")

    await asyncio.sleep(time)
  
    new_msg = await channel.fetch_message(my_msg.id)

    users = await new_msg.reactions[0].users().flatten()
    users.pop(users.index(client.user))

    winners = []
    for i in range(int(asnwers[2])):
     user = random.choice(users)
     while user.mention in winners:
       user = random.choice(users)
     winners.append(user.mention)
    
    await channel.send(f"Congratulations! {', '.join([winner for winner in winners])} you have won the **{prize}!** 👏 -  Please kindly DM {ctx.author.mention} to receive your prize 📬")

@client.command()
@commands.has_role("Giveaway Manager")
async def reroll(ctx, channel : discord.TextChannel, id_ : int):
       try:
        new_msg = await channel.fetch_message(id_)
       except:
         await ctx.send("The id was entered incorrectly.")
         return

       users = await new_msg.reactions[0].users().flatten()
       users.pop(users.index(client.user))

       winners = []
       user = random.choice(users)
       winners.append(user.mention) 

       await channel.send(f"Again, congratulations! {', '.join([winner for winner in winners])} - Please kindly DM {ctx.author.mention} to receive your prize 📬")

@client.event
async def on_command_error(ctx, error):
    if isinstance(error, commands.CommandOnCooldown): #checks if on cooldown
        msg = '**Still on cooldown**, please try again in {:.2f}s'.format(error.retry_after) #says the time
        await ctx.send(msg) #send the error message
        #note: {:.2f} is too shorten the decimals. Example: 3.128343 would be 3.12
    else:
        raise Exception(error)

@client.event
async def on_member_join(member):
    guild = client.get_guild(815819097920897024)
    embed=discord.Embed(title= f"Welcome to {guild.name}!", description = f"Hi there! {member.mention}, nice to meet you make sure to read the rules <#815828396088098829> \nSelect your language in <#815841664366542868>", color= discord.Color.blue())
    #embed.set_footer(text=f"Made by {guild.name}")
    embed.set_image(url="https://i.imgur.com/z4RWdxR.png")
    channel = client.get_channel(815840762922663947)
    await channel.send(f"{member.mention}", embed=embed)

    #   guild = client.get_guild(788796730594426880) # YOUR INTEGER GUILD ID HERE
  #  welcome_channel = guild.get_channel(788909261677395978) # YOUR INTEGER CHANNEL ID HERE
   # await welcome_channel.send(f'Welcome to the {guild.name} Discord Server, {member.mention} !  :partying_face:')
    #await member.send(f'We are glad to have you in the {guild.name} Discord Server, {member.name} !  :partying_face:')

@client.command(pass_context=True)
@commands.has_role("Community Manager")
async def addrole(ctx, user: discord.Member, *, role: discord.Role):
    if role in user.roles:
        embed=discord.Embed(title="Give Role", description=f"{ctx.author.mention}, {user.mention} already has the role {role.mention}")
        await ctx.send(embed=embed)
    else:
        embed=discord.Embed(title=f"Give Role", description=f"Added role {role.mention} to {user.mention}")
        await user.add_roles(role)
        await ctx.send(embed=embed)

@client.command(pass_context=True)
@commands.has_role("Community Manager")
async def removerole(ctx, user: discord.Member, *, role: discord.Role):
    if role in user.roles:
        embed=discord.Embed(title=f"Remove Role", description=f"Removed role {role.mention} from {user.mention}")
        await user.remove_roles(role)
        await ctx.send(embed=embed)
    else:
        embed=discord.Embed(title="Remove Role", description=f"{ctx.author.mention}, {user.mention} does not has the role {role.mention}")
        await ctx.send(embed=embed)   

@client.command()
@cooldown(1, 5, BucketType.user)
async def slowmode(ctx, seconds: int):
    await ctx.channel.edit(slowmode_delay=seconds)
    await ctx.send(f"Set the slowmode delay in this channel to {seconds} seconds!")     

client.reaction_roles = []

@client.event
async def on_raw_reaction_add(playLoad):
    for role, msg, emoji in client.reaction_roles:
        if msg.id == playLoad.message_id and emoji == playLoad.emoji.name:
            await playLoad.member.add_roles(role)

@client.event
async def on_raw_reaction_remove(payload):
    for role, msg, emoji in client.reaction_roles:
        if msg.id == payload.message_id and emoji == payload.emoji.name:
            guild = client.get_guild(payload.guild_id)
            member = guild.get_member(payload.user_id)
            await member.remove_roles(role)

@client.command()
@cooldown(1, 5, BucketType.user)
@commands.has_any_role("Community Manager")
#@command.has_permissons(kick_members = true)
async def reaction(ctx, role: discord.Role = None, msg: discord.Message = None, emoji = None):
    if role != None and msg != None and emoji != None:
        await msg.add_reaction(emoji)
        client.reaction_roles.append((role, msg, emoji))

    else:
        await ctx.send("Invalid arguments.")


@client.command()
@commands.has_any_role("Administrator")
async def edits(ctx, msg_id: int = None, channel: discord.TextChannel = None):
    if not msg_id:
        channel = client.get_channel(767022235097235456) # the message's channel
        msg_id = 755441493648343132 # the message's id
    elif not channel:
        channel = ctx.channel
    msg = await channel.fetch_message(msg_id)
    await msg.edit(content="Some content!")

@client.command()
@commands.has_any_role("Administrator")
async def send_message(user_id, text):
    user = client.get_user(user_id)
    message = await user.send(text)
    return message.id


@client.command()  #Command to mute a user
@has_permissions(manage_roles = True)
async def mute(ctx, member: discord.Member = None):
    if(member == None):
        await ctx.send('Sorry, you have to mention someone to mute.')
    else:
        role_muted = discord.utils.get(member.guild.roles, name = 'Muted')
        await member.add_roles(role_muted)
        await ctx.message.add_reaction('✅')

@client.command()  #Command to unmute a user
@has_permissions(manage_roles = True)
async def unmute(ctx, member: discord.Member = None):
    if(member == None):
        await ctx.send('Sorry, you have to mention someone to unmute.')
    else:
        role_muted = discord.utils.get(member.guild.roles, name = 'Muted')
        await member.remove_roles(role_muted)
        await ctx.message.add_reaction('✅')






