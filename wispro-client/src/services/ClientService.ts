import axios, { AxiosResponse } from "axios";
import { environment } from "../utils/Environment";

export interface Client {
  username: string;
  password: string;
  password_confirmation: string;
  first_name: string;
  last_name: string;
}

export async function login(username: string, password: string) {
  const response: AxiosResponse = await axios.post(
    `${environment.api_url}/auth/login`,
    { username, password }
  );

  const client = response.data["client"] as Client;

  axios.defaults.headers.common["Authorization"] = "Bearer " + player._id.$oid;
  setUser(player);
  return response;
}

export async function register(username: string, password: string) {
  const response: AxiosResponse = await axios.post(
    `${environment.server_url}/players`,
    { username, password }
  );
  const player = response.data["player"] as Player;

  axios.defaults.headers.common["Authorization"] = "Bearer " + player._id.$oid;
  setUser(player);
  return response;
}
