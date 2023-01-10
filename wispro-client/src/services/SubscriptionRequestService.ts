import axios from "axios";
import { environment } from "../utils/Environment";

export interface SubscriptionRequest {
  id: string;
  status: string;
  create_date: string;
  plan: {
    description: string;
    provider: {
      name: string;
    };
  };
}

export async function get_all_requests() {
  const res = await axios.get(
    environment.api_url + "/subscription_requests"
  );

  return res;
}

export async function get_rejected_requests() {
  const res = await axios.get(
    environment.api_url + "/subscription_requests/rejected_last_month"
  );

  return res;
}
