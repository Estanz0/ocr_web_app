import logging

from FlaskApp.config import Config

from azure.storage.blob import BlobServiceClient, ContentSettings
from azure.identity import DefaultAzureCredential

class BlobClient:
    def __init__(self):
        self.credential = DefaultAzureCredential()
        self.blob_service_client = BlobServiceClient(account_url=Config.STORAGE_ACCOUNT_URL_IMAGE_UPLOAD, credential=self.credential)
        self.container_name = Config.STORAGE_CONTAINER_NAME_IMAGE_UPLOAD

    def upload_blob_file(self, data, filename):
        logging.info(f'BlobClient: upload_blob_file: filename={filename}')
        container_client = self.blob_service_client.get_container_client(container=self.container_name)
        
        content_settings = ContentSettings(content_type="image/jpeg")
        blob_client = container_client.upload_blob(name=filename, data=data, overwrite=True, content_settings=content_settings)

        return blob_client.url