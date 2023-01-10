import { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useSessionClient } from "../../store/ClientStore";

export default function Redirectable(){
    const client = useSessionClient();
    const navigate = useNavigate();
  
    useEffect(() => {
      if (!client) {
        navigate("/login");
      }
    }, [client, navigate]);

    return(<></>)
}