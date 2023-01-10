import axios from "axios";
import { cleanupCurrentClient, setCurrentClient } from "../store/ClientStore";
import { environment } from "../utils/Environment";

export interface Client {
  username: string;
  password: string;
  password_confirmation: string;
  first_name: string;
  last_name: string;
}

export interface Token {
  token: string;
}

export async function login(username: string, password: string) {
  const res = await axios.post(environment.api_url + "/auth/login", {
    username,
    password,
  });

  const token = res.data["token"];
  axios.defaults.headers.common.Authorization = token;

  await setClient();

  return res;
}

async function setClient() {
  const res = await axios.get(environment.api_url + "/clients/current");
  const client = res.data["client"];
  setCurrentClient(client);
}

export async function register(client: Client) {
  const res = await axios.post(environment.api_url + "/clients", { client });
  return res;
}

export async function logout() {
  axios.defaults.headers.common.Authorization = "";
  cleanupCurrentClient();
}
