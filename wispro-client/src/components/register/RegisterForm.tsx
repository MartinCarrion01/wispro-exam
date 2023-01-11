import { Button } from "@chakra-ui/react";
import { useState } from "react";
import { Client, register } from "../../services/ClientService";
import AlertMessage from "../common/AlertMessage";
import Form from "../common/Form";
import InputText from "../common/InputText";
import RedirectToFormPrompt from "../common/RedirectToFormPrompt";
import RegisterSuccessMessage from "./RegisterSuccessMessage";

export default function RegisterForm() {
  const [firstName, setFirstName] = useState<string>("");
  const [lastName, setLastName] = useState<string>("");
  const [username, setUsername] = useState<string>("");
  const [password, setPassword] = useState<string>("");
  const [passwordConfirmation, setPasswordConfirmation] = useState<string>("");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [showSuccess, setShowSuccess] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);

  const handleRegister = async () => {
    setLoading(true);
    try {
      const newClient: Client = {
        username: username,
        password: password,
        password_confirmation: passwordConfirmation,
        first_name: firstName,
        last_name: lastName,
      };
      await register(newClient);
      console.log("cliente creado from registerform");
      setShowSuccess(true);
    } catch (error: any) {
      setErrorMessage(JSON.stringify(error.response.data.message));
      setLoading(false);
    }
  };

  return (
    <>
      {showSuccess ? (
        <RegisterSuccessMessage />
      ) : (
        <>
          <Form>
            {errorMessage ? (
              <AlertMessage status="error" description={errorMessage} />
            ) : (
              <></>
            )}
            <InputText
              label={"Nombre"}
              name={"firstName"}
              value={firstName}
              setValue={setFirstName}
              password={false}
            />
            <InputText
              label={"Apellido"}
              name={"lastName"}
              value={lastName}
              setValue={setLastName}
              password={false}
            />
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
            <InputText
              label={"Confirmar contraseña"}
              name={"passwordConfirmation"}
              value={passwordConfirmation}
              setValue={setPasswordConfirmation}
              password={true}
            />
            <Button
              colorScheme={"teal"}
              onClick={handleRegister}
              disabled={
                [
                  username,
                  password,
                  passwordConfirmation,
                  firstName,
                  lastName,
                ].includes("") || loading
              }
              isLoading={loading}
            >
              Registrarse
            </Button>
          </Form>
          <RedirectToFormPrompt
            auxiliaryText="¿Ya tiene una cuenta? "
            linkText="Inicie sesión."
            redirectRoute="login"
          />
        </>
      )}
    </>
  );
}
