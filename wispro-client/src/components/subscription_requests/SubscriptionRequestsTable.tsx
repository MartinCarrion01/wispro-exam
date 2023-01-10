import { Table, TableCaption, Tbody, Th, Thead, Tr } from "@chakra-ui/react";
import { SubscriptionRequest } from "../../services/SubscriptionRequestService";

interface Props{
    subscription_request: SubscriptionRequest[]
}
export default function SubscriptionRequestsTable(){
    return(
        <Table variant="simple">
        <Thead>
          <Tr>
            <Th>Numero de solicitud</Th>
            <Th>Plan solicitado</Th>
            <Th>Proveedor</Th>
            <Th>Estado de la solicitud</Th>
            <Th>Fecha de creación</Th>
          </Tr>
        </Thead>
        <Tbody>
        </Tbody>
      </Table>
    )
}