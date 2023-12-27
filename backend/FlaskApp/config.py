from dotenv import load_dotenv
import os
import logging

load_dotenv()

class Config:
    OCR_API_KEY = os.getenv('OCR_API_KEY')
    STORAGE_ACCOUNT_URL_IMAGE_UPLOAD = os.getenv('STORAGE_ACCOUNT_URL_IMAGE_UPLOAD')
    STORAGE_CONTAINER_NAME_IMAGE_UPLOAD=os.getenv('STORAGE_CONTAINER_NAME_IMAGE_UPLOAD')
