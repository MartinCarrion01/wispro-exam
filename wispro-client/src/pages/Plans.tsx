import { Flex, Heading } from "@chakra-ui/react";
import PlansByProvidersContainer from "../components/plans/PlansByProviderContainer";

export default function Plans() {
  return (
    <>
      <Flex direction="column" mx="5" my="10" gap="2">
        <Heading size="lg">Planes de internet disponibles por ISP</Heading>
        <PlansByProvidersContainer />
      </Flex>
    </>
  );
}
