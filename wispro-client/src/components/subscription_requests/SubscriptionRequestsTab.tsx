import {
  Tab,
  TabList,
  TabPanels,
  TabPanel,
  Tabs,
  Center,
} from "@chakra-ui/react";
import { useEffect, useState } from "react";
import {
  get_all_requests,
  get_rejected_requests,
  SubscriptionRequest,
} from "../../services/SubscriptionRequestService";
import AlertMessage from "../common/AlertMessage";
import Loading from "../common/Loading";
import SubscriptionRequestsTable from "./SubscriptionRequestsTable";

export default function SubscriptionRequestsTab() {
  const [loading, setLoading] = useState<boolean>(true);
  const [subscriptionRequests, setSubscriptionRequests] = useState<
    SubscriptionRequest[]
  >([]);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const getSubscriptionRequests = async () => {
    try {
      const res = await get_all_requests();
      const requests = res.data[
        "subscription_requests"
      ] as SubscriptionRequest[];
      setSubscriptionRequests(requests);
      setLoading(false);
    } catch (error: any) {
      setErrorMessage(error.response.data.message);
      setLoading(false);
    }
  };

  useEffect(() => {
    getSubscriptionRequests();
  }, []);

  const handleTabChange = async (index: number) => {
    switch (index) {
      case 0:
        setLoading(true);
        try {
          const res = await get_all_requests();
          const all_requests = res.data[
            "subscription_requests"
          ] as SubscriptionRequest[];
          setSubscriptionRequests(all_requests);
          setLoading(false);
        } catch (error: any) {
          setErrorMessage(error.response.data.message);
          setLoading(false);
        }
        break;
      case 1:
        setLoading(true);
        try {
          const res = await get_rejected_requests();
          const rejected_requests = res.data[
            "subscription_requests"
          ] as SubscriptionRequest[];
          setSubscriptionRequests(rejected_requests);
          setLoading(false);
        } catch (error: any) {
          setErrorMessage(error.response.data.message);
          setLoading(false);
        }
        break;
      default:
        break;
    }
  };

  const renderRequestsOrNoRequests = () => {
    if (subscriptionRequests.length > 0) {
      return (
        <SubscriptionRequestsTable
          subscriptions_requests={subscriptionRequests}
        />
      );
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
        <AlertMessage
          status="warning"
          description={errorMessage}
          width="4xl"
        />
      </Center>
    );
  };

  return (
    <Tabs isLazy onChange={(index) => handleTabChange(index)}>
      <TabList>
        <Tab isDisabled={loading}>Todas tus solicitudes</Tab>
        <Tab isDisabled={loading}>
          Tus solicitudes rechazadas en el último mes
        </Tab>
      </TabList>
      <TabPanels>
        <TabPanel>
          {loading ? <Loading /> : (errorMessage ? renderError() : renderRequestsOrNoRequests())}
        </TabPanel>
        <TabPanel>
          {loading ? <Loading /> : (errorMessage ? renderError() : renderRequestsOrNoRequests())}
        </TabPanel>
      </TabPanels>
    </Tabs>
  );
}
