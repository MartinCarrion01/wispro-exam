import { Button, Flex, Spacer, Text, useToast } from "@chakra-ui/react";
import { Plan } from "../../services/ProviderService";
import { create_request } from "../../services/SubscriptionRequestService";

interface Props {
  plan: Plan;
}
export default function PlanItem(props: Props) {
  const toast = useToast();
  const handleRequestSubmit = async () => {
    try {
      await create_request(props.plan.id);
      toast({
        title: "Solicitud de contratación enviada",
        description: `Se ha enviado una solicitud de contratación del plan ${props.plan.description}, aguarde respuesta del proveedor`,
        status: "success",
        duration: 9000,
        isClosable: true,
      });
    } catch (error: any) {
      toast({
        title: "Ha ocurrido un error",
        description: JSON.stringify(error.response.data.message),
        status: "error",
        duration: 9000,
        isClosable: true,
      });
    }
  };
  return (
    <Flex
      alignItems="center"
      padding={3}
      my={2}
      border="2px"
      borderRadius="30px"
    >
      <Text fontSize="xl">{props.plan.description}</Text>
      <Spacer />
      <Button colorScheme="teal" size="lg" onClick={handleRequestSubmit}>
        Solicitar contrato
      </Button>
    </Flex>
  );
}
