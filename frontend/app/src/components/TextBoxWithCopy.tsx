import { useState } from "react";

function TextBoxWithCopy({ text }: { text: string }) {
  const [copied, setCopied] = useState(false);

  let buttonText = !copied ? "Copy" : "Copied";
  return (
    <div className="flex flex-col items-center justify-center px-6 space-y-4">
      <div className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background">
        <p>{text}</p>
      </div>

      <button
        onClick={() => {
          navigator.clipboard.writeText(text);
          setCopied(true);
        }}
        className="rounded-md text-sm font-medium h-10 px-4 py-2 flex items-center transition ease-in-out delay-150 hover:scale-110 hover:border hover:border-stone-700 duration-300"
      >
        {buttonText}
        {!copied && (
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
            className="ml-2 w-4 h-4"
          >
            <rect width="14" height="14" x="8" y="8" rx="2" ry="2"></rect>
            <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
          </svg>
        )}
        {copied && (
          <svg
            xmlns="http://www.w3.org/2000/svg"
            height="16"
            width="14"
            viewBox="0 0 448 512"
            className="ml-2 w-4 h-4"
          >
            <path d="M438.6 105.4c12.5 12.5 12.5 32.8 0 45.3l-256 256c-12.5 12.5-32.8 12.5-45.3 0l-128-128c-12.5-12.5-12.5-32.8 0-45.3s32.8-12.5 45.3 0L160 338.7 393.4 105.4c12.5-12.5 32.8-12.5 45.3 0z" />
          </svg>
        )}
      </button>
    </div>
  );
}

export default TextBoxWithCopy;
