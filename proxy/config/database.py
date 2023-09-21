from pymongo.mongo_client import MongoClient
import os

# uri = "mongodb+srv://your-mongodb-uri-here"
uri = os.environ.get("MONGODB_URI")

# Create a new client and connect to the server
client = MongoClient(uri)

# Send a ping to confirm a successful connection
# try:
#     client.admin.command('ping')
#     print("Pinged your deployment. You successfully connected to MongoDB!")
# except Exception as e:
#     print(e)

db = client.storyfairy_db

CHARACTER_COLLECTION = db["characters"]
SCENE_COLLECTION = db["scenes"]

TIME_LOG_CHARACTER_COLLECTION = db["character_time_logs"]
TIME_LOG_SCENE_COLLECTION = db["scene_time_logs"]
TIME_LOG_SLIDE_COLLECTION = db["slide_time_logs"]

KEYWORDS_USAGE_COLLECTION = db["keywords_usage"]
