import exp from "constants";

function Spinner({ text }: { text: string }) {
  return (
    <div className="flex flex-col items-center justify-center px-6 space-y-4">
      <div className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background">
        <p>{text}</p>
      </div>
      <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-gray-900"></div>
    </div>
  );
}

export default Spinner;
