import { Center, Heading } from "@chakra-ui/react";

interface Props {
  title: string;
  color: string & {};
}

export default function Title(props: Props) {
  return (
    <>
      <Center color={props.color} my={5}>
        <Heading as="h1" size="4xl" noOfLines={1}>
          {props.title}
        </Heading>
      </Center>
    </>
  );
}
