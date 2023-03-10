import { Flex } from "@chakra-ui/react";
import RedirectToFormPrompt from "../components/common/RedirectToFormPrompt";
import SubTitle from "../components/common/Subtitle";
import Title from "../components/common/Title";
import HalfWidthCenter from "../components/common/HalfWidthCenter";
import LoginForm from "../components/login/LoginForm";

export default function Login() {
  return (
    <>
      <Flex direction="column" align="center" justify="center" my="50">
        <HalfWidthCenter>
          <Title title={"Wispro Client"} color={"black"} />
          <SubTitle text={"Iniciar sesión"} />
          <LoginForm />
          <RedirectToFormPrompt
            auxiliaryText="¿No tiene una cuenta? "
            linkText="Registrese."
            redirectRoute="register"
          />
        </HalfWidthCenter>
      </Flex>
    </>
  );
}
