import { Flex, Heading} from "@chakra-ui/react";
import SubscriptionRequestsTab from "../components/subscription_requests/SubscriptionRequestsTab";

export default function SubscriptionRequests() {
  return (
    <>
      <Flex direction="column" mx="5" my="10" gap="2">
        <Heading size="lg">Tus solicitudes de contratacion de planes</Heading>
        <SubscriptionRequestsTab/>
      </Flex>
    </>
  );
}
