import {
  Alert,
  AlertIcon,
  AlertTitle,
  Button,
} from "@chakra-ui/react";
import { useNavigate } from "react-router-dom";

export default function RegisterSuccessMessage() {
  const navigate = useNavigate();

  return (
    <Alert
      status="success"
      variant="subtle"
      flexDirection="column"
      alignItems="center"
      justifyContent="center"
      textAlign="center"
      height="200px"
    >
      <AlertIcon boxSize="40px" mr={0} />
      <AlertTitle mt={4} mb={1} fontSize="lg">
        ¡Se ha registrado correctamente!
      </AlertTitle>
      <Button
        colorScheme={"teal"}
        my={2}
        onClick={() => navigate("/login")}
      >
        Volver a iniciar sesión
      </Button>
    </Alert>
  );
}
