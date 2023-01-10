import { Link, useColorModeValue } from "@chakra-ui/react";
import { Link as ReactRouterLink } from "react-router-dom";

interface Props {
  name: string;
  route: string;
}

export default function NavLink(props: Props) {
  return (
    <Link
      px={2}
      py={1}
      rounded={"md"}
      _hover={{
        textDecoration: "none",
        bg: useColorModeValue("gray.200", "gray.700"),
      }}
      as={ReactRouterLink}
      to={props.route}
      fontSize={"lg"}
    >
      {props.name}
    </Link>
  );
}
