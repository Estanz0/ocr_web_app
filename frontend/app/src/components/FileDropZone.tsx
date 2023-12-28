import { useDropzone, FileWithPath } from "react-dropzone";
import { useCallback } from "react";

function FileDropZone({
  setSelectedImageHandler,
}: {
  setSelectedImageHandler: (file: File | null) => void;
}) {
  const onDropAccepted = useCallback((files: File[]) => {
    setSelectedImageHandler(files[0]);
  }, []);
  const { acceptedFiles, getRootProps, getInputProps } = useDropzone({
    maxFiles: 1,
    onDropAccepted: onDropAccepted,
  });

  const files = acceptedFiles.map((file: FileWithPath) => (
    <p key={file.path}>{file.path}</p>
  ));

  return (
    <div className="w-full p-6 space-y-4 border border-dashed border-gray-300 rounded-md hover:bg-gray-50 transition-colors">
      <div
        className="dropzone flex flex-col items-center justify-center h-64"
        {...getRootProps()}
      >
        <input name="image" {...getInputProps()} />
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          className="w-8 h-8"
        >
          <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
          <polyline points="17 8 12 3 7 8"></polyline>
          <line x1="12" x2="12" y1="3" y2="15"></line>
        </svg>
        <p className="mt-2 text-sm text-gray-600">
          Drag 'n' drop some files here, or click to select files
        </p>
        <div className="mt-1 text-xs text-gray-500">{files}</div>
      </div>
    </div>
  );
}

export default FileDropZone;
