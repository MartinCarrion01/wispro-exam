import { Flex } from "@chakra-ui/react";
import SubTitle from "../components/common/Subtitle";
import Title from "../components/common/Title";
import HalfWidthCenter from "../components/common/HalfWidthCenter";
import RegisterForm from "../components/register/RegisterForm";

export default function Register() {
  return (
    <>
      <Flex direction="column" align="center" justify="center" my="50">
        <HalfWidthCenter>
          <Title title={"Wispro Client"} color={"black"} />
          <SubTitle text={"Registrarse"} />
          <RegisterForm />
        </HalfWidthCenter>
      </Flex>
    </>
  );
}
