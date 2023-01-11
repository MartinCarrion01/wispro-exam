import axios from "axios";
import { environment } from "../utils/Environment";

export interface Plan {
    id: string,
    description: string,
}
export interface Provider {
    id: string,
    name: string,
    plans: Plan[]
}

export async function get_providers() {
  const res = await axios.get(environment.api_url + "/providers/get_plans");
  return res;
}
