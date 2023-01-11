import { Center } from "@chakra-ui/react";
import { useEffect, useState } from "react";
import { get_providers, Provider } from "../../services/ProviderService";
import AlertMessage from "../common/AlertMessage";
import Loading from "../common/Loading";
import PlansByProviderAccordion from "./PlansByProviderAccordion";

export default function PlansByProvidersContainer() {
  const [loading, setLoading] = useState<boolean>(true);
  const [providers, setProviders] = useState<Provider[]>([]);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const getProviders = async () => {
    try {
      const res = await get_providers();
      const providers = res.data["providers"] as Provider[];
      setProviders(providers);
      setLoading(false);
    } catch (error: any) {
      setErrorMessage(error.response.data.message);
      setLoading(false);
    }
  };

  useEffect(() => {
    getProviders();
  }, []);

  const renderProvidersOrNot = () => {
    if (providers.length > 0) {
      return <PlansByProviderAccordion providers={providers} />;
    } else {
      return (
        <Center>
          <AlertMessage
            status="warning"
            description="No se encontro ningún resultado"
            width="4xl"
          />
        </Center>
      );
    }
  };

  const renderError = () => {
    return (
      <Center>
        <AlertMessage status="warning" description={errorMessage} width="4xl" />
      </Center>
    );
  };

  return (
    <>
      {loading ? (
        <Loading />
      ) : errorMessage ? (
        renderError()
      ) : (
        renderProvidersOrNot()
      )}
    </>
  );
}
