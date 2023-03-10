import { useLayoutEffect, useState } from "react";
import { Subject } from "rxjs";
import { Client } from "../services/ClientService";

let currentClient: Client| undefined;

const clientSubject = new Subject<Client | undefined>();

export function useSessionClient() {
  const [client, setClient] = useState(currentClient);

  useLayoutEffect(() => {
    clientSubject.subscribe((newState) => {
      setClient(newState);
    });
  }, []);

  return client;
}

export function setCurrentClient(client: Client) {
  currentClient = client;
  clientSubject.next(currentClient);
}

export function cleanupCurrentClient() {
  currentClient = undefined;
  clientSubject.next(currentClient);
}