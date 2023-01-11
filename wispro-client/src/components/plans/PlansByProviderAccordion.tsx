import { Accordion } from "@chakra-ui/react";
import { Provider } from "../../services/ProviderService";
import ProviderAccordionItem from "./ProviderAccordionItem";

interface Props {
  providers: Provider[];
}

export default function PlansByProviderAccordion(props: Props) {
  return (
    <Accordion allowMultiple>
      {props.providers.map((provider) => (
        <ProviderAccordionItem key={provider.id} provider={provider} />
      ))}
    </Accordion>
  );
}
