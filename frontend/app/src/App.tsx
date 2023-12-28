import { useState, useEffect } from "react";

import FileUploadForm from "./components/FileUploadForm";
import TextBoxWithCopy from "./components/TextBoxWithCopy";
import ImageDisplay from "./components/ImageDisplay";
import Spinner from "./components/Spinner";
import Header from "./components/Header";

function App() {
  const backendUrl = process.env.REACT_APP_BACKEND_URL;

  const [uploadedImageUrl, setUploadedImageUrl] = useState<string | null>(null);
  const [parsedText, setParsedText] = useState<string | null>(null);

  useEffect(() => {
    handleParseText();
  }, [uploadedImageUrl]);

  const handleReset = () => {
    setUploadedImageUrl(null);
    setParsedText(null);
  };

  const handleParseText = () => {
    if (uploadedImageUrl) {
      fetch(`${backendUrl}/ocr`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
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
          setParsedText(data["text"]);
        })
        .catch((error) => {
          // Handle the error
        });
    }
  };

  return (
    <>
      <Header />
      <div className="flex flex-col w-full max-w-lg mx-auto p-6 space-y-8">
        {!uploadedImageUrl && (
          <FileUploadForm handleSetUploadedImageUrl={setUploadedImageUrl} />
        )}
        {uploadedImageUrl && (
          <>
            <div className="rounded-lg border bg-card text-card-foreground shadow-sm w-full p-4 space-y-4">
              {uploadedImageUrl && (
                <ImageDisplay uploadedImageUrl={uploadedImageUrl} />
              )}
              {parsedText && <TextBoxWithCopy text={parsedText} />}
              {!parsedText && <Spinner text="Generating Text..." />}
            </div>
            <button
              className="inline-flex items-center justify-center rounded-md text-sm text-white font-medium ring-offset-background h-10 px-4 py-2 mt-4 w-full bg-black"
              onClick={handleReset}
            >
              Upload Another Image
            </button>
          </>
        )}
      </div>
    </>
  );
}

export default App;
