import { useState } from "react";

import FileDropZone from "./FileDropZone";

function FileUploadForm({
  handleSetUploadedImageUrl,
}: {
  handleSetUploadedImageUrl: (imageUrl: string) => void;
}) {
  const backendUrl = process.env.REACT_APP_BACKEND_URL;

  const [selectedImage, setSelectedImage] = useState<File | null>(null);
  const [isUploading, setIsUploading] = useState(false);

  const handleFormSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    if (selectedImage) {
      const formData = new FormData();
      formData.append("image", selectedImage);
      formData.append("filename", selectedImage.name);

      // Send the POST request with the image and filename
      fetch(`${backendUrl}/upload_image`, {
        method: "POST",
        body: formData,
      })
        .then((response) => {
          return response.json();
        })
        .then((data) => {
          // Handle the result
          handleSetUploadedImageUrl(data["image_url"]);
        })
        .catch((error) => {
          // Handle the error
        });
    }
  };

  return (
    <>
      <form onSubmit={handleFormSubmit}>
        <div className="flex flex-col items-center space-y-4">
          <FileDropZone setSelectedImageHandler={setSelectedImage} />
        </div>
        <button className="inline-flex items-center justify-center rounded-md text-sm text-white font-medium ring-offset-background h-10 px-4 py-2 mt-4 w-full bg-black">
          Upload
        </button>
      </form>
    </>
  );
}

export default FileUploadForm;
