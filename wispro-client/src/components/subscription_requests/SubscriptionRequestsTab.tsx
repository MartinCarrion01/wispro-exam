import { Tab, TabList, TabPanels, TabPanel, Tabs } from "@chakra-ui/react";
import { useEffect, useState } from "react";
import { SubscriptionRequest } from "../../services/SubscriptionRequestService";
import SubscriptionRequestsTable from "./SubscriptionRequestsTable";

export default function SubscriptionRequestsTab() {
  const [tabIndex, setTabIndex] = useState<number>(0);
  const [loading, setLoading] = useState<boolean>(true);
  const [subscriptionRequests, setSubscriptionRequests] = useState<SubscriptionRequest[]>([])

  const getSubscriptionRequests = async () => {
    try {
        
    } catch (error: any) {
      setLoading(false);
    }
  };

  useEffect(() => {
    getSubscriptionRequests();
  }, []);

  return (
    <Tabs isLazy onChange={(index) => setTabIndex(index)}>
      <TabList>
        <Tab>Todas tus solicitudes</Tab>
        <Tab>Tus solicitudes rechazadas en el último mes</Tab>
      </TabList>
      <TabPanels>
        <TabPanel>
          <SubscriptionRequestsTable />
        </TabPanel>
        <TabPanel>
          <p>two!</p>
        </TabPanel>
      </TabPanels>
    </Tabs>
  );
}
