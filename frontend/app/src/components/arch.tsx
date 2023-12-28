import { useState } from 'react';

function ImageOCR() {
    const [selectedImage, setSelectedImage] = useState<File | null>(null);
    const [uploadedImageUrl, setUploadedImageUrl] = useState<string | null>(null);
    const [parsedText, setParsedText] = useState<string | null>(null);

    const backendUrl = process.env.REACT_APP_BACKEND_URL;

    const handleFormSubmit = (event: React.FormEvent<HTMLFormElement>) => {
        event.preventDefault();

        if (selectedImage) {
            const formData = new FormData();
            formData.append('image', selectedImage);
            formData.append('filename', selectedImage.name);

            // Send the POST request with the image and filename
            fetch(`${backendUrl}/upload_image`, {
                method: 'POST',
                body: formData,
            })
                .then((response) => {
                    return response.json();
                })
                .then((data) => {
                    // Handle the result
                    setUploadedImageUrl(data['image_url']);
                })
                .catch((error) => {
                    // Handle the error
                });
        }
    };

    const handleImageChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        if (event.target.files && event.target.files.length > 0) {
            setSelectedImage(event.target.files[0]);
        }
    };

    const handleParseText = () => {
        if (uploadedImageUrl) {
            fetch(`${backendUrl}/ocr`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    image_url: uploadedImageUrl,
                }),
            })
                .then((response) => {
                    return response.json();
                })
                .then((data) => {
                    // Handle the result
                    setParsedText(data['text']);
                })
                .catch((error) => {
                    // Handle the error
                });
        }
    };

    return (
        <div className="ImageOCR">
            <form onSubmit={handleFormSubmit}>
                <label>
                    Image:
                    <input type="file" name="image" onChange={handleImageChange} />
                </label>
                <input type="submit" value="Submit" />
            </form>
            
            {uploadedImageUrl && <img src={uploadedImageUrl} alt="Uploaded" />}

            {uploadedImageUrl && <button onClick={handleParseText}>Parse Text</button>}
            {parsedText && <p>{parsedText}</p>}
        </div>
    );
}

export default ImageOCR;