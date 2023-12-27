from FlaskApp.ocr_api import OCRAPI
from FlaskApp.blob import BlobClient

import logging
import werkzeug

from flask import Flask
from flask_restful import Resource, Api, reqparse
from flask_cors import CORS

app = Flask(__name__)
api = Api(app)
CORS(app)

blobClient = BlobClient()

class UploadImage(Resource):
    def post(self):
        logging.info(f'UploadImage: Post:')

        parser = reqparse.RequestParser()
        parser.add_argument('filename', type=str, required=True, location='form', help='Filename cannot be blank!')
        parser.add_argument('image', type=werkzeug.datastructures.FileStorage, required=True, location='files', help='Image cannot be blank!')
        args = parser.parse_args()

        # Upload to Blob Storage
        image = args.image
        filename = args.filename

        url = blobClient.upload_blob_file(data=image, filename=filename)

        return {"image_url": url}

class OCR(Resource):
    def post(self):
        logging.info(f'OCR: Post:')

        parser = reqparse.RequestParser()
        parser.add_argument('image_url', type=str, required=True)
        args = parser.parse_args()

        data =  OCRAPI.ocr_url(url=args['image_url'])
        parsed_results = data.get('ParsedResults', None)

        if parsed_results is None or len(parsed_results) == 0:
            return {"text": ""}
        
        parsed_text = parsed_results[0].get('ParsedText', None)

        return {"text": parsed_text}

api.add_resource(OCR, '/ocr')
api.add_resource(UploadImage, '/upload_image')

if __name__ == '__main__':
    app.run(debug=True)