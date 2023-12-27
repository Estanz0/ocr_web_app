from FlaskApp.config import Config

import requests
import json


class OCRAPI:
    def ocr_file(filename:str, overlay:bool=False, language:str='eng'):
        """ OCR.space API request with local file.
            Python3.5 - not tested on 2.7
        :param filename: Your file path & name.
        :param overlay: Is OCR.space overlay required in your response.
                        Defaults to False.
        :param api_key: OCR.space API key.
                        Defaults to 'helloworld'.
        :param language: Language code to be used in OCR.
                        List of available language codes can be found on https://ocr.space/OCRAPI
                        Defaults to 'en'.
        :return: Result in JSON format.
        """

        payload = {'isOverlayRequired': overlay,
                'apikey': Config.OCR_API_KEY,
                'language': language,
                }
        with open(filename, 'rb') as f:
            r = requests.post('https://api.ocr.space/parse/image',
                            files={filename: f},
                            data=payload,
                            )
        return r.content.decode()


    def ocr_url(url:str, overlay:bool=False, language:str='eng'):
        """ OCR.space API request with remote file.
            Python3.5 - not tested on 2.7
        :param url: Image url.
        :param overlay: Is OCR.space overlay required in your response.
                        Defaults to False.
        :param api_key: OCR.space API key.
                        Defaults to 'helloworld'.
        :param language: Language code to be used in OCR.
                        List of available language codes can be found on https://ocr.space/OCRAPI
                        Defaults to 'en'.
        :return: Result in JSON format.
        """

        payload = {'url': url,
                'isOverlayRequired': overlay,
                'apikey': Config.OCR_API_KEY,
                'language': language,
                }
        r = requests.post('https://api.ocr.space/parse/image',
                        data=payload,
                        )

        return r.json()