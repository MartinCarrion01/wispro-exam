import {
  AccordionButton,
  AccordionItem,
  AccordionPanel,
  Box,
  Center,
  Heading,
} from "@chakra-ui/react";
import { Provider } from "../../services/ProviderService";
import AlertMessage from "../common/AlertMessage";
import PlanItem from "./PlanItem";

interface Props {
  provider: Provider;
}

const noPlansMessage = () => {
  return (
    <>
      <Center>
        <AlertMessage
          status="warning"
          description="No se encontro ningún resultado"
          width="md"
        />
      </Center>
    </>
  );
};

export default function ProviderAccordionItem(props: Props) {
  return (
    <AccordionItem>
      <AccordionButton>
        <Box as="span" textAlign="left">
          <Heading size="xl">{props.provider.name}</Heading>
        </Box>
      </AccordionButton>
      <AccordionPanel>
        {props.provider.plans.length > 0
          ? props.provider.plans.map((plan) => (
              <PlanItem key={plan.id} plan={plan} />
            ))
          : noPlansMessage()}
      </AccordionPanel>
    </AccordionItem>
  );
}
