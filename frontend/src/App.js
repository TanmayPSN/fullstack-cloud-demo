import React, { useEffect, useState } from "react";

function App() {
  const [message, setMessage] = useState("Loading...");

  useEffect(() => {
    fetch("https://potential-rotary-phone-6xr5r4x97xg3grj-8080.app.github.dev/api/hello")
      .then(res => res.text())
      .then(data => setMessage(data))
      .catch(() => setMessage("Backend not reachable"));
  }, []);

  return <h1>{message}</h1>;
}

export default App;
