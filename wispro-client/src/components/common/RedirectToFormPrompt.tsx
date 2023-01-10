import { Flex, Link, Text } from "@chakra-ui/react";
import { Link as ReactRouterLink } from "react-router-dom";

interface Props {
  auxiliaryText: string;
  linkText: string;
  redirectRoute: string;
}

export default function RedirectToFormPrompt(props: Props) {
  return (
    <Flex direction="row" align="center" justify="center" w="100%" mt="2">
      <Text>
        {props.auxiliaryText}
        <Link
          color="teal.500"
          as={ReactRouterLink}
          to={`/${props.redirectRoute}`}
        >
          {props.linkText}
        </Link>
      </Text>
    </Flex>
  );
}
