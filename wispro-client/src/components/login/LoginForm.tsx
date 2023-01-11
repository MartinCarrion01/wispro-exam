import { Button} from "@chakra-ui/react";
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { login } from "../../services/ClientService";
import AlertMessage from "../common/AlertMessage";
import Form from "../common/Form";
import InputText from "../common/InputText";

export default function LoginForm() {
  const [username, setUsername] = useState<string>("");
  const [password, setPassword] = useState<string>("");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const navigate = useNavigate();

  const handleLogin = async () => {
    setLoading(true)
    try {
      await login(username, password);
      navigate("/");
    } catch (error: any) {
      setErrorMessage(error.response.data.message);
      setLoading(false)
    }
  };

  return (
    <>
      <Form>
        {errorMessage ? (
          <AlertMessage status="error" description={errorMessage} />
        ) : (
          <></>
        )}
        <InputText
          label={"Nombre de usuario"}
          name={"username"}
          value={username}
          setValue={setUsername}
          password={false}
        />
        <InputText
          label={"Contraseña"}
          name={"password"}
          value={password}
          setValue={setPassword}
          password={true}
        />
        <Button
          colorScheme={"teal"}
          onClick={handleLogin}
          disabled={username === "" || password === "" || loading}
          isLoading={loading}
        >
          Ingresar
        </Button>
      </Form>
    </>
  );
}
