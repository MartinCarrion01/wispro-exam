import "./App.css";
import { Outlet, Route, Routes, useNavigate } from "react-router-dom";
import Home from "./pages/Home";
import Login from "./pages/Login";
import Register from "./pages/Register";
import { useSessionClient } from "./store/ClientStore";
import { useEffect } from "react";
import Navbar from "./components/common/Navbar";

function App() {
  const client = useSessionClient();
  const navigate = useNavigate();

  useEffect(() => {
    if (!client) {
      navigate("/login");
    }
  }, [client, navigate]);

  return (
    <>
      <Navbar />
      <Outlet />
    </>
  );
}

export default App;
