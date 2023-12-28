function ImageDisplay({ uploadedImageUrl }: { uploadedImageUrl: string }) {
  return (
    <div className="flex flex-col items-center">
      <img
        alt="Placeholder Image"
        className="w-11/12"
        src={uploadedImageUrl}
        style={{
          objectFit: "scale-down",
        }}
        width="500"
      />
    </div>
  );
}

export default ImageDisplay;
