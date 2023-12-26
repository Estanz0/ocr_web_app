from dotenv import load_dotenv
import os

load_dotenv()

class Config:
    OCR_API_KEY = os.getenv('OCR_API_KEY')
    BLOB_ACCOUNT_URL = os.getenv('BLOB_ACCOUNT_URL')
    BLOB_CONTAINER_NAME=os.getenv('BLOB_CONTAINER_NAME')