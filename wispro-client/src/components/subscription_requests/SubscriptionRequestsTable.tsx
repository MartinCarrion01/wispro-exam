import {
  Table,
  Tbody,
  Td,
  Th,
  Thead,
  Tr,
} from "@chakra-ui/react";
import { SubscriptionRequest } from "../../services/SubscriptionRequestService";

interface Props {
  subscriptions_requests: SubscriptionRequest[];
}

const status = {
  pending: "Pendiente de revisión",
  approved: "Aprobada",
  rejected: "Rechazada",
};

const mapToTableRow = (req: SubscriptionRequest) => {
  return (
    <Tr key={req.id}>
      <Td>{req.id}</Td>
      <Td>{req.plan.description}</Td>
      <Td>{req.plan.provider.name}</Td>
      <Td>{status[req.status as keyof typeof status]}</Td>
      <Td>{req.create_date}</Td>
    </Tr>
  );
};

export default function SubscriptionRequestsTable(props: Props) {
  return (
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
        {props.subscriptions_requests.map((element) => mapToTableRow(element))}
      </Tbody>
    </Table>
  );
}
