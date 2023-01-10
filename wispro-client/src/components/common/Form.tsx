import { Flex } from "@chakra-ui/react";

interface Props {
  children?: JSX.Element | JSX.Element[];
}

export default function Form(props: Props) {
  return (
    <form>
      <Flex direction="column" align="center" justify="center" w="auto">
        {props.children}
      </Flex>
    </form>
  );
}
