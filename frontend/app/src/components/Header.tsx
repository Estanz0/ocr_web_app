function Header() {
  // Simple navigation bar that spans the full page
  return (
    <>
      <header className="fixed top-0 w-screen h-20 drop-shadow-md shadow-md">
        <div className="container mx-auto flex items-center justify-between h-full px-4">
          <a className="flex items-center space-x-2" href="#">
            <AppIcon className="w-8 h-8" />
            <span className="text-lg font-semibold">OCR Web App</span>
          </a>
        </div>
      </header>
      <main className="pt-24" />
    </>
  );
}

function AppIcon(props: React.SVGProps<SVGSVGElement>) {
  return (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      height="16"
      width="16"
      viewBox="0 0 512 512"
    >
      <path d="M149.1 64.8L138.7 96H64C28.7 96 0 124.7 0 160V416c0 35.3 28.7 64 64 64H448c35.3 0 64-28.7 64-64V160c0-35.3-28.7-64-64-64H373.3L362.9 64.8C356.4 45.2 338.1 32 317.4 32H194.6c-20.7 0-39 13.2-45.5 32.8zM256 192a96 96 0 1 1 0 192 96 96 0 1 1 0-192z" />
    </svg>
  );
}

export default Header;
